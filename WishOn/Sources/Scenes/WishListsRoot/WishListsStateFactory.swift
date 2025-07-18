//
//  WishListsStateFactory.swift
//  WishOn
//
//  Created by Mari Budko on 20.05.2025.
//

import Foundation

final class WishListsStateFactory {
    func make(from state: WishListsStateMachine.State) -> WishListsState {
        
        let list: [WishList] = state.wishLists.map({ wishList in
            WishList(id: UUID(uuidString: wishList.id) ?? UUID(), name: wishList.title, image: "", eventDate: Date(), wishes: [], description: wishList.subtitle, createdAt: Date())
        })
        
        return .init(
            addNewWishlistButton: makeField(from: state.addNewWishlistButton),
            toGiveButton: makeField(from: state.toGiveButton),
            wishLists: list,
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
