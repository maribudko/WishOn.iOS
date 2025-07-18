//
//  WishListsInteractor.swift
//  WishOn
//
//  Created by Mari Budko on 21.05.2025.
//

import Combine
import WOCore

public protocol WishListUseCase {
    func fetchWishLists() -> AnyPublisher<[WishList], Error>
    func addWishList(_ wishList: WishList) -> AnyPublisher<Void, Error>
    func deleteWishList(_ id: String) -> AnyPublisher<Void, Error>
}

public final class WishListsInteractor: WishListUseCase {
    private let repository: WishListRepositoryProtocol
    
    public init(repository: WishListRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        repository.fetchWishLists()
    }
    
    public func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        repository.addWishList(wishList)
    }
    
    public func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        repository.deleteWishList(id)
    }
    
    
}
