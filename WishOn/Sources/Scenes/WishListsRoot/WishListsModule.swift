//
//  WishListsModule.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import SwiftUI
import Swinject

struct WishListsModule: BaseSwiftUIModule {
    let resolver: Resolver
    
    func view() -> some View {
        guard
            let stateMachine = resolver.resolve(WishListsStateMachine.self),
            let stateFactory = resolver.resolve(WishListsStateFactory.self),
            let useCase = resolver.resolve(WishListUseCase.self)
        else {
            fatalError("Failed to resolve WishListsModule dependencies")
        }
        //CR: як уникнути ситуації, коли тип не зареєстровано у контейнері?
        let viewModel = WishListViewModel(
            stateMachine: stateMachine,
            stateFactory: stateFactory,
            useCase: useCase
        )
        return WishListRootView(viewModel: viewModel)
        
    }
}
