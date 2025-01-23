//
//  ToGiveView.swift
//  WishOn
//
//  Created by Mari Budko on 30.11.2024.
//

import SwiftUI

struct ToGiveView: View {
    @Environment(\.presentationMode) var presentationMode
    let columns: [GridItem] = {
        let width = UIScreen.main.bounds.width-32
        let itemsPerRow = Int(width / 100)
        return Array(repeating: GridItem(.flexible()), count: itemsPerRow)
    }()
    
    var body: some View {
        //NavigationView{
            VStack {
                ZStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("To Give")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color("PrimaryTitleColor"))
                }
                
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 32) {
                        ForEach(0..<5){index in
                            NavigationLink(destination: ToGiveCardDetails()) {
                                ToGiveCardView()
                            }
                        }
                    }
                    .padding(.top, 14)
                }
                .padding(.horizontal)
                //Spacer()
            }
            .background(Color("BackgroundColor"))
            .navigationBarHidden(true)
            .gesture(DragGesture().onChanged { value in
                if value.translation.width > 100 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    //}
}

struct ToGiveView_Preview: PreviewProvider {
    static var previews: some View {
        ToGiveView()
    }
}
