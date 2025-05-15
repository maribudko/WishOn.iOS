//
//  AddNewItemStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import Foundation

final class AddNewItemStateMachine {
    
    enum TextFieldKind {
        case name
        case email
        case url
        case price
        case password
        case confirmPassword
    }
    
    class TextFieldState {
        var kind: TextFieldKind
        var text: String = ""
        var isError: Bool = false
        var wasFocused: Bool = false
        var validator: Validator
        
        init(kind: TextFieldKind, validator: Validator) {
            self.kind = kind
            self.validator = validator
        }
        
        func validateIfNeeded() {
            
            guard wasFocused else {
                return
            }
            
            isError = !validator.validate(text)
        }
    }
    
    class PriceInputState: TextFieldState {
        var currency: String = ""
        var currencies: [String] = []
    }
    
    class ButtonState {
        var isEnabled: Bool = false
        let label: String
        
        init(label: String, isEnabled: Bool) {
            self.label = label
            self.isEnabled = isEnabled
        }
    }
    
    private let nameField: TextFieldState
    private let urlField: TextFieldState
    private let priceField: PriceInputState
    private let addButton: ButtonState
    var didRequestShowAlert: ((String) -> Void)?
    
    init() {
        self.nameField = .init(kind: .name, validator: NameValidator())
        self.urlField = .init(kind: .url, validator: UrlValidator())
        self.priceField = .init(kind: .price, validator: PriceValidator())
        self.addButton = .init(label: L10n.addNewWishlist, isEnabled: true)
    }
    
    func setNameText(_ text: String) {
        nameField.text = text
        nameField.validateIfNeeded()
        setButtonEnabled()
    }
    
    func setUrlText(_ text: String) {
        urlField.text = text
        urlField.validateIfNeeded()
        setButtonEnabled()
    }
    
    func setPriceText(_ text: String) {
        priceField.text = text
        priceField.validateIfNeeded()
        setButtonEnabled()
    }
    
    func setCurrencyText(_ text: String) {
        priceField.currency = text
    }
    
    func setDidLoseFocus(_ kind: TextFieldKind) {
        field(for: kind)?.wasFocused = true
        field(for: kind)?.validateIfNeeded()
        setButtonEnabled()
    }
    
    func didTapAddButton() {
        validateAllFields()
        
        guard addButton.isEnabled else {
            didRequestShowAlert?("Please, fill all fields correctly and try again.")
            return
        }
        
        didRequestShowAlert?("Successfully added")
        //TODO: add wish to list
    }
    
    private func getAllFields() -> [TextFieldState] {
        return [nameField, urlField, priceField]
    }
    
    private func setButtonEnabled() {
        addButton.isEnabled = getAllFields().allSatisfy { !$0.isError && !$0.text.isEmpty}
    }
    
    private func validateAllFields() {
        let fields = getAllFields()
        
        fields.forEach {
            $0.wasFocused = true
            $0.validateIfNeeded()
        }
        
        setButtonEnabled()
    }
    
    private func field(for kind: TextFieldKind) -> TextFieldState? {
        switch kind {
        case .name:
            return nameField
        case .url:
            return urlField
        case .price:
            return priceField
        default:
            return nameField
        }
    }
}

extension AddNewItemStateMachine {
    struct State {
        let nameField: TextFieldState
        let urlField: TextFieldState
        let priceField: PriceInputState
        let addButton: ButtonState
    }
    
    var state: State {
        .init(nameField: nameField,
              urlField: urlField,
              priceField: priceField,
              addButton: addButton)
    }
}
