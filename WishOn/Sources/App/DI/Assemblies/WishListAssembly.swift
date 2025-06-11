//
//  WishListAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 11.06.2025.
//

import Swinject

final class WishListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(WishListRepositoryProtocol.self) { _ in WishListRepository() }
            .inObjectScope(.container)
        
        container.register(WishListUseCase.self) { resolver in
            WishListsInteractor(
                repository: resolver.resolve(WishListRepositoryProtocol.self)!
            )
        }
        
        container.register(WishListsStateMachine.self) { _ in WishListsStateMachine() }
        container.register(WishListsStateFactory.self) { _ in WishListsStateFactory() }
        
        container.register(WishListsModule.self) { resolver in
            guard
                let stateMachine = resolver.resolve(WishListsStateMachine.self),
                let stateFactory = resolver.resolve(WishListsStateFactory.self),
                let useCase = resolver.resolve(WishListUseCase.self)
            else {
                fatalError("Could not resolve dependencies for WishListsModule")
            }
            return WishListsModule(
                stateMachine: stateMachine,
                stateFactory: stateFactory,
                useCase: useCase
            )
        }
        
    }
}
