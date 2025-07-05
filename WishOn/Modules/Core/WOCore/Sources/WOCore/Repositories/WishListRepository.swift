//
//  FireStoreWishListRepository.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import FirebaseFirestore
import Combine

public class WishListRepository: WishListRepositoryProtocol, ObservableObject {
    @Published var wishLists: [WishList] = []
    private let db = Firestore.firestore()
    
    public init() {}
    
    public func fetchWishLists() -> AnyPublisher<[WishList], Error> {
        return Future<[WishList], any Error> { promise in
            self.getDocumentsFromFirestore(promise)
        }
        .eraseToAnyPublisher()
    }
    
    fileprivate func getDocumentsFromFirestore(_ promise: @escaping (Result<[WishList], any Error>) -> Void) {
        Firestore.firestore().collection(Constant.wishListPath).getDocuments { snapshot, error in
            if let error = error {
                promise(.failure(error))
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                var tempList: [WishList] = []
                for document in snapshot.documents {
                    debugPrint("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let name = data[Constant.name] as? String ?? ""
                    let description = data[Constant.description] as? String ?? ""
                    // TODO: add fields to firestore DB
                    let wishList = WishList(id: UUID(), name: name, image: "", eventDate: Date(), wishes: [], description: description, createdAt: Date())
                    tempList.append(wishList)
                }
                promise(.success(tempList))
            }
        }
    }
    
    public func addWishList(_ wishList: WishList) -> AnyPublisher<Void, Error> {
        let ref = Firestore.firestore().collection(Constant.wishListPath).document(wishList.id.uuidString)
        do {
            let data = try Firestore.Encoder().encode(wishList)
            return Future<Void, any Error> {promise in
                ref.setData(data) {error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
            .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    public func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        let ref = Firestore.firestore().collection(Constant.wishListPath).document(id)
        
        return Future<Void, any Error> { promise in
            ref.delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension WishListRepository {
    enum Constant {
        static let wishListPath = "wishList"
        static let name = "name"
        static let description = "description"
    }
}
