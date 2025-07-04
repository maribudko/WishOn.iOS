//
//  LoginModule.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import SwiftUICore
import WODesign

public struct LoginModule: BaseSwiftUIModule {
    
    public let stateMachine: LoginStateMachine
    public let stateFactory: LoginStateFactory
    
    public var onLoginSuccess: (() -> Void)?
    
    public init(stateMachine: LoginStateMachine, stateFactory: LoginStateFactory, onLoginSuccess: (() -> Void)? = nil) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.onLoginSuccess = onLoginSuccess
    }
    
    public func view() -> some View {
        let viewModel = LoginViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        
        stateMachine.onLoginSuccess = {
            onLoginSuccess?()
        }
        
        return LoginView(viewModel: viewModel)
    }
}
