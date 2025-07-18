//
//  File.swift
//  WOWishListsRootFeature
//
//  Created by Mari Budko on 18.07.2025.
//

import Foundation
import Testing
import Combine
@testable import WOWishListsRootFeature
@testable import WOCore
@testable import WOResources

@Test func testViewModeFetchesWishLists() {
    var cancellables = Set<AnyCancellable>()
    
    let repository = FakeWishListRepository()
    let useCase = WishListsInteractor(repository: repository)
    let stateMachine = WishListsStateMachine(
        calendarIcon: .init(icon: SFSymbolsIcon(symbol: .calendar), isResizable: true),
        profileIcon: .init(icon: SFSymbolsIcon(symbol: .person), isResizable: true),
        emptyListIcon: .init(icon: SFSymbolsIcon(symbol: .heart), isResizable: true)
    )
    let stateFactory = WishListsStateFactory()
    let viewModel = WishListViewModel(
        stateMachine: stateMachine,
        stateFactory: stateFactory,
        useCase: useCase
    )
    
    waitUntil(timeout: 2) { done in
        viewModel.$viewState
            .dropFirst()
            .sink { newState in
                if !newState.wishLists.isEmpty {
                    #expect(newState.wishLists.count == 2)
                    done()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadWishLists()
    }
