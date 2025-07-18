//
//  WishListsStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import Foundation
import WOResources
import WODesign
import WOCore

public final class WishListsStateMachine {
    
    public class NavLinkButtonState {
        public let label: String
        public let accessibilityId: String
        public let color: ButtonColor
        
        public init(label: String, accessibilityId: String, color: ButtonColor) {
            self.label = label
            self.accessibilityId = accessibilityId
            self.color = color
        }
    }
    
    public class WishListItemState {
        public let id: String
        public let title: String
        public let subtitle: String?
        
        public init(id: String, title: String, subtitle: String?) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    private var wishLists: [WishList] = []
    
    public var wishListItems: [WishListItemState] {
        wishLists.map { WishListItemState(id: $0.id.uuidString, title: $0.name, subtitle: $0.description) }
    }
    
    private let addNewWishlistButton: NavLinkButtonState
    private let toGiveButton: NavLinkButtonState
    private let calendarIcon: IconState
    private let profileIcon: IconState
    private let emptyListIcon: IconState
    private var userImageData: Data? = nil
    //private let userImage: UserProfileImageState
    
    public init(calendarIcon: IconState, profileIcon: IconState, emptyListIcon: IconState) {
        addNewWishlistButton = .init(label: L10n.addNewWishlist, accessibilityId: AccessibilityIdentifiers.addWishlistButton, color: .green)
        toGiveButton = .init(label: L10n.toGive, accessibilityId: AccessibilityIdentifiers.showToGiveViewButton, color: .grey)
        self.calendarIcon = calendarIcon
        self.profileIcon = profileIcon
        self.emptyListIcon = emptyListIcon
    }
    
    public func setWishLists(_ wishLists: [WishList]) {
        self.wishLists = wishLists
    }
    
    public func addWishList(_ wishList: WishList) {
        guard !wishLists.contains(where: {$0.id == wishList.id}) else {
            return
        }
        self.wishLists.append(wishList)
    }
    
    public func removeWishList(by id: String) {
        self.wishLists.removeAll { $0.id == UUID(uuidString: id) }
    }
    
    public var onAddNewTapped: (() -> Void)?
    public var onToGiveTapped: (() -> Void)?
    
    public func didTapAddNewWishListButton() {
        //TODO: show new wishlist view
        onAddNewTapped?()
    }
    
    public func didTapToGiveButton() {
        //TODO: show toGive view
        onToGiveTapped?()
    }
    
    public func updateUserImage(data: Data?) {
        self.userImageData = data
    }
    
}

public extension WishListsStateMachine {
    struct State {
        let wishLists: [WishListItemState]
        let addNewWishlistButton: NavLinkButtonState
        let toGiveButton: NavLinkButtonState
        let calendarIcon: IconState
        let profileIcon: IconState
        let emptyListIcon: IconState
    }
    
    var state: State {
        .init(
            wishLists: wishListItems,
            addNewWishlistButton: addNewWishlistButton,
            toGiveButton: toGiveButton,
            calendarIcon: calendarIcon,
            profileIcon: profileIcon,
            emptyListIcon: emptyListIcon
        )
    }
}
