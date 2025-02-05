//
//  WishListModel.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import SwiftUI

struct WishList: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var imageUrl: String?
    var eventDate: Date
    var wishes: [Wish]
    var isSelected: Bool = false
    var description: String?
    var createdAt: Date = Date()
    #if DEBUG
    var color: String = "#FF5733"
    #else
    var color: String = Asset.alertColor.name
    #endif
    
    
}
