//
//  TextFieldState.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation
import WOResources
import WOCore

public protocol TextFieldKindRepresentable: Equatable {}

open class TextFieldState<Kind: TextFieldKindRepresentable> {
    
    public var kind: Kind
    public var text: String = L10n.trimmedEmptyString
    public var isError: Bool = false
    public var wasFocused: Bool = false
    public var validator: Validator
    
    public init(kind: Kind, validator: Validator) {
        self.kind = kind
        self.validator = validator
    }
    
    public func validateIfNeeded() {
        
        guard wasFocused else {
            return
        }
        
        isError = !validator.validate(text)
    }
}
