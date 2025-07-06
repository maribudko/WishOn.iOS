//
//  NavigationLinkButton.swift
//  WishOn
//
//  Created by Mari Budko on 21.05.2025.
//

import SwiftUI
import WOResources

public struct NavigationLinkButtonViewState {
    let label: String
    let accessibilityId: String
    let color: ButtonColor
    
    public init(label: String, accessibilityId: String, color: ButtonColor) {
        self.label = label
        self.accessibilityId = accessibilityId
        self.color = color
    }
}

public enum ButtonColor {
    case green
    case grey
}

public struct NavigationLinkButton: View {
    let viewState: NavigationLinkButtonViewState
    
    public init(viewState: NavigationLinkButtonViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        Text(viewState.label)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(getColor(color: viewState.color)))
            .foregroundColor(.white)
            .accessibilityIdentifier(viewState.accessibilityId)
    }
    
    func getColor(color: ButtonColor) -> Color {
        switch color {
        case .green:
            return Color(Asset.primaryColor.color)
        case .grey:
            return Color(Asset.secondaryColor.color)
        }
    }
}
