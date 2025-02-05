//
//  DatePickerView.swift
//  WishOn
//
//  Created by Mari Budko on 06.12.2024.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var date: String
    @Binding var isDatePickerVisible: Bool
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack {
                Text("Select a Date")
                    .font(.headline)
                    .padding()
                
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(
                    GraphicalDatePickerStyle()
                )
                .padding()
                
                Button("Done") {
                    date = formattedDate(selectedDate)
                    isDatePickerVisible = false
                }
                .padding(.vertical)
                .padding(.horizontal, 26)
                .background(Capsule().fill(Color(Asset.primaryColor.color)))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            }
            .background(Color(Asset.secondaryColor.color))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
            .padding()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

