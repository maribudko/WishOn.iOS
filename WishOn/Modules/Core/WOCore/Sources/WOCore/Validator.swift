//
//  Validator.swift
//  WishOn
//
//  Created by Mari Budko on 15.05.2025.
//

import Foundation

public protocol Validator {
    func validate(_ text: String) -> Bool
}

public struct NameValidator: Validator {
    public init(){}
    public func validate(_ text: String) -> Bool {
        return !text.isEmpty && text.count >= 2
    }
}

public struct UrlValidator: Validator {
    public init(){}
    public func validate(_ text: String) -> Bool {
        guard let url = URL(string: text) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}

public struct OptionalUrlValidator: Validator {
    public init() {}
    public func validate(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return true }
        return UrlValidator().validate(trimmed)
    }
}

public struct PriceValidator: Validator {
    public init(){}
    public func validate(_ text: String) -> Bool {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
            guard let value = Double(normalized), value > 0 else {
                return false
            }
            return true
    }
}

public struct PlainTextValidator: Validator {
    public init(){}
    public func validate(_ text: String) -> Bool {
        return !text.isEmpty && text.count > 4
    }
}
