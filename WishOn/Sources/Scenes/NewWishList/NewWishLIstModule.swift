//
//  NewWishLIstModule.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import SwiftUI

struct NewWishLIstModule: BaseSwiftUIModule {
    
    func view() -> some View {
        let stateMachine = NewWishListStateMachine()
        let stateFactory = NewWishListStateFactory()
        let viewModel = NewWishListViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
        return NewWishlistView(viewModel: viewModel)
    }
}
