//
//  TextFieldView.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

enum FieldKind {
    case name
    case city
}

public enum InputFieldType {
    case email
    case url
    case name
    case plain
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .url:
            return .URL
        case .name:
            return .default
        case .plain:
            return .default
        }
    }
    
    var autocapitalization: TextInputAutocapitalization {
        switch self {
        case .email, .url, .plain:
            return .never
        case .name:
            return .words
        }
    }
    
    var disableAutocorrection: Bool {
        switch self {
        case .email, .url:
            return true
        case .name, .plain:
            return false
        }
    }
}

public struct TextFieldViewState {
    public let title: String
    public let text: String
    public let errorMessage: String?
    public let inputType: InputFieldType
    
    public init(title: String, text: String, errorMessage: String?, inputType: InputFieldType) {
        self.title = title
        self.text = text
        self.errorMessage = errorMessage
        self.inputType = inputType
    }
}

public struct TextFieldView: View {
    public let viewState: TextFieldViewState
    public let onTextChanged: (String) -> Void
    public let textColor: Color?
    public let fieldBackground: Color?
    public let borderColor: Color?
    public let placeholderColor: Color?
    public let accent: Color?

    public init(
        viewState: TextFieldViewState,
        textColor: Color? = nil,
        fieldBackground: Color? = nil,
        borderColor: Color? = nil,
        placeholderColor: Color? = nil,
        accent: Color? = nil,
        onTextChanged: @escaping (String) -> Void
    ) {
        self.viewState = viewState
        self.onTextChanged = onTextChanged
        self.textColor = textColor
        self.fieldBackground = fieldBackground
        self.borderColor = borderColor
        self.placeholderColor = placeholderColor
        self.accent = accent
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            field
            if let error = viewState.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 5)
            }
        }
    }

    private var field: some View {
        let textField = TextField(
            "",
            text: Binding(
                get: { viewState.text },
                set: { onTextChanged($0) }
            ),
            prompt: Text(viewState.title).foregroundColor(placeholderColor ?? .secondary)
        )
        .keyboardType(viewState.inputType.keyboardType)
        .textInputAutocapitalization(viewState.inputType.autocapitalization)
        .disableAutocorrection(viewState.inputType.disableAutocorrection)

        return Group {
            if let fieldBackground {
                textField
                    .foregroundStyle(textColor ?? .primary)
                    .tint(accent ?? .accentColor)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, AppPaddings.padding8)
                    .padding(.vertical, AppPaddings.padding8)
                    .background(fieldBackground)
                    .cornerRadius(AppRadiuses.roundedRectangleRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius)
                            .stroke(borderColor ?? .clear, lineWidth: AppDimensions.borderThin)
                    )
            } else {
                TextField(
                    viewState.title,
                    text: Binding(
                        get: { viewState.text },
                        set: { onTextChanged($0) }
                    )
                )
                .keyboardType(viewState.inputType.keyboardType)
                .textInputAutocapitalization(viewState.inputType.autocapitalization)
                .disableAutocorrection(viewState.inputType.disableAutocorrection)
                .textFieldStyle(.roundedBorder)
            }
        }
    }
}

#Preview {
    let viewState = TextFieldViewState(title: "Title", text: "Some text", errorMessage: nil, inputType: .url)
    TextFieldView(viewState: viewState) { text in
        
    }
}
