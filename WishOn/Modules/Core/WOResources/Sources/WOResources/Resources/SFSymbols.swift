//
//  SFSymbols.swift
//  WishOn
//
//  Created by Mari Budko on 07.06.2025.
//

import Foundation
import SwiftUI

public protocol IconRepresentable {
    var image: Image { get }
}

public enum SFSymbols: String {
    
    case close = "xmark"
    case back = "chevron.left"
    case arrowDown = "square.and.arrow.down"
    case down = "chevron.down"
    case fillCircle = "largecircle.fill.circle"
    case circle = "circle"
    case link = "link"
    case plusCircle = "plus.circle.fill"
    case calendar = "calendar.circle"
    case person = "person.circle"
    case gift = "gift.fill"
    case heart = "heart.text.square"
    
    public var name: String { rawValue }
    
    public var image: Image {
        Image(systemName: self.rawValue)
    }
}

public struct SFSymbolsIcon: IconRepresentable {
    let symbol: SFSymbols
    public init(symbol: SFSymbols) {
        self.symbol = symbol
    }
    
    public var image: Image {
        Image(systemName: symbol.rawValue)
    }
}
