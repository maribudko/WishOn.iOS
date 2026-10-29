//
//  NewWishListStateFactory.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation
import WOResources
import WODesign

public final class NewWishListStateFactory {
    public init() {}
    public func make(from state: NewWishListStateMachine.State) -> NewWishListState {
        
        let datePicker = DatePickerViewState(
            selectedDate: state.datePicker.date,
            onDateSelected: state.datePicker.onDateSelected,
            onDismiss: state.datePicker.onDismiss,
            onConfirm: state.datePicker.onConfirm
        )
        
        let dateString = state.datePicker.committedDate.map { DateFormatter.shortDate.string(from: $0) } ?? ""
        
        return .init(
            name: makeField(from: state.nameField),
            description: makeField(from: state.descriptionField),
            datePicker: datePicker,
            backIcon: makeIcon(from: state.backButtonIcon),
            dropDownIcon: makeIcon(from: state.dropDownIcon),
            saveIcon: makeIcon(from: state.saveIcon),
            plusIcon: makeIcon(from: state.plusIcon),
            date: dateString,
            isDatePickerVisible: state.datePicker.isVisible)
    }
}

private extension NewWishListStateFactory {
    func makeField(from state: TextFieldState<NewWishListStateMachine.TextFieldKind>) -> TextFieldViewState {
        let title: String
        let errorMessage: String?
        let inputType: InputFieldType
        
        switch state.kind {
        case .name:
            title = L10n.nameHint
            errorMessage = state.isError ? L10n.nameCannotBeEmpty : nil
            inputType = .name
        case .description:
            title = L10n.descriptionHint
            errorMessage = nil
            inputType = .plain
        }
        return .init(title: title, text: state.text, errorMessage: errorMessage, inputType: inputType)
    }
    
    func makeIcon(from state: IconState) -> IconViewState {
        return .init(icon: state.icon, isResizable: state.isResizable)
    }
}
