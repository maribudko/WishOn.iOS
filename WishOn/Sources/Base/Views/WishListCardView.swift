//
//  WishListCardView.swift
//  WishOn
//
//  Created by Mari Budko on 29.11.2024.
//

import SwiftUI

struct WishListCardViewState {
    let imageName: String
    let name: String
    let formattedDate: String
}

struct WishListCardView: View {
    let viewState: WishListCardViewState
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: AppRadiuses.radius10)
                .fill(Color(Asset.highLightColor.color))
                .shadow(radius: AppRadiuses.smallRadius)
            
            RoundedRectangle(cornerRadius: AppRadiuses.radius10)
                .fill(Color(Asset.primaryTitleColor.color).opacity(AppOpacityLevels.grabberOpacity))
                .frame(width: AppDimensions.grabberWidth, height: AppDimensions.grabberHeight)
                .padding(.top, AppPaddings.padding10)
                    
            VStack {
                Image(systemName: viewState.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: AppDimensions.wishCardImageSize, height: AppDimensions.wishCardImageSize)
                    .foregroundColor(.white)
                    .padding(.top, AppPaddings.padding10)
                        
                Spacer()
                
                Text(viewState.name)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(viewState.formattedDate)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            .padding(AppPaddings.padding8)
        }
        .frame(width: AppDimensions.wishListCardWidth,
               height: AppDimensions.wishListCardHeight)
        
    }
}

#Preview {
    let viewState = WishListCardViewState(imageName: "star.fill", name: "Some wish", formattedDate: DateFormatter.shortDate.string(from: Date()))
    WishListCardView(viewState: viewState)
}
