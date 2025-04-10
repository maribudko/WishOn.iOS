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
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(wishList.color))
                .shadow(radius: 5)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(Asset.primaryTitleColor.color).opacity(0.3))
                .frame(width: 20, height: 2)
                .padding(.top, 10)
                    
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                        
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
            .padding(10)
        }
        .frame(width: Constants.wishListCardWidth, height: Constants.wishListCardHeight)
        
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
