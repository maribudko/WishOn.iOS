//
//  HomeGridPalette.swift
//  WODesign
//
//  Light home-grid colors for the WishLists root screen.
//  Values live in WOResources Asset Catalog (`HomeGrid*` colorsets).
//

import SwiftUI
import WOResources

public enum HomeGridPalette {
    public static let background = Asset.homeGridBackground.swiftUIColor
    public static let card = Asset.homeGridCard.swiftUIColor
    public static let coverPlaceholder = Asset.homeGridCoverPlaceholder.swiftUIColor
    public static let accent = Asset.homeGridAccent.swiftUIColor
    public static let title = Asset.homeGridTitle.swiftUIColor
    public static let subtitle = Asset.homeGridSubtitle.swiftUIColor
    public static let inactiveTab = Asset.homeGridInactiveTab.swiftUIColor
    public static let icon = Asset.homeGridIcon.swiftUIColor
    /// Text / icon drawn on top of the home-grid accent (e.g. FAB plus).
    public static let onAccent = Asset.homeGridOnAccent.swiftUIColor
}
