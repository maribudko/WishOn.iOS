//
//  MockWishListEmptyRepository.swift
//  WishOn
//
//  Created by Mari Budko on 04.02.2025.
//

import Foundation
import Combine

// CR: продакшн додаток взагалі не має мати цього коду, тільки тестовий 
class MockWishListEmptyRepository: WishListRepositoryProtocol {
    func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    public var list: [WishList] = []
    func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        Just(list)
            .setFailureType(to: Error.self) // Converting to error type
            .eraseToAnyPublisher()
    }
    
    func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        // Finishing publishing without errors
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
