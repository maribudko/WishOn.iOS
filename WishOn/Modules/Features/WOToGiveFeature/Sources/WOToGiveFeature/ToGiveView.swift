//
//  ToGiveView.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI
import WOResources
import WODesign
import WOCore

public struct ToGiveView: View {
    @Environment(\.presentationMode) var presentationMode
    let columns: [GridItem] = {
        let width = UIScreen.main.bounds.width-32
        let itemsPerRow = Int(width / 100)
        return Array(repeating: GridItem(.flexible()), count: itemsPerRow)
    }()
    
    public init() {}
    
    public var body: some View {
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
                
                Text(L10n.toGive)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(Asset.primaryTitleColor.color))
                    .accessibilityIdentifier(AccessibilityIdentifiers.toGiveLabel)
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
