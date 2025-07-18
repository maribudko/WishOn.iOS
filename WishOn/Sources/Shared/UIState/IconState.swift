//
//  IconState.swift
//  WishOn
//
//  Created by Mari Budko on 18.06.2025.
//

import Foundation

final class IconState {
    let icon: IconRepresentable
    let isResizable: Bool?
    
    init(icon: IconRepresentable, isResizable: Bool? = false) {
        self.icon = icon
        self.isResizable = isResizable
    }
}
