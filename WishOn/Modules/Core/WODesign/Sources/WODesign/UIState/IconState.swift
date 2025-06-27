//
//  IconState.swift
//  WishOn
//
//  Created by Mari Budko on 18.06.2025.
//

import Foundation
import WOResources

public final class IconState {
    public let icon: IconRepresentable
    public let isResizable: Bool?
    
    public init(icon: IconRepresentable, isResizable: Bool? = false) {
        self.icon = icon
        self.isResizable = isResizable
    }
}
