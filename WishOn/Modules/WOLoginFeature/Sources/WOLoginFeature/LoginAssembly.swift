//
//  LoginAssembly.swift
//  WishOn
//
//  Created by Mari Budko on 11.06.2025.
//

import Swinject

final class LoginAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(LoginStateMachine.self) { _ in LoginStateMachine() }
        container.register(LoginStateFactory.self) { _ in LoginStateFactory() }
            .inObjectScope(.container)
        
        container.register(LoginModule.self) { (resolver, onLoginSuccess: @escaping (() -> Void)) in
            guard
                let stateMachine = resolver.resolve(LoginStateMachine.self),
                let stateFactory = resolver.resolve(LoginStateFactory.self)
            else {
                fatalError("Could not resolve dependencies for LoginModule")
            }
            
            return LoginModule(
                stateMachine: stateMachine,
                stateFactory: stateFactory,
                onLoginSuccess: onLoginSuccess
            )
        }
    }
    
    
}
