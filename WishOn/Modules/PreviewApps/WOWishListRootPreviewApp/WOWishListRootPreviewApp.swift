//
//  WOWishListRootPreviewAppApp.swift
//  WOWishListRootPreviewApp
//
//  Created by Mari Budko on 17.07.2025.
//

import SwiftUI
import WOWishListsRootFeature
import WODesign
import WOCore
import WOResources

@main
struct WOWishListRootPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            let stateMachine = WishListsStateMachine(
                calendarIcon: IconState(icon: SFSymbolsIcon(symbol: .calendar)),
                profileIcon: IconState(icon: SFSymbolsIcon(symbol: .person)),
                emptyListIcon: IconState(icon: SFSymbolsIcon(symbol: .heart))
            )
            let stateFactory = WishListsStateFactory()
            let repository = FakeWishListRepository()
            let useCase = WishListsInteractor(repository: repository)
            let viewModel = WishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory, useCase: useCase)
            
            WishListRootView(viewModel: viewModel)
        }
    }
}

