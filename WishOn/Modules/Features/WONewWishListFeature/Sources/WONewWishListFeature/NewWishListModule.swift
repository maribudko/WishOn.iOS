//
//  NewWishLIstModule.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import SwiftUI
import WODesign

public struct NewWishListModule: BaseSwiftUIModule {
    public let stateMachine: NewWishListStateMachine
    public let stateFactory: NewWishListStateFactory
    
    public init(stateMachine: NewWishListStateMachine, stateFactory: NewWishListStateFactory) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
    }
    
    public func view() -> some View {
        let viewModel = NewWishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        return NewWishlistView(viewModel: viewModel)
    }
}
