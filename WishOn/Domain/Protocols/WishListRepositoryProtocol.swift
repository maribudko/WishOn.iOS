//
//  WishListRepositoryProtocol.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import Combine

protocol WishListRepositoryProtocol {
    func fetchWishLists() -> AnyPublisher<[WishList], Error>
    func addWishList(_ wishList: WishList) -> AnyPublisher<Void, Error> 
    func deleteWishList(_ id: String) -> AnyPublisher<Void, Error>
}

//
//protocol WishListRepositoryUseCaseProtocol {
//    func fetchWishLists(foreseUpdate: Bool) -> [WishList]
//}
//
//class WishListRepositoryUseCase: WishListRepositoryUseCaseProtocol {
//    
//    private var items: [WishList] = []
//    
//    func fetchWishLists(foreseUpdate: Bool) -> [WishList] {
//        if foreseUpdate {
//            // -> repo
//            return []
//        } else {
//            return items
//        }
//    }
//    
//}
