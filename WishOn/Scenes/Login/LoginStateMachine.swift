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
        
        init(label: String, kind: ButtonKind) {
            self.label = label
            self.kind = kind
        }
    }
    
    private let googleLoginButton: ButtonState
    private let appleLoginButton: ButtonState
    var onLoginSuccess: (() -> Void)?
    
    init() {
        googleLoginButton = .init(label: L10n.googleLoginLabel, kind: .googleLogin)
        appleLoginButton = .init(label: L10n.appleLoginLabel, kind: .appleLogin)
    }
    
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
