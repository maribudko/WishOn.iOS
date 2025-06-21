//
//  File.swift
//  WishOn
//
//  Created by Mari Budko on 17.06.2025.
//

import SwiftUI
import WOResources

struct IconViewState {
    let icon: IconRepresentable
    let isResizable: Bool?
    
    init(icon: IconRepresentable, isResizable: Bool? = nil) {
        self.icon = icon
        self.isResizable = isResizable
    }
}

struct IconView: View {
    let viewState: IconViewState
    var body: some View {
        Group {
            if viewState.isResizable == true {
                viewState.icon.image
                    .resizable()
                    .scaledToFit()
            } else {
                viewState.icon.image
            }
        }
    }
}

