//
//  AppShadows.swift
//  WishOn
//
//  Created by Mari Budko on 12.04.2025.
//

import SwiftUI

public struct AppShadowStyle: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

public struct AppShadows {
    public static let medium = AppShadowStyle(color: Color.black.opacity(0.1), radius: 1.0, x: 0.0, y: 1.0)
    public static let small = AppShadowStyle(color: Color.black.opacity(0.05), radius: 1.0, x: 0.0, y: 1.0)

    /// Soft elevation for WishLists home-grid tiles on a light canvas.
    public static let homeGridCard = AppShadowStyle(
        color: Color.black.opacity(AppOpacityLevels.homeGridCardShadow),
        radius: 6.0,
        x: 0.0,
        y: 2.0
    )

    public static func homeGridFAB(accent: Color) -> AppShadowStyle {
        AppShadowStyle(
            color: accent.opacity(AppOpacityLevels.homeGridFABShadow),
            radius: 8.0,
            x: 0.0,
            y: 4.0
        )
    }
}
