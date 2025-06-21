//
//  WishListAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 11.06.2025.
//

import Swinject
import WOResources
import WODesign

final class WishListsAssembly: Assembly {
    func assemble(container: Container) {
        container.register(WishListRepositoryProtocol.self) { _ in WishListRepository() }
            .inObjectScope(.container)
        
        container.register(WishListUseCase.self) { resolver in
            WishListsInteractor(
                repository: resolver.resolve(WishListRepositoryProtocol.self)!
            )
        }
        
        container.register(WishListsStateMachine.self) { resolver in
            guard
                let calendarIcon = resolver.resolve(IconRepresentable.self, name: IconNames.calendarIcon),
                let profileIcon = resolver.resolve(IconRepresentable.self, name: IconNames.profileIcon),
                let emptyListIcon = resolver.resolve(IconRepresentable.self, name: IconNames.heartListIcon)
            else {
                fatalError("Could not resolve dependencies for WishListsModule")
            }
                
            return WishListsStateMachine(
                calendarIcon: IconState(icon: calendarIcon, isResizable: true),
                profileIcon: IconState(icon: profileIcon, isResizable: true),
                emptyListIcon: IconState(icon: emptyListIcon, isResizable: true)
            )
        }
        container.register(WishListsStateFactory.self) { _ in WishListsStateFactory() }
            .inObjectScope(.container)
        
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
