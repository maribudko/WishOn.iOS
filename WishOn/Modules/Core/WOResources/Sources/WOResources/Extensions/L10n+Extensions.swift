//
//  L10n+Extensions.swift
//  WishOn
//
//  Created by Mari Budko on 07.06.2025.
//

import Foundation

public extension L10n {
    static var trimmedEmptyString: String {
        spaceText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
