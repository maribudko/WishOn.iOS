//
//  WishListModel.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

public enum WishListKind: String, Codable {
    case wishlist
    case list
}

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
    public let kind: WishListKind
    
    public init(
        id: UUID,
        name: String,
        image: String?,
        avatar: String? = nil,
        eventDate: Date?,
        wishes: [Wish],
        description: String?,
        createdAt: Date?,
        ownerUid: String? = nil,
        kind: WishListKind = .wishlist
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
        self.kind = kind
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
        eventDate = try container.decodeIfPresent(Date.self, forKey: .eventDate)
        wishes = try container.decodeIfPresent([Wish].self, forKey: .wishes) ?? []
        description = try container.decodeIfPresent(String.self, forKey: .description)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        ownerUid = try container.decodeIfPresent(String.self, forKey: .ownerUid)
        kind = try container.decodeIfPresent(WishListKind.self, forKey: .kind) ?? .wishlist
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(eventDate, forKey: .eventDate)
        try container.encode(wishes, forKey: .wishes)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(ownerUid, forKey: .ownerUid)
        try container.encode(kind, forKey: .kind)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, image, avatar, eventDate, wishes, description, createdAt, ownerUid, kind
    }
}
