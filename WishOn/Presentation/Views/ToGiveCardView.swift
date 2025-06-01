//
//  ToGiveCardView.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI

struct ToGiveCardView: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: AppRadiuses.radius10)
                .fill(Color(Asset.steelBlue.color))
                .shadow(radius: AppRadiuses.smallRadius)
                    
            VStack {
                Image("filofax")
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.wishListCardWidth, height: AppDimensions.wishListCardWidth)
                    .clipped()
                    .foregroundColor(.white)
                
                Text("Filofax Finsbury")
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                        
                Text("10.12.24")
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
