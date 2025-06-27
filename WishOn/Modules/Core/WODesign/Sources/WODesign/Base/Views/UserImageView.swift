//
//  UserImageView.swift
//  WishOn
//
//  Created by Mari Budko on 18.06.2025.
//

import SwiftUI
import WOResources

public struct UserImageViewState {
    public let image: Data?
    public let placeholderIcon: IconRepresentable
    
    public init(image: Data?, placeholderIcon: IconRepresentable) {
        self.image = image
        self.placeholderIcon = placeholderIcon
    }
}

public struct UserImageView: View {
    public let viewState: UserImageViewState
    
    public init(viewState: UserImageViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        Group {
            if let data = viewState.image, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image(systemName: SFSymbols.gift.name)
                    .resizable()
            }
        }
        .scaledToFit()
        .frame(width: AppDimensions.userImageSize,
               height: AppDimensions.userImageSize)
        .foregroundColor(Color(Asset.backgroundColor.color))
        .padding(AppPaddings.padding26)
        .background(
            Circle().fill(Color(Asset.primaryColor.color))
        )
        .clipShape(.circle)
    }
}
