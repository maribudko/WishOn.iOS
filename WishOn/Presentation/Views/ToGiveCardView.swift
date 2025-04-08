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
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(Asset.steelBlue.color))
                .shadow(radius: 5)
                    
            VStack {
                Image("filofax")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
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
            .padding(10)
        }
        .frame(width: 100, height: 140)
    }
    
}

#Preview {
    ToGiveCardView()
}
