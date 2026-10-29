//
//  Wish.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

public struct Wish: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let image: String
    public let price: Double?
    public let currency: String
    public let link: String
    public let isTaken: Bool
    /// Owner marked a personal-list item done or bought. Gift wishlists leave this false.
    public let isCompleted: Bool
    
    public init(
        id: UUID,
        name: String,
        image: String,
        price: Double?,
        currency: String,
        link: String,
        isTaken: Bool,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.currency = currency
        self.link = link
        self.isTaken = isTaken
        self.isCompleted = isCompleted
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        isTaken = try container.decodeIfPresent(Bool.self, forKey: .isTaken) ?? false
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(image, forKey: .image)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encode(currency, forKey: .currency)
        try container.encode(link, forKey: .link)
        try container.encode(isTaken, forKey: .isTaken)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, image, price, currency, link, isTaken, isCompleted
    }
}

public extension Wish {
    func with(isTaken: Bool) -> Wish {
        copy(isTaken: isTaken, isCompleted: isCompleted)
    }
    
    func with(isCompleted: Bool) -> Wish {
        copy(isTaken: isTaken, isCompleted: isCompleted)
    }
    
    private func copy(isTaken: Bool, isCompleted: Bool) -> Wish {
        Wish(
            id: id,
            name: name,
            image: image,
            price: price,
            currency: currency,
            link: link,
            isTaken: isTaken,
            isCompleted: isCompleted
        )
    }
}
