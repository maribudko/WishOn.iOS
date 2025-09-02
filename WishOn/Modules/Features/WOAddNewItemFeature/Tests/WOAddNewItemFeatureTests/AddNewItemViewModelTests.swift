//
//  File.swift
//  WOAddNewItemFeature
//
//  Created by Mari Budko on 21.08.2025.
//

import Testing
import WOResources
@testable import WOAddNewItemFeature

@Test func addButtonInitiallyDisabled() {
    let viewModel = makeViewModel()
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func addButtonEnablesOnValidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("120.0")
    
    #expect(viewModel.isAddButtonEnabled == true)
}

@Test func addButtonDisablesOnNameInvalidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("A")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("120.0")
    
    viewModel.onFieldLostFocus(.name)
    
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func addButtonDisablesOnUrlInvalidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("@@@@")
    viewModel.onPriceChanged("120.0")
    
    viewModel.onFieldLostFocus(.url)
    
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func addButtonDisablesOnPriceInvalidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("-120.0")
    
    viewModel.onFieldLostFocus(.price)
    
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func currencyChangeUpdatesViewState() {
    let viewModel = makeViewModel()
    viewModel.onCurrencyChanged(L10n.eur)
    
    #expect(viewModel.viewState.price.currency == L10n.eur)
}

private func makeViewModel() -> AddNewItemViewModel {
    let stateMachine = AddNewItemStateMachine(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close)))
    let stateFactory = AddNewItemStateFactory()
    return AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
}


