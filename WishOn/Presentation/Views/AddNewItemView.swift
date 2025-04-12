//
//  NewItemView.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import SwiftUI

struct AddNewItemView: View {
    @Binding var isShown: Bool
    @State private var name = ""
    @State private var wishLink = ""
    @State private var imageLink = ""
    @State private var price = ""
    @State private var currency = L10n.uah
    @Binding var wishes: [Wish]
    
    private let currencies = [L10n.usd, L10n.eur, L10n.uah]
    var body: some View {
        ZStack {
            Color.black.opacity(AppOpacityLevels.backgroundOpacity)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        isShown = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(Color(Asset.primaryColor.color))
                    }
                    .frame(width: AppDimensions.iconSize,
                           height: AppDimensions.iconSize)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                Image("filofax")
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.newItemImageSize,
                           height: AppDimensions.newItemImageSize)
                    .clipShape(.circle)
                TextField(L10n.nameHint, text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField(L10n.linkHint, text: $wishLink)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    TextField(L10n.priceHint, text: $price)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: .infinity)
                    Picker("", selection: $currency) {
                        ForEach(currencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(Color(Asset.primaryColor.color))
                }
                .padding(AppPaddings.padding8)
                .background(Color(.systemGray6))
                .cornerRadius(AppRadiuses.roundedRectangleRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius)
                        .stroke(Color(.systemGray5), lineWidth: AppDimensions.borderThin)
                )
                .shadow(color: AppShadows.medium.color,
                        radius: AppShadows.medium.radius,
                        x: AppShadows.medium.x,
                        y: AppShadows.medium.y)
                
                Button {
                    let wish = Wish(name: name, image: imageLink, currency: currency, link: wishLink)
                    wishes.append(wish)
                    isShown = false
                } label: {
                    Text(L10n.createLabel)
                        .padding(.horizontal, AppPaddings.padding16)
                        .foregroundStyle(Color(Asset.greenButtonTextColor.color))
                }
                .padding()
                .background(Color(Asset.primaryColor.color))
                .cornerRadius(AppRadiuses.buttonRadius)
                .padding(.top, AppPaddings.padding20)
                
            }
            .padding(AppPaddings.padding20)
            .cornerRadius(AppRadiuses.roundedRectangleRadius)
            .background(Color(Asset.backgroundColor.color))
            .shadow(color: AppShadows.small.color,
                    radius: AppShadows.small.radius,
                    x: AppShadows.small.x,
                    y: AppShadows.small.y)
            .padding(.horizontal, AppPaddings.padding16)
        }
    }
}

#Preview {
    AddNewItemView(isShown: .constant(true), wishes: .constant([]))
}
