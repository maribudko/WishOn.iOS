//
//  AddNewitemModule.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

public struct AddNewItemModule {
    public let stateMachine: AddNewItemStateMachine
    public let stateFactory: AddNewItemStateFactory
    
    public func view(isShown: Binding<Bool>) -> some View {
        let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        viewModel.onSuccess = {
            withAnimation {
                isShown.wrappedValue = false
            }
        }
        return AddNewItemView(isShown: isShown, viewModel: viewModel)
    }
}
