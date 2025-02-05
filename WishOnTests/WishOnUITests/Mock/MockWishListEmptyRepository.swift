//
//  MockWishListEmptyRepository.swift
//  WishOn
//
//  Created by Mari Budko on 04.02.2025.
//

import Foundation

class MockWishListEmptyRepository: WishListRepositoryProtocol {
    func fetchWishList() async throws -> [WishList] {
        return []
    }
    
    
}
