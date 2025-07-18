//
//  ButtonView.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI
import WOResources

public struct ButtonViewState {
    public let label: String
    public let action: () -> Void
    
    public init(label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
}

public struct ButtonView: View {
    public let buttonViewState: ButtonViewState
    
    public init(buttonViewState: ButtonViewState) {
        self.buttonViewState = buttonViewState
    }
    
    public var body: some View {
        Button {
            buttonViewState.action()
        } label: {
            Text(buttonViewState.label)
                .padding(.horizontal, AppPaddings.padding16)
                .foregroundStyle(Color(Asset.greenButtonTextColor.color))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(Asset.primaryColor.color))
        .cornerRadius(AppRadiuses.buttonRadius)
        .padding(.top, AppPaddings.padding20)
    }
}

#Preview {
    let viewState = ButtonViewState(label: L10n.createLabel) {}
    
    ButtonView(buttonViewState: viewState)
}

