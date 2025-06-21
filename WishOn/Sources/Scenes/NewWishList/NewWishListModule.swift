//
//  NewWishLIstModule.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import SwiftUI
import WODesign

struct NewWishListModule: BaseSwiftUIModule {
    let stateMachine: NewWishListStateMachine
    let stateFactory: NewWishListStateFactory
    
    func view() -> some View {
        let viewModel = NewWishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        return NewWishlistView(viewModel: viewModel)
    }
}
