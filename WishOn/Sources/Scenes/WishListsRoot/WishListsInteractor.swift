//
//  WishListsInteractor.swift
//  WishOn
//
//  Created by Mari Budko on 21.05.2025.
//

import Combine

protocol WishListUseCase {
    func fetchWishLists() -> AnyPublisher<[WishList], Error>
    func addWishList(_ wishList: WishList) -> AnyPublisher<Void, Error>
    func deleteWishList(_ id: String) -> AnyPublisher<Void, Error>
}

final class WishListsInteractor: WishListUseCase {
    private let repository: WishListRepositoryProtocol
    
    init(repository: WishListRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchWishLists() -> AnyPublisher<[WishList], any Error> {
        repository.fetchWishLists()
    }
    
    func addWishList(_ wishList: WishList) -> AnyPublisher<Void, any Error> {
        repository.addWishList(wishList)
    }
    
    func deleteWishList(_ id: String) -> AnyPublisher<Void, any Error> {
        repository.deleteWishList(id)
    }
    
    
}
