//
//  SFSymbols.swift
//  WishOn
//
//  Created by Mari Budko on 07.06.2025.
//

import Foundation
import SwiftUI

protocol IconRepresentable {
    var image: Image { get }
}

enum SFSymbols: String {
    
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
    
    var name: String { rawValue }
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
}

struct SFSymbolsIcon: IconRepresentable {
    let symbol: SFSymbols
    var image: Image {
        Image(systemName: symbol.rawValue)
    }
}
