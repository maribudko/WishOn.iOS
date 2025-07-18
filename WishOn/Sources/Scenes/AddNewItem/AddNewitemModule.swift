//
//  AddNewitemModule.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

struct AddNewItemModule {
    let stateMachine: AddNewItemStateMachine
    let stateFactory: AddNewItemStateFactory
    
    func view(isShown: Binding<Bool>) -> some View {
        let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        viewModel.onSuccess = {
            withAnimation {
                isShown.wrappedValue = false
            }
        }
        return AddNewItemView(isShown: isShown, viewModel: viewModel)
    }
}
