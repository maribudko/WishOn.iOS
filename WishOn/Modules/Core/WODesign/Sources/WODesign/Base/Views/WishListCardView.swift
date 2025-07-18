//
//  WishListCardView.swift
//  WishOn
//
//  Created by Mari Budko on 29.11.2024.
//

import SwiftUI
import WOResources

public struct WishListCardViewState {
    public let imageName: String
    public let name: String
    public let formattedDate: String
    
    public init(imageName: String, name: String, formattedDate: String) {
        self.imageName = imageName
        self.name = name
        self.formattedDate = formattedDate
    }
}

public struct WishListCardView: View {
    public let viewState: WishListCardViewState
    
    public init(viewState: WishListCardViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
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
