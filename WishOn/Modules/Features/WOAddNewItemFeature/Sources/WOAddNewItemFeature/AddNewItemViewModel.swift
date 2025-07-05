//
//  AddNEwItemViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 15.05.2025.
//

import Foundation
import WOResources

public final class AddNewItemViewModel: ObservableObject {
    @Published private(set) var viewState: AddNewItemState
    @Published var showAlert: Bool = false
    @Published var alertMessage: String?
    @Published var isAddButtonEnabled: Bool = false
    
    private let stateMachine: AddNewItemStateMachine
    private let stateFactory: AddNewItemStateFactory
    
    public var onSuccess: (() -> Void)?
    
    public init(stateMachine: AddNewItemStateMachine, stateFactory: AddNewItemStateFactory) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.viewState = stateFactory.make(from: stateMachine.state)
        
        stateMachine.didRequestShowAlert = {[weak self] message in
            self?.alertMessage = message
            self?.showAlert = true
        }
    }
    
    //MARK: - User Actions
    public func onNameChanged(_ name: String) {
        stateMachine.setNameText(name)
        updateViewState()
    }
    
    public func onUrlChanged(_ url: String) {
        stateMachine.setUrlText(url)
        updateViewState()
    }
    
    public func onPriceChanged(_ price: String) {
        stateMachine.setPriceText(price)
        updateViewState()
    }
    
    public func onCurrencyChanged(_ currency: String) {
        stateMachine.setCurrencyText(currency)
        updateViewState()
    }
    
    public func onFieldLostFocus(_ kind: AddNewItemStateMachine.TextFieldKind) {
        stateMachine.setDidLoseFocus(kind)
        updateViewState()
    }
    
    public func onAddTapped() {
        stateMachine.didTapAddButton()
        updateViewState()
        
        if stateMachine.state.addButton.isEnabled {
            showAlert = true
            alertMessage = L10n.doneLabel
        }
        // TODO: save wish to list
    }
    
    private func updateViewState() {
        viewState = stateFactory.make(from: stateMachine.state)
        isAddButtonEnabled = stateMachine.state.addButton.isEnabled
    }
}
