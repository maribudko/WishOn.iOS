//
//  AddNewItemAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 12.06.2025.
//

import Swinject
import WOResources
import WODesign

final class AddNewItemAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(AddNewItemStateMachine.self) { resolver in
            guard let closeIcon = resolver.resolve(IconRepresentable.self, name: "closeIcon") else {
                fatalError("Could not resolve dependencies for AddNewItemModule")
            }
            return AddNewItemStateMachine(crossIcon: IconState(icon: closeIcon))
        }
        container.register(AddNewItemStateFactory.self) { _ in AddNewItemStateFactory() }
            .inObjectScope(.container)
        
        container.register(AddNewItemModule.self) { resolver in
            guard
                let stateMachine = resolver.resolve(AddNewItemStateMachine.self),
                let stateFactory = resolver.resolve(AddNewItemStateFactory.self)
            else {
                fatalError("Could not resolve dependencies for AddNewItemModule")
            }
            return AddNewItemModule(
                stateMachine: stateMachine,
                stateFactory: stateFactory
            )
        }
    }
}
