//
//  File.swift
//  WishOn
//
//  Created by Mari Budko on 17.06.2025.
//

import SwiftUI
import WOResources

public struct IconViewState {
    public let icon: IconRepresentable
    public let isResizable: Bool?
    
    public init(icon: IconRepresentable, isResizable: Bool? = nil) {
        self.icon = icon
        self.isResizable = isResizable
    }
}

public struct IconView: View {
    public let viewState: IconViewState
    
    public init(viewState: IconViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
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

