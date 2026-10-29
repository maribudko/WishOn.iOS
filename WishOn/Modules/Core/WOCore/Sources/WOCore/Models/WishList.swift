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
    public let avatar: String?
    public let eventDate: Date?
    public let wishes: [Wish]
    public let description: String?
    public let createdAt: Date?
    /// Firebase Auth uid of the document owner. Written by `WishListRepository` on create.
    public let ownerUid: String?
    
    public init(
        id: UUID,
        name: String,
        image: String?,
        avatar: String? = nil,
        eventDate: Date?,
        wishes: [Wish],
        description: String?,
        createdAt: Date?,
        ownerUid: String? = nil
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.avatar = avatar
        self.eventDate = eventDate
        self.wishes = wishes
        self.description = description
        self.createdAt = createdAt
        self.ownerUid = ownerUid
    }
}
