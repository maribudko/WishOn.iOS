//
//  Wish.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

struct Wish: Codable, Identifiable {
    var id = UUID()
    let name: String
    let image: String
    var price: Double?
    let currency: String
    let link: String
    var isSelected: Bool = false
}
