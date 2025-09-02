//
//  UITestHelper.swift
//  PreviewHostUITests
//
//  Created by Mari Budko on 28.07.2025.
//

import SwiftUI

enum UITestHelper {
    static func screenFromLunchArguments() -> PreviewScreen {
        let arguments = ProcessInfo.processInfo.arguments

        if let matchedArguments = arguments.first(where: {arg in
            [Constants.loginScreen, Constants.wishListRootScreen, Constants.newWishListScreen, Constants.addNewItemScreen, Constants.toGiveScreen].contains(arg)
        }) {
            switch matchedArguments {
            case Constants.loginScreen:
                return .LoginView
            case Constants.wishListRootScreen:
                return .WishListsRootView
            case Constants.newWishListScreen:
                return .NewWishListView
            case Constants.addNewItemScreen:
                return .AddNewItemView
            case Constants.toGiveScreen:
                return .ToGiveView
            default:
                return .WishListsRootView
            }
        } else {
            return .WishListsRootView
        }
    }
}
