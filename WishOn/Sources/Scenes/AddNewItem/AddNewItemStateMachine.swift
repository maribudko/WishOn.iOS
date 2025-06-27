//
//  AddNewItemStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import Foundation
import WOResources
import WODesign
import WOCore

final class AddNewItemStateMachine {
    
    class PriceInputState: TextFieldState<TextFieldKind> {
        var currency: String = L10n.uah
        var currencies: [String] = [L10n.uah, L10n.usd, L10n.eur]
        var onPriceChanged: (String) -> Void
        var onCurrencyChanged: (String) -> Void
        
        init(onPriceChanged: @escaping (String) -> Void, onCurrencyChanged: @escaping (String) -> Void) {
            self.onPriceChanged = onPriceChanged
            self.onCurrencyChanged = onCurrencyChanged
            super.init(kind: .price, validator: PriceValidator())
        }
    }
    
    class ButtonState {
        var isEnabled: Bool = false
        let label: String
        let action: () -> Void
        
        init(label: String, isEnabled: Bool, action: @escaping () -> Void) {
            self.label = label
            self.isEnabled = isEnabled
            self.action = action
        }
    }
    
    private let nameField: TextFieldState<TextFieldKind>
    private let urlField: TextFieldState<TextFieldKind>
    private let crossIcon: IconState
    private lazy var priceField: PriceInputState = PriceInputState {text in
        self.setPriceText(text)
    } onCurrencyChanged: {text in
        self.setCurrencyText(text)
    }
    
    private lazy var addButton: ButtonState = {
        ButtonState(
            label: L10n.createLabel,
            isEnabled: true,
            action: { [weak self] in
                self?.didTapAddButton()
            }
        )
    }()
    
    var didRequestShowAlert: ((String) -> Void)?
    
    init(crossIcon: IconState) {
        self.nameField = .init(kind: .name, validator: NameValidator())
        self.urlField = .init(kind: .url, validator: UrlValidator())
        self.crossIcon = crossIcon
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
            didRequestShowAlert?(L10n.fillAllFields)
            return
        }
        
        didRequestShowAlert?(L10n.successMessage)
        //TODO: add wish to list
    }
    
    private func getAllFields() -> [TextFieldState<TextFieldKind>] {
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
    
    private func field(for kind: TextFieldKind) -> TextFieldState<TextFieldKind>? {
        switch kind {
        case .name:
            return nameField
        case .url:
            return urlField
        case .price:
            return priceField
        }
    }
}

extension AddNewItemStateMachine {
    enum TextFieldKind: TextFieldKindRepresentable {
        case name, url, price
    }
}

extension AddNewItemStateMachine {
    struct State {
        let nameField: TextFieldState<TextFieldKind>
        let urlField: TextFieldState<TextFieldKind>
        let priceField: PriceInputState
        let addButton: ButtonState
        let crossIcon: IconState
    }
    
    var state: State {
        .init(nameField: nameField,
              urlField: urlField,
              priceField: priceField,
              addButton: addButton,
              crossIcon: crossIcon
        )
    }
}
