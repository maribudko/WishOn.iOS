//
//  Validator.swift
//  WishOn
//
//  Created by Mari Budko on 15.05.2025.
//

import Foundation

protocol Validator {
    func validate(_ text: String) -> Bool
}

struct NameValidator: Validator {
    func validate(_ text: String) -> Bool {
        return !text.isEmpty && text.count >= 2
    }
}

struct UrlValidator: Validator {
    func validate(_ text: String) -> Bool {
        guard let url = URL(string: text) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
}

struct PriceValidator: Validator {
    func validate(_ text: String) -> Bool {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
            guard let value = Double(normalized), value > 0 else {
                return false
            }
            return true
    }
}

struct PlainTextValidator: Validator {
    func validate(_ text: String) -> Bool {
        return !text.isEmpty && text.count > 4
    }
}
