//
//  AddNewItemStateFactory.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import Foundation

final class AddNewItemStateFactory {
    func make(from state: AddNewItemStateMachine.State) -> AddNewItemState {
        return .init(name: makeField(from: state.nameField),
                     link: makeField(from: state.urlField),
                     price: PriceInputViewState(
                        price: state.priceField.text,
                        currency: state.priceField.currency,
                        currencies: state.priceField.currencies,
                        errorMessage: state.priceField.isError ? L10n.priceIsIncorrect : nil))
    }
}

private extension AddNewItemStateFactory {
    func makeField(from state: AddNewItemStateMachine.TextFieldState) -> TextFieldViewState {
        let title: String
        let errorMessage: String?
        
        switch state.kind {
        case .name:
            title = "Name"
            errorMessage = state.isError ? L10n.nameCannotBeEmpty : nil
        case .url:
            title = "Link"
            errorMessage = state.isError ? L10n.linkIsIncorrect : nil
        default:
            title = ""
            errorMessage = nil
        }
        
        return .init(title: title, text: state.text, errorMessage: errorMessage)
    }
}


