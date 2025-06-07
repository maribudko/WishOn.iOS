//
//  LoginStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import Foundation

class LoginStateMachine {
    
    enum ButtonKind {
        case appleLogin
        case googleLogin
    }
    
    class ButtonState {
        let label: String
        let kind: ButtonKind
        let action: () -> Void
        
        init(label: String, kind: ButtonKind, action: @escaping () -> Void) {
            self.label = label
            self.kind = kind
            self.action = action
        }
    }
    
    private lazy var googleLoginButton: ButtonState = .init(label: L10n.googleLoginLabel, kind: .googleLogin, action: didTapGoogleLoginButton)
    private lazy var appleLoginButton: ButtonState = .init(label: L10n.appleLoginLabel, kind: .appleLogin, action: didTapAppleLoginButton)
    var onLoginSuccess: (() -> Void)?
    
    func didTapGoogleLoginButton() {
        //TODO: do google auth
        
        //after successed auth
        onLoginSuccess?()
    }
    
    func didTapAppleLoginButton() {
        //TODO: do apple auth
    }
}

extension LoginStateMachine {
    struct State {
        let googleLoginButton: ButtonState
        let appleLoginButton: ButtonState
    }
    
    var state: State {
        .init(googleLoginButton: googleLoginButton, appleLoginButton: appleLoginButton)
    }
}
