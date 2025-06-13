//
//  NewWishListView.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import SwiftUI

struct NewWishListState {
    let name: TextFieldViewState
    let description: TextFieldViewState
    let datePicker: DatePickerViewState
    let date: String
    let isDatePickerVisible: Bool
}

enum FocusedField: Hashable {
    case name
    case description
}

struct NewWishlistView: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusedField: FocusedField?
    
    @ObservedObject var viewModel: NewWishListViewModel
    @State var isNewItemDialogVisible: Bool = false
    @State var date = DateFormatter.shortDate.string(from: Date.now)
    
    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: SFSymbols.back.name)
                        .font(.title)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(L10n.newWishlistLbl)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(Asset.primaryColor.color))
                    .accessibilityIdentifier(L10n.newWishlistLbl)
                
                Button {
                    // TODO: save wishlist
                } label: {
                    Image(systemName: SFSymbols.arrowDown.name)
                        .font(.title)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            HStack {
                Image(asset: Asset.filofax)
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.newItemImageSize, height: AppDimensions.newItemImageSize)
                    .clipShape(.circle)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            TextFieldView(viewState: viewModel.viewState.name, onTextChanged: viewModel.onNameChanged(_:))
                .focused($focusedField, equals: .name)
                .padding(.horizontal, AppPaddings.padding16)
            
            TextFieldView(viewState: viewModel.viewState.description, onTextChanged: viewModel.onDescriptionChanged(_:))
                .focused($focusedField, equals: .description)
                .padding(.horizontal, AppPaddings.padding16)
            
            HStack {
                TextField(L10n.dateHint, text: $date)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, AppPaddings.padding8)
                Button {
                    viewModel.setDatePickerVisibility(true)
                } label: {
                    Image(systemName: SFSymbols.down.name)
                        .foregroundColor(Color(Asset.primaryTextColor.color))
                        .frame(alignment: .trailing)
                        .background(Color.clear)
                }
            }
            .padding(AppPaddings.padding8)
            .background(Color(.systemGray6))
            .cornerRadius(AppPaddings.padding5)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius)
                    .stroke(Asset.textFieldBackground.swiftUIColor, lineWidth: AppDimensions.borderThin)
            )
            .shadow(color: AppShadows.medium.color,
                    radius: AppShadows.medium.radius,
                    x: AppShadows.medium.x,
                    y: AppShadows.small.y)
            .padding(.horizontal, AppPaddings.padding16)
            
            Form {
                Section(header: Text(L10n.wishesCountLabel(viewModel.wishes.count))) {
                    if viewModel.wishes.isEmpty {
                        Text(L10n.noWishesLabel)
                            .foregroundColor(.gray)
                            .background(Asset.textFieldBackground.swiftUIColor)
                            .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                    } else {
                        ForEach(viewModel.wishes) { wish in
                            HStack {
                                Image(
                                    systemName: wish.isTaken == true ? SFSymbols.fillCircle.name : SFSymbols.circle.name
                                )
                                
                                Text(wish.name)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                
                                if !wish.link.isEmpty {
                                    Link(destination: URL(string: wish.link)!) {
                                        Image(systemName: SFSymbols.link.name)
                                            .foregroundColor(
                                                Color(Asset.primaryColor.color)
                                            )
                                    }
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Asset.textFieldBackground.swiftUIColor)
            }
            .padding(.top, AppPaddings.padding10)
            .scrollContentBackground(.hidden)
            .cornerRadius(AppRadiuses.smallRadius)
            
            HStack {
                Button {
                    isNewItemDialogVisible = true
                } label: {
                    Image(systemName: SFSymbols.plusCircle.name)
                        .resizable()
                        .frame(width: AppDimensions.fabSize, height: AppDimensions.fabSize)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.plusCircleFillButton)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .background(Asset.backgroundColor.swiftUIColor.gradient)
        .navigationBarHidden(true)
        .gesture(DragGesture().onChanged { value in
            if value.translation.width > AppDimensions.minimumGestureSize {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .overlay(content: {
            if viewModel.viewState.isDatePickerVisible {
                DatePickerView(viewState: viewModel.viewState.datePicker)
            }
            if isNewItemDialogVisible {
                let module = AppAssembler.shared
                    .resolver
                    .resolve(AddNewItemModule.self)
                module.view(isShown: $isNewItemDialogVisible)
            }
        })
        .accessibilityIdentifier(AccessibilityIdentifiers.newWishListView)
    }
}

#Preview {
    let stateMachine = NewWishListStateMachine()
    let viewStateFactory = NewWishListStateFactory()
   
    NewWishlistView(viewModel: NewWishListViewModel(stateMachine: stateMachine, stateFactory: viewStateFactory))
}
