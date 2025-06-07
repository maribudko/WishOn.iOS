//
//  WishListsStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import Foundation

final class WishListsStateMachine {
    
    class NavLinkButtonState {
        let label: String
        let accessibilityId: String
        let color: ButtonColor
        
        init(label: String, accessibilityId: String, color: ButtonColor) {
            self.label = label
            self.accessibilityId = accessibilityId
            self.color = color
        }
    }
    
    class WishListItemState {
        let id: String
        let title: String
        let subtitle: String?
        
        init(id: String, title: String, subtitle: String?) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    private var wishLists: [WishList] = []
    
    var wishListItems: [WishListItemState] {
            wishLists.map { WishListItemState(id: $0.id.uuidString, title: $0.name, subtitle: $0.description) }
        }
    
    private let addNewWishlistButton: NavLinkButtonState
    private let toGiveButton: NavLinkButtonState
    
    init() {
        addNewWishlistButton = .init(label: L10n.addNewWishlist, accessibilityId: AccessibilityIdentifiers.addWishlistButton, color: .green)
        toGiveButton = .init(label: L10n.toGive, accessibilityId: AccessibilityIdentifiers.showToGiveViewButton, color: .grey)
    }
    
    func setWishLists(_ wishLists: [WishList]) {
        self.wishLists = wishLists
    }
    
    func addWishList(_ wishList: WishList) {
        self.wishLists.append(wishList)
    }
    
    func removeWishList(by id: String) {
        self.wishLists.removeAll { $0.id == UUID(uuidString: id) }
    }
    
    var onAddNewTapped: (() -> Void)?
    var onToGiveTapped: (() -> Void)?
    
    func didTapAddNewWishListButton() {
        //TODO: show new wishlist view
        onAddNewTapped?()
    }
    
    func didTapToGiveButton() {
        //TODO: show toGive view
        onToGiveTapped?()
    }
    
}

extension WishListsStateMachine {
    struct State {
        let wishLists: [WishListItemState]
        let addNewWishlistButton: NavLinkButtonState
        let toGiveButton: NavLinkButtonState
    }
    
    var state: State {
        .init(wishLists: wishListItems, addNewWishlistButton: addNewWishlistButton, toGiveButton: toGiveButton)
    }
}
