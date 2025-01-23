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
                
                Text("New wishlist")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color("PrimaryTitleColor"))
                
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
            
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 16)
            
            TextField("Description", text: $description)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 16)
            
            
            HStack {
                TextField("Date", text: $date)
                    .frame(maxWidth: .infinity)
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
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
            .padding(.horizontal, 16)
            
            Form {
                Section(header: Text("Your wishes (\(wishes.count))")){
                    if wishes.isEmpty {
                        Text("No wishes yet. Tap the button below to add one!")
                            .foregroundColor(.gray)
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
            }
            .padding(.top, 10)
            .scrollContentBackground(.hidden)
            .cornerRadius(8)
            
            HStack{
                Button {
                    isNewItemDialogVisible = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color(Asset.primaryColor.color))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .background(Color("BackgroundColor").gradient)
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
                AddNewItemView(isShown: $isNewItemDialogVisible)
            }
        })
       
    }
}


struct NewWishListView_Preview: PreviewProvider {
    static var previews: some View {
        AddWishlistView()
    }
}
