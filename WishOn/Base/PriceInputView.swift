//
//  PriceInputView.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

struct PriceInputViewState {
    let price: String
    let currency: String
    let currencies: [String]
    let errorMessage: String?
}

struct PriceInputView: View {
    let viewState: PriceInputViewState
    let onPriceChanged: (String) -> Void
    let onCurrencyChanged: (String) -> Void
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                TextField(L10n.priceHint, text: Binding(
                    get: { viewState.price },
                    set: { price in
                        onPriceChanged(price)
                    }))
                .keyboardType(.decimalPad)
                .frame(maxWidth: .infinity)
                Picker("", selection: Binding(
                    get: { viewState.currency },
                    set: { currency in
                        onCurrencyChanged(currency)
                    })) {
                        ForEach(viewState.currencies, id: \.self) {
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
            
            if let error = viewState.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 5)
            }
        }
        
        
    }
}

#Preview {
    let viewState = PriceInputViewState(price: "100.0", currency: "UAH", currencies: ["UAH", "USD"], errorMessage: "Some error message")
    PriceInputView(viewState: viewState) { price in
        
    } onCurrencyChanged: { _ in
        
    }

}
