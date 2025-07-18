//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 18.07.2025.
//
import Foundation
import Combine

public final class FakeWishListRepository: WishListRepositoryProtocol {
    
    public init() {}
    
    public func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        let testData = [
            WishList(id: UUID(), name: "Birthday", image: "", eventDate: Date(), wishes: [], description: "Birthday gifts", createdAt: Date()),
            WishList(id: UUID(), name: "New Year", image: "", eventDate: Date(), wishes: [], description: "New Year gifts", createdAt: Date())
        ]
        
        return Just(testData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
