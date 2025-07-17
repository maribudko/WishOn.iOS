//
//  Wish.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

struct Wish: Codable, Identifiable {
    let id: UUID
    let name: String
    let image: String
    let price: Double?
    let currency: String
    let link: String
    let isTaken: Bool
}

extension Wish {
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
