//
//  Gift.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

struct Gift: Codable, Identifiable {
    var id: UUID = UUID()
        var name: String
        var isPurchased: Bool = false
        var reservedBy: String?
        var price: Double?  
        var link: String?
}
