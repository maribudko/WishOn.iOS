//
//  NewWishLIstModule.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import SwiftUI
import WOCore
import WODesign

public struct NewWishListModule: BaseSwiftUIModule {
    public let stateMachine: NewWishListStateMachine
    public let stateFactory: NewWishListStateFactory
    public let onSave: WishListSaveHandler
    
    public init(
        stateMachine: NewWishListStateMachine,
        stateFactory: NewWishListStateFactory,
        onSave: @escaping WishListSaveHandler
    ) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.onSave = onSave
    }
    
    public func makeViewModel(existing: WishList? = nil, isEditable: Bool = true) -> NewWishListViewModel {
        NewWishListViewModel(
            stateMachine: stateMachine,
            stateFactory: stateFactory,
            onSave: onSave,
            existing: existing,
            isEditable: isEditable
        )
    }
    
    public func view() -> some View {
        NewWishlistView(viewModel: makeViewModel())
    }
}
