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
    
    public init(id: UUID, name: String, image: String, price: Double?, currency: String, link: String, isTaken: Bool) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.currency = currency
        self.link = link
        self.isTaken = isTaken
    }
}

public extension Wish {
    func with(isTaken: Bool) -> Wish {
        return Wish(
            id: self.id,
            name: self.name,
            image: self.image,
            price: self.price,
            currency: self.currency,
            link: self.link,
            isTaken: isTaken
        )
    }
}
