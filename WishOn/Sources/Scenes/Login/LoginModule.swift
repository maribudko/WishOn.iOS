//
//  LoginModule.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import SwiftUICore

struct LoginModule: BaseSwiftUIModule {
    
    let stateMachine: LoginStateMachine
    let stateFactory: LoginStateFactory
    
    var onLoginSuccess: (() -> Void)?
    
    func view() -> some View {
        let viewModel = LoginViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        
        stateMachine.onLoginSuccess = {
            onLoginSuccess?()
        }
        
        return LoginView(viewModel: viewModel)
    }
}
