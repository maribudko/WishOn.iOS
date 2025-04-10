//
//  WishListDetailsView.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI

struct WishListDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("PrimaryColor"))
                })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("WishList Details")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("PrimaryTitleColor"))
            }
            
            Spacer()
        }
        .background(Color(Asset.backgroundColor.color).gradient)
        .navigationBarHidden(true)
        .gesture(DragGesture().onChanged { value in
            if value.translation.width > 100 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

#Preview {
    WishListDetailsView()
}
