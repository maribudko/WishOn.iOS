//
//  UserImageView.swift
//  WishOn
//
//  Created by Mari Budko on 18.06.2025.
//

import SwiftUI

struct UserImageViewState {
    let image: Data?
    let placeholderIcon: IconRepresentable
}

struct UserImageView: View {
    let viewState: UserImageViewState
    
    var body: some View {
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
