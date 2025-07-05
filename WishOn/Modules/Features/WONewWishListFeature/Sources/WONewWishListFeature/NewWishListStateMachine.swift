//
//  NewWishListStateMachine.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation
import WODesign
import WOCore

public final class NewWishListStateMachine {
    
    public class DatePickerState {
        var date: Date = Date.now
        var isVisible: Bool = false
        var onDateSelected: (Date) -> Void
        var onDismiss: () -> Void
        
        public init(isVisible: Bool, onDateSelected: @escaping (Date) -> Void, onDismiss: @escaping () -> Void) {
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
    private let backButtonIcon: IconState
    private let dropDownIcon: IconState
    private let saveIcon: IconState
    private let plusIcon: IconState
    
    
    public init(backIcon: IconState, dropDownIcon: IconState, saveIcon: IconState, plusIcon: IconState) {
        self.name = .init(kind: TextFieldKind.name, validator: NameValidator())
        self.description = .init(kind: TextFieldKind.description, validator: PlainTextValidator())
        self.backButtonIcon = backIcon
        self.dropDownIcon = dropDownIcon
        self.saveIcon = saveIcon
        self.plusIcon = plusIcon
    }
    
    public func onDateSelected(_ date: Date) {
        datePicker.date = date
    }
    
    public func onDismiss() {
        datePicker.isVisible = false
    }
    
    public func setNameText(_ text: String) {
        name.text = text
        name.validateIfNeeded()
    }
    
    public func setDescriptionText(_ text: String) {
        description.text = text
        description.validateIfNeeded()
    }
    
    public func setDidLoseFocus(_ kind: TextFieldKind) {
        field(for: kind)?.wasFocused = true
        field(for: kind)?.validateIfNeeded()
    }
    
    public func setDatePickerVisibility(_ isVisible: Bool) {
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

public extension NewWishListStateMachine {
    enum TextFieldKind: TextFieldKindRepresentable {
        case name, description
    }
}

public extension NewWishListStateMachine {
    struct State {
        let nameField: TextFieldState<TextFieldKind>
        let descriptionField: TextFieldState<TextFieldKind>
        let datePicker: DatePickerState
        let backButtonIcon: IconState
        let dropDownIcon: IconState
        let saveIcon: IconState
        let plusIcon: IconState
    }
    
    var state: State {
        .init(
            nameField: name,
            descriptionField: description,
            datePicker: datePicker,
            backButtonIcon: backButtonIcon,
            dropDownIcon: dropDownIcon,
            saveIcon: saveIcon,
            plusIcon: plusIcon
        )
    }
}
