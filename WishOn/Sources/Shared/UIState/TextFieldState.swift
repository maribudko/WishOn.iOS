//
//  TextFieldState.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation

protocol TextFieldKindRepresentable: Equatable {}

class TextFieldState<Kind: TextFieldKindRepresentable> {
    
    var kind: Kind
    var text: String = L10n.trimmedEmptyString
    var isError: Bool = false
    var wasFocused: Bool = false
    var validator: Validator
    
    init(kind: Kind, validator: Validator) {
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
