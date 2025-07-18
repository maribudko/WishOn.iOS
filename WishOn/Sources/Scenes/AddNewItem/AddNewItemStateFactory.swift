//
//  AddNewItemStateFactory.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import Foundation

final class AddNewItemStateFactory {
    func make(from state: AddNewItemStateMachine.State) -> AddNewItemState {
        let price = PriceInputViewState(
            price: state.priceField.text,
            currency: state.priceField.currency,
            currencies: state.priceField.currencies,
            errorMessage: state.priceField.isError ? L10n.priceIsIncorrect : nil
        )
        
        let buttonViewState = ButtonViewState(
            label: state.addButton.label,
            action: state.addButton.action
        )
        
        return .init(
            name: makeField(from: state.nameField),
            link: makeField(from: state.urlField),
            price: price,
            button: buttonViewState,
            crossIcon: .init(icon: state.crossIcon.icon)
        )
    }
}

private extension AddNewItemStateFactory {
    func makeField(from state: TextFieldState<AddNewItemStateMachine.TextFieldKind>) -> TextFieldViewState {
        let title: String
        let errorMessage: String?
        let inputType: InputFieldType
        
        switch state.kind {
        case .name:
            title = L10n.nameHint
            errorMessage = state.isError ? L10n.nameCannotBeEmpty : nil
            inputType = .name
        case .url:
            title = L10n.linkHint
            errorMessage = state.isError ? L10n.linkIsIncorrect : nil
            inputType = .url
        default:
            title = L10n.trimmedEmptyString
            errorMessage = nil
            inputType = .plain
        }
        
        return .init(title: title, text: state.text, errorMessage: errorMessage, inputType: inputType)
    }
}


