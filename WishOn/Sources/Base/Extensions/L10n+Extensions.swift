//
//  L10n+Extensions.swift
//  WishOn
//
//  Created by Mari Budko on 07.06.2025.
//

import Foundation

extension L10n {
    static var trimmedEmptyString: String {
        emptyText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
