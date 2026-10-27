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
                    let wishLists = documents.map { document -> WishList in
                        debugPrint("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        let id = UUID(uuidString: document.documentID) ?? UUID()
                        let name = data[Constant.name] as? String ?? ""
                        let description = data[Constant.description] as? String ?? ""
                        let ownerUid = data[Constant.ownerUid] as? String
                        // TODO: add remaining fields to firestore DB mapping
                        return WishList(
                            id: id,
                            name: name,
                            image: "",
                            eventDate: Date(),
                            wishes: [],
                            description: description,
                            createdAt: Date(),
                            ownerUid: ownerUid
                        )
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
            var data = try Firestore.Encoder().encode(wishList)
            // Always stamp ownership from the signed-in user (do not trust client-supplied ownerUid).
            data[Constant.ownerUid] = uid
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

private extension WishListRepository {
    enum Constant {
        static let wishListPath = "wishList"
        static let name = "name"
        static let description = "description"
        static let ownerUid = "ownerUid"
    }
}
