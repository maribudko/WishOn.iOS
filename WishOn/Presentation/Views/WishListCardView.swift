//
//  WishListCardView.swift
//  WishOn
//
//  Created by Mari Budko on 29.11.2024.
//

import SwiftUI

struct WishListCardView: View {
    let wishList: WishList
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: AppRadiuses.radius10)
                .fill(Color(wishList.color))
                .shadow(radius: AppRadiuses.smallRadius)
            
            RoundedRectangle(cornerRadius: AppRadiuses.radius10)
                .fill(Color(Asset.primaryTitleColor.color).opacity(AppOpacityLevels.grabberOpacity))
                .frame(width: AppDimensions.grabberWidth, height: AppDimensions.grabberHeight)
                .padding(.top, AppPaddings.padding10)
                    
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: AppDimensions.wishCardImageSize, height: AppDimensions.wishCardImageSize)
                    .foregroundColor(.white)
                    .padding(.top, AppPaddings.padding10)
                        
                Spacer()
                
                Text(wishList.name)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(1)
                        
                Text("\(wishList.eventDate ?? .now, formatter: DateFormatter.shortDate)")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            .padding(AppPaddings.padding8)
        }
        .frame(width: AppDimensions.wishListCardWidth,
               height: AppDimensions.wishListCardHeight)
        
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

#Preview {
    WishListCardView(wishList: WishList(name: "Some", eventDate: Date(), wishes: []))
}
