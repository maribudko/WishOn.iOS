//
//  LoginModule.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import SwiftUICore
import Swinject

struct LoginModule: BaseSwiftUIModule {
    let resolver: Resolver
    var onLoginSuccess: (() -> Void)?
    
    func view() -> some View {
        guard let stateMachine = resolver.resolve(LoginStateMachine.self),
              let stateFactory = resolver.resolve(LoginStateFactory.self)
        else {
            fatalError("Failed to resolve WishListsModule dependencies")
        }
        let viewModel = LoginViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        
        stateMachine.onLoginSuccess = {
            onLoginSuccess?()
        }
        
        return LoginView(viewModel: viewModel)
    }
}
