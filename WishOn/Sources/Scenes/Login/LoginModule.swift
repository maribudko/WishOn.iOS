//
//  LoginModule.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import SwiftUICore

struct LoginModule: BaseSwiftUIModule {
    var onLoginSuccess: (() -> Void)?
    
    func view() -> some View {
        let stateMachine = LoginStateMachine()
        let viewStateFactory = LoginStateFactory()
        let viewModel = LoginViewModel(stateMachine: stateMachine, stateFactory: viewStateFactory)
        
        stateMachine.onLoginSuccess = {
            onLoginSuccess?()
        }
        
        return LoginView(viewModel: viewModel)
    }
}
