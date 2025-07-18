//
//  WishListModel.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

public struct WishList: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let image: String?
    public let eventDate: Date?
    public let wishes: [Wish]
    public let description: String?
    public let createdAt: Date?
    
    public init(id: UUID, name: String, image: String?, eventDate: Date?, wishes: [Wish], description: String?, createdAt: Date?) {
        self.id = id
        self.name = name
        self.image = image
        self.eventDate = eventDate
        self.wishes = wishes
        self.description = description
        self.createdAt = createdAt
    }
}
