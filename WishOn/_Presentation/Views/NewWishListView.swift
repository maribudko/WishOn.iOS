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
                
                Text(LocalizedStrings.newWishListLbl)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("PrimaryTitleColor"))
                    .accessibilityIdentifier("newWishlistLabel")
                
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
            
            HStack{
                Image("filofax")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(.circle)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            TextField(LocalizedStrings.nameHint, text: $name)
                .frame(height: 30)
                .padding(.horizontal, 16)
                .padding(.vertical, 5)
                .background(Asset.textFieldBackground.swiftUIColor)
                .cornerRadius(5)
                .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 5)
                //.accessibilityIdentifier("nameTextField")
            
            TextField(LocalizedStrings.descriptionHint, text: $description)
                .frame(height: 30)
                .padding(.horizontal, 16)
                .padding(.bottom, 5)
                .background(Asset.textFieldBackground.swiftUIColor)
                .cornerRadius(5)
                .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                .padding(.horizontal, 16)
                .padding(.bottom, 5)
                
            
            HStack {
                TextField(LocalizedStrings.dateHint, text: $date)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
                Button {
                    isDatePickerVisible = true
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color(Asset.primaryTextColor.color))
                        .frame(alignment: .trailing)
                        .background(Color.clear)
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Asset.textFieldBackground.swiftUIColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
            .padding(.horizontal, 16)
            
            Form {
                Section(header: Text(LocalizedStrings.wishesCountLabel(wishes.count))){
                    if wishes.isEmpty {
                        Text(LocalizedStrings.noWishesView)
                            .foregroundColor(.gray)
                            .background(Asset.textFieldBackground.swiftUIColor)
                            .foregroundColor(Asset.primaryTextColor.swiftUIColor)
                    } else {
                        ForEach(wishes) {wish in
                            HStack{
                                Image(
                                    systemName: wish.isSelected == true ? "largecircle.fill.circle" : "circle"
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
            .padding(.top, 10)
            .scrollContentBackground(.hidden)
            .cornerRadius(5)
            
            HStack{
                Button {
                    isNewItemDialogVisible = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
                .accessibilityIdentifier("plusCircleFillButton")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .background(Asset.backgroundColor.swiftUIColor.gradient)
        .navigationBarHidden(true)
        .gesture(DragGesture().onChanged { value in
            if value.translation.width > 100 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .overlay(content: {
            if isDatePickerVisible {
                DatePickerView(selectedDate: $selectedDate, date: $date, isDatePickerVisible: $isDatePickerVisible)
            }
            if isNewItemDialogVisible {
                AddNewItemView(isShown: $isNewItemDialogVisible, wishes: $wishes)
            }
        })
        .accessibilityIdentifier(AccessibilityIdentifiers.newWishListView)
       
    }
        
}


struct NewWishListView_Preview: PreviewProvider {
    static var previews: some View {
        AddWishlistView()
    }
}
