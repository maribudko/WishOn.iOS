//
//  NewItemView.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import SwiftUI
import WOResources
import WODesign

struct AddNewItemState {
    let name: TextFieldViewState
    let link: TextFieldViewState
    let price: PriceInputViewState
    let button: ButtonViewState
    let crossIcon: IconViewState
}

enum FocusableField: Hashable {
    case name
    case link
    case price
}

struct AddNewItemView: View {
    @FocusState private var focusedField: FocusableField?
    
    @Binding var isShown: Bool
    
    @ObservedObject var viewModel: AddNewItemViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(AppOpacityLevels.backgroundOpacity)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        isShown = false
                    } label: {
                        IconView(viewState: viewModel.viewState.crossIcon)
                            .foregroundColor(Color(Asset.primaryColor.color))
                    }
                    .frame(width: AppDimensions.iconSize,
                           height: AppDimensions.iconSize)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Image(asset: Asset.blankImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.newItemImageSize,
                           height: AppDimensions.newItemImageSize)
                    .clipShape(.circle)
                
                TextFieldView(
                    viewState: viewModel.viewState.name,
                    onTextChanged: viewModel.onNameChanged(_:)
                )
                .focused($focusedField, equals: .name)
                
                TextFieldView(
                    viewState: viewModel.viewState.link,
                    onTextChanged: viewModel.onUrlChanged(_:)
                )
                .focused($focusedField, equals: .link)
                
                PriceInputView(
                    viewState: viewModel.viewState.price,
                    onCurrencyChanged: viewModel.onCurrencyChanged(_:),
                    onPriceChanged: viewModel.onPriceChanged(_:)
                )
                .focused($focusedField, equals: .price)
                
                ButtonView(buttonViewState: viewModel.viewState.button)
                    .disabled(!viewModel.isAddButtonEnabled)
                    .opacity(viewModel.isAddButtonEnabled ? 1 : 0.5)
            }
            .padding(AppPaddings.padding20)
            .cornerRadius(AppRadiuses.roundedRectangleRadius)
            .background(Color(Asset.backgroundColor.color))
            .shadow(color: AppShadows.small.color,
                    radius: AppShadows.small.radius,
                    x: AppShadows.small.x,
                    y: AppShadows.small.y)
            .padding(.horizontal, AppPaddings.padding16)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(L10n.attention),
                      message: Text(viewModel.alertMessage ?? ""),
                      dismissButton: .default(Text(L10n.okLabel)){
                    viewModel.onSuccess?()
                })
            }
            .onChange(of: focusedField) { oldFocus, newFocus in
                if let lostFocus = oldFocus, lostFocus != newFocus {
                    switch lostFocus {
                    case .name:
                        viewModel.onFieldLostFocus(.name)
                    case .link:
                        viewModel.onFieldLostFocus(.url)
                    case .price:
                        viewModel.onFieldLostFocus(.price)
                    }
                }
            }
        }
    }
}

#Preview {
    let stateMachine = AddNewItemStateMachine(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close)))
    let stateFactory = AddNewItemStateFactory()
    let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
    
    AddNewItemView(isShown: .constant(true), viewModel: viewModel)
}
