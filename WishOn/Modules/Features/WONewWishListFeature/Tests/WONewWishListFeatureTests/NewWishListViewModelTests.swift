//
//  File.swift
//  WONewWishListFeature
//
//  Created by Mari Budko on 21.08.2025.
//

import Testing
import WOResources
@testable import WONewWishListFeature

@Test func initialStateIsCorrect() {
    let viewModel = makeViewModel()
    
    #expect(viewModel.viewState.name.text.isEmpty == true)
    #expect(viewModel.viewState.description.text.isEmpty == true)
    #expect(viewModel.viewState.isDatePickerVisible == false)
    #expect(viewModel.wishes.isEmpty == true)
}

@Test func nameChangesUpdatesViewState() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Some Wishlist")
    #expect(viewModel.viewState.name.text == "Some Wishlist")
}

@Test func descriptionChangesUpdatesViewState() {
    let viewModel = makeViewModel()
    viewModel.onDescriptionChanged("Some description for Some Wishlist")
    #expect(viewModel.viewState.description.text == "Some description for Some Wishlist")
}

private func makeViewModel() -> NewWishListViewModel {
    let stateMachine = NewWishListStateMachine(backIcon: .init(icon: SFSymbolsIcon(symbol: .back)),
                                               dropDownIcon: .init(icon: SFSymbolsIcon(symbol: .down)),
                                               saveIcon: .init(icon: SFSymbolsIcon(symbol: .arrowDown)),
                                               plusIcon: .init(icon: SFSymbolsIcon(symbol: .plusCircle)))
    let stateFactory = NewWishListStateFactory()
    return .init(stateMachine: stateMachine, stateFactory: stateFactory)
}
