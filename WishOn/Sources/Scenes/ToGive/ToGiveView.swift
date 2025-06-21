//
//  ToGiveView.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI
import WOResources

struct ToGiveView: View {
    @Environment(\.presentationMode) var presentationMode
    let columns: [GridItem] = {
        let width = UIScreen.main.bounds.width-32
        let itemsPerRow = Int(width / 100)
        return Array(repeating: GridItem(.flexible()), count: itemsPerRow)
    }()
    
    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: SFSymbols.back.name)
                        .font(.title)
                        .foregroundColor(Color(Asset.primaryColor.color))
                })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("To Give")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(Asset.primaryTitleColor.color))
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: AppPaddings.spacing32) {
                    ForEach(0..<5) { _ in
                        NavigationLink(destination: ToGiveCardDetails()) {
                            ToGiveCardView()
                        }
                    }
                }
                .padding(.top, AppPaddings.padding14)
            }
            .padding(.horizontal)
        }
        .background(Color(Asset.backgroundColor.color))
        .navigationBarHidden(true)
        .gesture(DragGesture().onChanged { value in
            if value.translation.width > AppDimensions.minimumGestureSize {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

#Preview {
    ToGiveView()
}
