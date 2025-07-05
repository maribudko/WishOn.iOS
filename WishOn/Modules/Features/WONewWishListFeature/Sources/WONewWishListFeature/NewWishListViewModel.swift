//
//  NewWishListViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation
import WOCore

public final class NewWishListViewModel: ObservableObject {
    @Published private(set) var viewState: NewWishListState
    //CR: чи може лист бути тут або десь у іншому місті?
    @Published var wishes: [Wish] = []
    
    private let stateMachine: NewWishListStateMachine
    private let stateFactory: NewWishListStateFactory
    
    public init(stateMachine: NewWishListStateMachine, stateFactory: NewWishListStateFactory) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.viewState = stateFactory.make(from: stateMachine.state)
    }
    
    public func onNameChanged(_ name: String) {
        stateMachine.setNameText(name)
        updateViewState()
    }
    
    public func onDescriptionChanged(_ description: String) {
        stateMachine.setDescriptionText(description)
        updateViewState()
    }
    
    public func onFieldLostFocus(_ kind: NewWishListStateMachine.TextFieldKind) {
        stateMachine.setDidLoseFocus(kind)
        updateViewState()
    }
    
    public func setDatePickerVisibility(_ isVisible: Bool) {
        stateMachine.setDatePickerVisibility(isVisible)
        updateViewState()
    }
    
    private func updateViewState() {
        viewState = stateFactory.make(from: stateMachine.state)
    }
}
