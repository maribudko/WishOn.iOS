//
//  MockWishListRepository.swift
//  WishOnTests
//
//  Created by Mari Budko on 03.02.2025.
//

import Foundation
import Combine

class MockWishListRepository: WishListRepositoryProtocol {
    static public let id = UUID()
    
    public var list: [WishList] = [WishList(id: id,
                                            name: "some name",
                                            image: "",
                                            eventDate: Date.now,
                                            wishes: [],
                                            description: "Description",
                                            createdAt: Date.now)]
    public var isAddWishListCalled = false
    public var isDeleteWishListCalled = false
    
    func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        Just(list)
            .setFailureType(to: Error.self) // Converting to error type
            .eraseToAnyPublisher()
    }
    
    func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        isAddWishListCalled = true
        // Finishing publishing without errors
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        isDeleteWishListCalled = true
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
