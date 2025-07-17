//
//  NewWishListStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation

final class NewWishListStateMachine {
    
    class DatePickerState {
        var date: Date = Date.now
        var isVisible: Bool = false
        var onDateSelected: (Date) -> Void
        var onDismiss: () -> Void
        
        init(isVisible: Bool, onDateSelected: @escaping (Date) -> Void, onDismiss: @escaping () -> Void) {
            self.isVisible = isVisible
            self.onDateSelected = onDateSelected
            self.onDismiss = onDismiss
        }
    }
    
    
    private let name: TextFieldState<TextFieldKind>
    private let description: TextFieldState<TextFieldKind>
    private lazy var datePicker: DatePickerState = {
        DatePickerState(isVisible: false, onDateSelected: onDateSelected,
        onDismiss: onDismiss)
    }()
    
    init() {
        self.name = .init(kind: TextFieldKind.name, validator: NameValidator())
        self.description = .init(kind: TextFieldKind.description, validator: PlainTextValidator())
    }
    
    func onDateSelected(_ date: Date) {
        datePicker.date = date
    }
    
    func onDismiss() {
        datePicker.isVisible = false
    }
    
    func setNameText(_ text: String) {
        name.text = text
        name.validateIfNeeded()
    }
    
    func setDescriptionText(_ text: String) {
        description.text = text
        description.validateIfNeeded()
    }
    
    func setDidLoseFocus(_ kind: TextFieldKind) {
        field(for: kind)?.wasFocused = true
        field(for: kind)?.validateIfNeeded()
    }
    
    func setDatePickerVisibility(_ isVisible: Bool) {
        datePicker.isVisible = isVisible
    }
    
    private func getAllFields() -> [TextFieldState<TextFieldKind>] {
        return [name, description]
    }
    
    private func validateAllFields() {
        let fields = getAllFields()
        
        fields.forEach {
            $0.wasFocused = true
            $0.validateIfNeeded()
        }
    }
    
    private func field(for kind: TextFieldKind) -> TextFieldState<TextFieldKind>? {
        switch kind {
        case .name:
            return name
        case .description:
            return description
        }
    }
}

extension NewWishListStateMachine {
    enum TextFieldKind: TextFieldKindRepresentable {
        case name, description
    }
}

extension NewWishListStateMachine {
    struct State {
        let nameField: TextFieldState<TextFieldKind>
        let descriptionField: TextFieldState<TextFieldKind>
        let datePicker: DatePickerState
    }
    
    var state: State {
        .init(nameField: name,
              descriptionField: description,
              datePicker: datePicker)
    }
}
