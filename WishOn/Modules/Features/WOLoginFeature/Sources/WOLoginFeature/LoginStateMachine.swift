//
//  LoginStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import Foundation
import WOResources
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

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
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            debugPrint("ClientID not found")
            return
        }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        //getting root controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootController = windowScene.windows.first?.rootViewController else {
            debugPrint("RootVC is not found")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootController) { [weak self] result, error in
            if let error = error {
                debugPrint("SignIn error \(error.localizedDescription)")
                return
            }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                debugPrint("Could not recieve token or user")
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    debugPrint("Firebase error: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    //after successed auth
                    //TODO: save users data
                    self?.onLoginSuccess?()
                }
            }
        }
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
