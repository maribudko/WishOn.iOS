//
//  LoginView.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import SwiftUI
import WOResources
import WODesign

struct LoginState {
    let loginGoogleButton: ButtonViewState
    let loginAppleButton: ButtonViewState
}

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            ButtonView(buttonViewState: viewModel.viewState.loginGoogleButton)
            
            ButtonView(buttonViewState: viewModel.viewState.loginAppleButton)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, AppPaddings.padding20)
        .background(Color(Asset.backgroundColor.color).gradient)
        .fullScreenCover(isPresented: $viewModel.isShowinWishListsView) {
            AppAssembler.shared
                .resolver
                .resolve(WishListsModule.self)
                .view()
        }
    }
}

#Preview {
    let stateMachine = LoginStateMachine()
    let stateFactory = LoginStateFactory()
    let viewModel = LoginViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
    
    LoginView(viewModel: viewModel)
}
