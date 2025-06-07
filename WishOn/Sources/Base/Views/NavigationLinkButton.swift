//
//  NavigationLinkButton.swift
//  WishOn
//
//  Created by Mari Budko on 21.05.2025.
//

import SwiftUI

struct NavigationLinkButtonViewState {
    let label: String
    let accessibilityId: String
    let color: ButtonColor
}

enum ButtonColor {
    case green
    case grey
}

struct NavigationLinkButton: View {
    let viewState: NavigationLinkButtonViewState
    
    var body: some View {
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
