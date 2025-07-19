//
//  ContentView.swift
//  PreviewHost
//
//  Created by Mari Budko on 18.07.2025.
//

import SwiftUI
import WOWishListsRootFeature
import WOCore
import WOResources
import WODesign
import DependencyInjection

struct ContentView: View {
    var body: some View {
        let stateMachine = WishListsStateMachine(
            calendarIcon: IconState(icon: SFSymbolsIcon(symbol: .calendar), isResizable: true),
            profileIcon: IconState(icon: SFSymbolsIcon(symbol: .person), isResizable: true),
            emptyListIcon: IconState(icon: SFSymbolsIcon(symbol: .heart), isResizable: true)
        )
        let stateFactory = WishListsStateFactory()
        let repository = FakeWishListRepository()
        let useCase = WishListsInteractor(repository: repository)
        let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory, useCase: useCase)
        
        WishListRootView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
