//
//  LoginViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published private(set) var viewState: LoginState
    @Published var isShowinWishListsView = false
    
    private let stateMachine: LoginStateMachine
    private let stateFactory: LoginStateFactory
    
    init(stateMachine: LoginStateMachine, stateFactory: LoginStateFactory) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.viewState = stateFactory.make(from: stateMachine.state)
    }
    
    func onGoogleLoginButtonTapped() {
        isShowinWishListsView = true
        stateMachine.didTapGoogleLoginButton()
    }
    
    func onAppleLoginButtonTapped() {
        stateMachine.didTapAppleLoginButton()
    }
}
