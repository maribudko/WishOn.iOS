//
//  ToGiveCardView.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI
import WOResources
import WODesign

public struct ToGiveCardView: View {
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: AppRadiuses.radius10)
                .fill(Color(Asset.steelBlue.color))
                .shadow(radius: AppRadiuses.smallRadius)
                    
            VStack {
                Image(asset: Asset.blankImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.wishListCardWidth, height: AppDimensions.wishListCardWidth)
                    .clipped()
                    .foregroundColor(.white)
                
                Text(L10n.nameHint)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                        
                Text(L10n.dateHint)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            .padding(AppPaddings.padding10)
        }
        .frame(width: AppDimensions.toGiveCardViewWidth, height: AppDimensions.toGiveCardViewHeight)
    }
    
}

#Preview {
    ToGiveCardView()
}
