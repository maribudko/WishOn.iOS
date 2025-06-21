//
//  WishListsModule.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI
import WODesign

struct WishListsModule: BaseSwiftUIModule {
    let stateMachine: WishListsStateMachine
    let stateFactory: WishListsStateFactory
    let useCase: WishListUseCase
    
    func view() -> some View {
        let viewModel = WishListViewModel(
            stateMachine: stateMachine,
            stateFactory: stateFactory,
            useCase: useCase
        )
        return WishListRootView(viewModel: viewModel)   
    }
}
