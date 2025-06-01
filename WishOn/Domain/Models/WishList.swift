//
//  WishListModel.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

struct WishList: Identifiable, Codable {
    let id: UUID
    let name: String
    let image: String?
    let eventDate: Date?
    let wishes: [Wish]
    let description: String?
    let createdAt: Date?
}
