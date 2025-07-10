//
//  LoginStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import Foundation
import WOResources

public class LoginStateMachine {
    
    public enum ButtonKind {
        case appleLogin
        case googleLogin
    }
    
    public class ButtonState {
        public let label: String
        public let kind: ButtonKind
        public let action: () -> Void
        
        public init(label: String, kind: ButtonKind, action: @escaping () -> Void) {
            self.label = label
            self.kind = kind
            self.action = action
        }
    }
    
    private lazy var googleLoginButton: ButtonState = .init(label: L10n.googleLoginLabel, kind: .googleLogin, action: didTapGoogleLoginButton)
    private lazy var appleLoginButton: ButtonState = .init(label: L10n.appleLoginLabel, kind: .appleLogin, action: didTapAppleLoginButton)
    public var onLoginSuccess: (() -> Void)?
    
    public init(onLoginSuccess: (() -> Void)? = nil) {
        self.onLoginSuccess = onLoginSuccess
    }
    
    public func didTapGoogleLoginButton() {
        //TODO: do google auth
        
        //after successed auth
        onLoginSuccess?()
    }
    
    public func didTapAppleLoginButton() {
        //TODO: do apple auth
    }
}

public extension LoginStateMachine {
    struct State {
        let googleLoginButton: ButtonState
        let appleLoginButton: ButtonState
    }
    
    var state: State {
        .init(googleLoginButton: googleLoginButton, appleLoginButton: appleLoginButton)
    }
}
