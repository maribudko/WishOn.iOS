//
//  AddNewitemModule.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

struct AddNewItemModule: BaseSwiftUIModule {
    @Binding var isShown: Bool
    
    func view() -> some View {
        let stateMachine = AddNewItemStateMachine()
        let viewStateFactory = AddNewItemStateFactory()
        let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: viewStateFactory)
        viewModel.onSuccess = {
            withAnimation {
                isShown = false
            }
        }
        
        return AddNewItemView(isShown: $isShown, viewModel: viewModel)
    }
}
