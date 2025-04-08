//
//  WishListModel.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import Foundation

struct WishList: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var image: String?
    var eventDate: Date?
    var wishes: [Wish]
    var isSelected: Bool = false
    var description: String?
    var createdAt: Date = Date()
    #if DEBUG
    var color: String = "HighLightColor"
    #else
    var color: String = Asset.highLightColor.name
    #endif
}
