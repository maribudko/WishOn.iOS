//
//  ToGiveCardDetails.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI

struct ToGiveCardDetails: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Text("To Give Card Details here")
            }
        }
        .navigationBarHidden(true)
        .gesture(DragGesture().onChanged { value in
            if value.translation.width > 100 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

#Preview {
    ToGiveCardDetails()
}
