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
    var gifts: [Gift]
    var isSelected: Bool = false
    var description: String?
    var createdAt: Date = Date()
    var color: String = Asset.alertColor.name
}
