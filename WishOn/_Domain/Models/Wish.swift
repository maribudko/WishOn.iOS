//
//  Wish.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

struct Wish: Codable, Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var price: Double?
    var currency: String
    var link: String
    var isSelected: Bool = false
}
