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
    public let fill: Color?
    public let titleColor: Color?
    
    public init(buttonViewState: ButtonViewState, fill: Color? = nil, titleColor: Color? = nil) {
        self.buttonViewState = buttonViewState
        self.fill = fill
        self.titleColor = titleColor
    }
    
    public var body: some View {
        Button {
            buttonViewState.action()
        } label: {
            Text(buttonViewState.label)
                .padding(.horizontal, AppPaddings.padding16)
                .foregroundStyle(titleColor ?? Color(Asset.greenButtonTextColor.color))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(fill ?? Color(Asset.primaryColor.color))
        .cornerRadius(AppRadiuses.buttonRadius)
        .padding(.top, AppPaddings.padding20)
    }
}

#Preview {
    let viewState = ButtonViewState(label: L10n.createLabel) {}
    
    ButtonView(buttonViewState: viewState)
}

