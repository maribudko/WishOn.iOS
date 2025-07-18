//
//  WishListsModule.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI
import WODesign

public struct WishListsModule: BaseSwiftUIModule {
    public let stateMachine: WishListsStateMachine
    public let stateFactory: WishListsStateFactory
    public let useCase: WishListUseCase
    
    public init(stateMachine: WishListsStateMachine, stateFactory: WishListsStateFactory, useCase: WishListUseCase) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.useCase = useCase
    }
    
    public func view() -> some View {
        let viewModel = WishListViewModel(
            stateMachine: stateMachine,
            stateFactory: stateFactory,
            useCase: useCase
        )
        return WishListRootView(viewModel: viewModel)   
    }
}
