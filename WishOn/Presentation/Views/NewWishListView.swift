//
//  NewWishListView.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import SwiftUI

struct AddWishlistView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var description = ""
    @State private var selectedDate = Date()
    @State private var date = ""
    @State private var isDatePickerVisible = false
    @State private var isNewItemDialogVisible = false
    @State private var wishes: [Wish] = []
    @ObservedObject var viewModel: WishListViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
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
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            HStack {
                Image("filofax")
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.newItemImageSize, height: AppDimensions.newItemImageSize)
                    .clipShape(.circle)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            TextField(L10n.nameHint, text: $name)
                .frame(height: AppDimensions.textFieldHeight)
                .padding(.horizontal, AppPaddings.padding16)
                .padding(.vertical, AppPaddings.padding5)
                .background(Asset.textFieldBackground.swiftUIColor)
                .cornerRadius(AppRadiuses.smallRadius)
                .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                .padding(.horizontal, AppPaddings.padding16)
                .padding(.vertical, AppPaddings.padding5)
            
            TextField(L10n.descriptionHint, text: $description)
                .frame(height: AppDimensions.textFieldHeight)
                .padding(.horizontal, AppPaddings.padding16)
                .padding(.bottom, AppPaddings.padding5)
                .background(Asset.textFieldBackground.swiftUIColor)
                .cornerRadius(AppRadiuses.smallRadius)
                .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                .padding(.horizontal, AppPaddings.padding16)
                .padding(.bottom, AppPaddings.padding5)
            
            HStack {
                TextField(L10n.dateHint, text: $date)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, AppPaddings.padding8)
                Button {
                    isDatePickerVisible = true
                } label: {
                    Image(systemName: "chevron.down")
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
                Section(header: Text(L10n.wishesCountLabel(wishes.count))) {
                    if wishes.isEmpty {
                        Text(L10n.noWishesLabel)
                            .foregroundColor(.gray)
                            .background(Asset.textFieldBackground.swiftUIColor)
                            .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                    } else {
                        ForEach(wishes) { wish in
                            HStack {
                                Image(
                                    systemName: wish.isTaken == true ? "largecircle.fill.circle" : "circle"
                                )
                                
                                Text(wish.name)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                
                                if !wish.link.isEmpty {
                                    Link(destination: URL(string: wish.link)!) {
                                        Image(systemName: "link")
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
                    Image(systemName: "plus.circle.fill")
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
            if isDatePickerVisible {
                DatePickerView(selectedDate: $selectedDate, date: $date, isDatePickerVisible: $isDatePickerVisible)
            }
            if isNewItemDialogVisible {
                let module = AddNewItemModule(isShown: $isNewItemDialogVisible)
                module.view()
            }
        })
        .accessibilityIdentifier(AccessibilityIdentifiers.newWishListView)
    }
}

#Preview {
    let stateMachine = WishListsStateMachine()
    let viewStateFactory = WishListsStateFactory()
    let useCase = WishListsInteractor(repository: WishListRepository())
   
    
    AddWishlistView(viewModel: WishListViewModel(stateMachine: stateMachine, stateFactory: viewStateFactory, useCase: useCase))
}
