//
//  MockWishListRepository.swift
//  WishOnTests
//
//  Created by Mari Budko on 03.02.2025.
//

import Foundation

class MockWishListRepository: WishListRepositoryProtocol {
    public var list: [WishList] = [WishList(name: "Some Name", eventDate: Date.now, wishes: [])]
    
    func fetchWishList() async throws -> [WishList] {
       return list
    }
}
