//
//  WishListsModule.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI

struct WishListsModule: BaseSwiftUIModule {
    
    func view() -> some View {
        let stateMachine = WishListsStateMachine()
        let viewStateFactory = WishListsStateFactory()
        let repository = WishListRepository()
        let useCase = WishListsInteractor(repository: repository)
        let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: viewStateFactory, useCase: useCase)
        return WishListRootView(viewModel: viewModel)
        
    }
}
