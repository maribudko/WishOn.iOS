//
//  PreviewHost.swift
//  PreviewHost
//
//  Created by Mari Budko on 28.07.2025.
//

import SwiftUI
import WOLoginFeature
import WOWishListsRootFeature
import WONewWishListFeature
import WOAddNewItemFeature
import WOToGiveFeature
import WOResources
import WOCore

struct PreviewHost: View {
    let screen: PreviewScreen
    
    var body: some View {
        content(for: screen)
    }
    
    @ViewBuilder
    private func content(for screen: PreviewScreen) -> some View {
        switch screen {
        case .LoginView:
            LoginView(viewModel: LoginViewModel(stateMachine: LoginStateMachine(), stateFactory: LoginStateFactory()))
        
        case .WishListsRootView:
            getWishListRootView()
            
        case .NewWishListView:
            getNewWishListView()
            
        case .AddNewItemView:
            getAddNewItemView()
             
        case .ToGiveView:
            ToGiveView()
        }
    }
    
    
    private func getWishListRootView() -> some View {
        let stateMachine = WishListsStateMachine(
            calendarIcon: .init(icon: SFSymbolsIcon(symbol: .calendar), isResizable: true),
            profileIcon: .init(icon: SFSymbolsIcon(symbol: .person), isResizable: true),
            emptyListIcon: .init(icon: SFSymbolsIcon(symbol: .heart), isResizable: true)
        )
        let stateFactory = WishListsStateFactory()
        let repository = FakeWishListRepository()
        let useCase = WishListsInteractor(repository: repository)
        let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory, useCase: useCase)
        return WishListRootView(viewModel: viewModel)
    }
    
    private func getNewWishListView() -> some View {
        let stateMachine = NewWishListStateMachine(
            backIcon: .init(icon: SFSymbolsIcon(symbol: .back)),
            dropDownIcon: .init(icon: SFSymbolsIcon(symbol: .down)),
            saveIcon: .init(icon: SFSymbolsIcon(symbol: .arrowDown)),
            plusIcon: .init(icon: SFSymbolsIcon(symbol: .plusCircle), isResizable: true))
        return NewWishlistView(viewModel: NewWishListViewModel(
            stateMachine: stateMachine,
            stateFactory: NewWishListStateFactory()))
    }
    
    private func getAddNewItemView() -> some View{
        let stateMachine = AddNewItemStateMachine(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close), isResizable: true))
        let stateFactory = AddNewItemStateFactory()
        let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        
        
        return AddNewItemView(isShown: .constant(true), viewModel: viewModel)
    }
}

#Preview("LoginView") {
    PreviewHost(screen: .LoginView)
}

#Preview("RootView") {
    PreviewHost(screen: .WishListsRootView)
}

#Preview("NewWishList") {
    PreviewHost(screen: .NewWishListView)
}

#Preview("AddNewItem") {
    PreviewHost(screen: .AddNewItemView)
}

#Preview("ToGiveView") {
    PreviewHost(screen: .ToGiveView)
}
