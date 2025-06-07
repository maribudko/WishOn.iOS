//
//  DatePickerView.swift
//  WishOn
//
//  Created by Mari Budko on 06.12.2024.
//

import SwiftUI

struct DatePickerViewState {
    let selectedDate: Date
    //let isVisible: Bool // ??? Саша - продебажити
    let onDateSelected: (Date) -> Void
    let onDismiss: () -> Void
}

struct DatePickerView: View {
    
    let viewState: DatePickerViewState
    
    var body: some View {
        ZStack {
            Color.black.opacity(AppOpacityLevels.backgroundOpacity)
                .ignoresSafeArea()
            VStack {
                Text(L10n.selectDateHint)
                    .font(.headline)
                    .padding()
                
                DatePicker(
                    L10n.selectDateHint,
                    selection:
                        Binding(
                            get: {viewState.selectedDate},
                            set:
                                { date in
                                    viewState.onDateSelected(date)
                                }),
                    displayedComponents: [.date]
                )
                .datePickerStyle(
                    GraphicalDatePickerStyle()
                )
                .padding()
                
                Button(L10n.doneLabel) {
                    viewState.onDismiss()
                }
                .padding(.vertical)
                .padding(.horizontal, AppPaddings.padding26)
                .background(Capsule().fill(Color(Asset.primaryColor.color)))
                .foregroundColor(.white)
                .padding(.bottom, AppPaddings.padding8)
            }
            .background(Color(Asset.secondaryColor.color))
            .cornerRadius(AppRadiuses.roundedRectangleRadius)
            .shadow(color: AppShadows.medium.color,
                    radius: AppShadows.medium.radius,
                    x: AppShadows.medium.x,
                    y: AppShadows.medium.y)
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
