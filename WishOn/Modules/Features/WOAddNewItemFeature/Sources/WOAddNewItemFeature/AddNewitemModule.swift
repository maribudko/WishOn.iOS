//
//  AddNewitemModule.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI
import WOCore

public struct AddNewItemModule {
    public let stateMachine: AddNewItemStateMachine
    public let stateFactory: AddNewItemStateFactory
    
    public func view(isShown: Binding<Bool>, onWishCreated: @escaping (Wish) -> Void = { _ in }) -> some View {
        let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        viewModel.onSuccess = {
            let wish = viewModel.createdWish
            withAnimation {
                isShown.wrappedValue = false
            }
            if let wish {
                onWishCreated(wish)
            }
        }
        return AddNewItemView(isShown: isShown, viewModel: viewModel)
    }
}
