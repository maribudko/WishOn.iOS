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
    
    public init(viewState: TextFieldViewState, onTextChanged: @escaping (String) -> Void) {
        self.viewState = viewState
        self.onTextChanged = onTextChanged
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
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
            
            if let error = viewState.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 5)
            }
        }
    }
}

#Preview {
    let viewState = TextFieldViewState(title: "Title", text: "Some text", errorMessage: nil, inputType: .url)
    TextFieldView(viewState: viewState) { text in
        
    }
}
