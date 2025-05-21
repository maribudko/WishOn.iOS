//
//  ButtonView.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI

struct ButtonViewState {
    let label: String
}

struct ButtonView: View {
    let buttonViewState: ButtonViewState
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
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
    ButtonView(buttonViewState: ButtonViewState(label: L10n.createLabel)) {
        
    }
}

