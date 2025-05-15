//
//  TextFieldView.swift
//  WishOn
//
//  Created by Mari Budko on 14.05.2025.
//

import SwiftUI

struct TextFieldViewState {
    let title: String
    let text: String
    let errorMessage: String?
}

struct TextFieldView: View {
    let viewState: TextFieldViewState
    let onTextChanged: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField(viewState.title, text: Binding(get: { viewState.text }, set: { onTextChanged($0) }))
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
    let viewState = TextFieldViewState(title: "Title", text: "Some text", errorMessage: nil)
    TextFieldView(viewState: viewState) { text in
        
    }
}
