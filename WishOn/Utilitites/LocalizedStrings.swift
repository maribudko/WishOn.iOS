//
//  LocalizedStrings.swift
//  WishOn
//
//  Created by Mari Budko on 23.01.2025.
//

import Foundation

struct LocalizedStrings {
    static let newWishListLbl = NSLocalizedString("new_wishlist_lbl", comment: "Text shown on screen as label for creating new wishlist")
    static let nameHint = NSLocalizedString("name_hint", comment: "Hint for name field")
    static let descriptionHint = NSLocalizedString("description_hint", comment: "Hint for description field")
    static let dateHint = NSLocalizedString("date_hint", comment: "Hint for date field")
    static let noWishesView = NSLocalizedString("no_wishes_label", comment: "Text shown on screen as label when there are no wishes in wishlist")
    static let toGiveLabel = NSLocalizedString("toGive", comment: "Label for button that shows To Give view")
    
    
    static func wishesCountLabel(_ count: Int) -> String {
        return String(format: NSLocalizedString("wishes_count_label", comment: "Text shown on screen as label for number of wishes in wishlist"), count)
    }
}
