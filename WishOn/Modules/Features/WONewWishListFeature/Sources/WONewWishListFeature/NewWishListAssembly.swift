//
//  NewWishListAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 12.06.2025.
//

import Swinject
import WOResources
import WODesign
import WOCore

public final class NewWishListAssembly: Assembly {
    public init() {}
    public func assemble(container: Swinject.Container) {
        container.register(NewWishListStateMachine.self) { resolver in
            guard
                let backIcon = resolver.resolve(IconRepresentable.self, name: IconNames.backIcon),
                let dropDownIcon = resolver.resolve(IconRepresentable.self, name: IconNames.downIcon),
                let saveIcon = resolver.resolve(IconRepresentable.self, name: IconNames.checkmarkIcon),
                let plusIcon = resolver.resolve(IconRepresentable.self, name: IconNames.plusCircleIcon)
            else {
                fatalError("Could not resolve dependencies for NewWishListStateMachine")
            }
            return NewWishListStateMachine(
                backIcon: IconState(icon: backIcon),
                dropDownIcon: IconState(icon: dropDownIcon),
                saveIcon: IconState(icon: saveIcon),
                plusIcon: IconState(icon: plusIcon, isResizable: true)
            )
        }
        
        container.register(NewWishListStateFactory.self) { _ in NewWishListStateFactory() }
            .inObjectScope(.container)
        
        container.register(NewWishListModule.self) { (resolver, onSave: @escaping WishListSaveHandler) in
            guard
                let stateMachine = resolver.resolve(NewWishListStateMachine.self),
                let stateFactory = resolver.resolve(NewWishListStateFactory.self)
            else {
                fatalError("Could not resolve dependencies for NewWishListModule")
            }
            return NewWishListModule(
                stateMachine: stateMachine,
                stateFactory: stateFactory,
                onSave: onSave
            )
        }
    }
}
