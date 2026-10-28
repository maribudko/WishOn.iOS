//
//  WishListsStateFactory.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import Foundation
import WODesign
import WOCore

public final class WishListsStateFactory {
    
    public init() {}
    
    public func make(from state: WishListsStateMachine.State) -> WishListsState {
        return .init(
            addNewWishlistButton: makeField(from: state.addNewWishlistButton),
            toGiveButton: makeField(from: state.toGiveButton),
            wishLists: state.wishLists,
            calendarIcon: makeIcon(from: state.calendarIcon),
            profileIcon: makeIcon(from: state.profileIcon),
            emptyListIcon: makeIcon(from: state.emptyListIcon)
        )
    }
}

private extension WishListsStateFactory {
    func makeField(from state: WishListsStateMachine.NavLinkButtonState) -> NavigationLinkButtonViewState {
        
        return .init(label: state.label, accessibilityId: state.accessibilityId, color: state.color)
    }
    
    func makeIcon(from state: IconState) -> IconViewState {
        return .init(icon: state.icon, isResizable: state.isResizable)
    }
}
