//
//  LoginStateFactory.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import Foundation

final class LoginStateFactory {
    func make(from state: LoginStateMachine.State) -> LoginState {
        return .init(loginGoogleButton: makeButton(from: state.googleLoginButton),
                     loginAppleButton: makeButton(from: state.appleLoginButton))
    }
}

private extension LoginStateFactory {
    func makeButton(from state: LoginStateMachine.ButtonState) -> ButtonViewState {
        let label: String
        let color: String
        
        switch state.kind {
        case .appleLogin:
            label = L10n.appleLoginLabel
            color = "Green"
        case .googleLogin:
            label = L10n.googleLoginLabel
        }
        
        return .init(label: label)
    }
}
