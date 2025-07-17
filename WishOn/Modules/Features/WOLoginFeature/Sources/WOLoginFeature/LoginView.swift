//
//  LoginView.swift
//  WishOn
//
//  Created by Mari Budko on 16.05.2025.
//

import SwiftUI
import WOResources
import WODesign
import DependencyInjection
import WOWishListsRootFeature

public struct LoginState {
    public let loginGoogleButton: ButtonViewState
    public let loginAppleButton: ButtonViewState
    
    public init(loginGoogleButton: ButtonViewState, loginAppleButton: ButtonViewState) {
        self.loginGoogleButton = loginGoogleButton
        self.loginAppleButton = loginAppleButton
    }
}

public struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
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
    
    return LoginView(viewModel: viewModel)
}

//#if DEBUG
//struct MyView_Previews: PreviewProvider {
//    static var previews: some View {
//        let stateMachine = LoginStateMachine()
//        let stateFactory = LoginStateFactory()
//        let viewModel = LoginViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
//        
//        LoginView(viewModel: viewModel)
//    }
//}
//#endif
