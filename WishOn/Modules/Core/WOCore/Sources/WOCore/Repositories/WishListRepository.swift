//
//  FireStoreWishListRepository.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

public class WishListRepository: WishListRepositoryProtocol, ObservableObject {
    public enum RepositoryError: LocalizedError {
        case notAuthenticated
        
        public var errorDescription: String? {
            switch self {
            case .notAuthenticated:
                return "User must be signed in to access wish lists."
            }
        }
    }
    
    @Published var wishLists: [WishList] = []
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetchWishLists() -> AnyPublisher<[WishList], Error> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return Fail(error: RepositoryError.notAuthenticated)
                .eraseToAnyPublisher()
        }
        
        return Future<[WishList], Error> { promise in
            self.db.collection(Constant.wishListPath)
                .whereField(Constant.ownerUid, isEqualTo: uid)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    let documents = snapshot?.documents ?? []
                    let wishLists = documents.compactMap { document -> WishList? in
                        WishListFirestoreMapping.decode(document.data(), documentID: document.documentID)
                    }
                    promise(.success(wishLists))
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    public func addWishList(_ wishList: WishList) -> AnyPublisher<Void, Error> {
        guard let uid = Auth.auth().currentUser?.uid else {
            return Fail(error: RepositoryError.notAuthenticated)
                .eraseToAnyPublisher()
        }
        
        let ref = db.collection(Constant.wishListPath).document(wishList.id.uuidString)
        do {
            let data = try WishListFirestoreMapping.encode(wishList, ownerUid: uid)
            return Future<Void, Error> { promise in
                ref.setData(data) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    public func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        guard Auth.auth().currentUser?.uid != nil else {
            return Fail(error: RepositoryError.notAuthenticated)
                .eraseToAnyPublisher()
        }
        
        let ref = db.collection(Constant.wishListPath).document(id)
        
        return Future<Void, any Error> { promise in
            ref.delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

enum WishListFirestoreMapping {
    static func encode(_ wishList: WishList, ownerUid: String) throws -> [String: Any] {
        var data = try encoder.encode(wishList)
        data[Field.ownerUid] = ownerUid
        return data
    }
    
    static func decode(_ data: [String: Any], documentID: String) -> WishList? {
        var payload = data
        payload[Field.id] = documentID
        if let wishList = try? decoder.decode(WishList.self, from: payload) {
            return wishList
        }
        
        guard let name = data[Field.name] as? String else {
            return nil
        }
        return WishList(
            id: UUID(uuidString: documentID) ?? UUID(),
            name: name,
            image: data[Field.image] as? String,
            avatar: data[Field.avatar] as? String,
            eventDate: (data[Field.eventDate] as? Timestamp)?.dateValue(),
            wishes: [],
            description: data[Field.description] as? String,
            createdAt: (data[Field.createdAt] as? Timestamp)?.dateValue(),
            ownerUid: data[Field.ownerUid] as? String,
            kind: WishListKind(rawValue: data[Field.kind] as? String ?? "") ?? .wishlist
        )
    }
    
    private enum Field {
        static let id = "id"
        static let name = "name"
        static let description = "description"
        static let ownerUid = "ownerUid"
        static let image = "image"
        static let avatar = "avatar"
        static let eventDate = "eventDate"
        static let createdAt = "createdAt"
        static let kind = "kind"
    }
    
    private static let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.dateEncodingStrategy = .timestamp
        return encoder
    }()
    
    private static let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.dateDecodingStrategy = .timestamp
        return decoder
    }()
}

private extension WishListRepository {
    enum Constant {
        static let wishListPath = "wishList"
        static let ownerUid = "ownerUid"
    }
}
