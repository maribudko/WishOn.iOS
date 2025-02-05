//
//  WishListRepositoryProtocol.swift
//  WishOn
//
//  Created by Mari Budko on 03.02.2025.
//

import Foundation

protocol WishListRepositoryProtocol {
    func fetchWishList()  async throws -> [WishList]
}
