//
//  DateFormatter+Extensions.swift
//  WishOn
//
//  Created by Mari Budko on 05.06.2025.
//

import Foundation

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
