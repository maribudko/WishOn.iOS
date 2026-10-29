//
//  PriceInputView.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI
import WOResources

public struct PriceInputViewState {
    public let price: String
    public let currency: String
    public let currencies: [String]
    public let errorMessage: String?
    
    public init(price: String, currency: String, currencies: [String], errorMessage: String?) {
        self.price = price
        self.currency = currency
        self.currencies = currencies
        self.errorMessage = errorMessage
    }
}

public struct PriceInputView: View {
    public let viewState: PriceInputViewState
    public let onCurrencyChanged: (String) -> Void
    public let onPriceChanged: (String) -> Void
    
    public init(viewState: PriceInputViewState, onCurrencyChanged: @escaping (String) -> Void, onPriceChanged: @escaping (String) -> Void) {
        self.viewState = viewState
        self.onCurrencyChanged = onCurrencyChanged
        self.onPriceChanged = onPriceChanged
    }

    public var body: some View {
        VStack(alignment: .leading){
            HStack {
                TextField(
                    "",
                    text: Binding(
                        get: { viewState.price },
                        set: { price in
                            onPriceChanged(price)
                        }
                    ),
                    prompt: Text(L10n.priceHint).foregroundColor(HomeGridPalette.subtitle)
                )
                .foregroundColor(HomeGridPalette.title)
                .tint(HomeGridPalette.accent)
                .keyboardType(.decimalPad)
                .frame(maxWidth: .infinity)
                
                Picker("", selection: Binding(
                    get: {
                        viewState.currency
                    },
                    set: { currency in
                        onCurrencyChanged(currency)
                    })) {
                        ForEach(viewState.currencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(HomeGridPalette.accent)
            }
            .padding(AppPaddings.padding8)
            .background(HomeGridPalette.card)
            .cornerRadius(AppRadiuses.roundedRectangleRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius)
                    .stroke(
                        HomeGridPalette.subtitle.opacity(AppOpacityLevels.homeGridTabDivider),
                        lineWidth: AppDimensions.borderThin
                    )
            )
            .shadow(color: AppShadows.homeGridCard.color,
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
    PriceInputView(viewState: viewState, onCurrencyChanged: {_ in }, onPriceChanged: {_ in })
}
