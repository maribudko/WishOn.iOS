//
//  NewWishListAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 12.06.2025.
//

import Swinject

final class NewWishListAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(NewWishListStateMachine.self) { _ in NewWishListStateMachine() }
        container.register(NewWishListStateFactory.self) { _ in NewWishListStateFactory() }
            .inObjectScope(.container)
        container.register(NewWishListModule.self) { resolver in
            guard
                let stateMachine = resolver.resolve(NewWishListStateMachine.self),
                let stateFactory = resolver.resolve(NewWishListStateFactory.self)
            else {
                fatalError("Could not resolve dependencies for NewWishListModule")
            }
            return NewWishListModule(
                stateMachine: stateMachine,
                stateFactory: stateFactory
            )
        }
        
    }
    
    
}
