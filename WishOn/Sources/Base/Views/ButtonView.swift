//
//  ButtonView.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI

struct ButtonViewState {
    let label: String
    let action: () -> Void
}

struct ButtonView: View {
    let buttonViewState: ButtonViewState
    
    var body: some View {
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

