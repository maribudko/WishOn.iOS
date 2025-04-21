//
//  NewItemView.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import SwiftUI


final class AddNewItemViewModel: ObservableObject {
    @Published var name = ""
    @Published var wishLink = ""
    @Published var imageLink = ""
    @Published var price = ""
    @Published var currency = L10n.uah
    @Published var nameState: FieldState = .valid
    @Published var linkState: FieldState = .valid
    @Published var priceState: FieldState = .valid
    
    @Published var state: AddNewItemState = .idle
    
    let currencies = [L10n.usd, L10n.eur, L10n.uah]
    var priceValue: Double?
    
    func validate() -> (Bool, String?) {
        state = .validating
        var isValid = true
        var errorMessage: String? = nil
        
        if name.isEmpty {
            nameState = .invalid(L10n.cannotBeEmpty)
            isValid = false
            if errorMessage == nil {
                errorMessage = L10n.nameCannotBeEmpty
            }
        } else {
            nameState = .valid
        }
        
        if wishLink.isEmpty {
            linkState = .invalid(L10n.cannotBeEmpty)
            isValid = false
            if errorMessage == nil {
                errorMessage = L10n.linkCannotBeEmpty
            }
        } else if let url = URL(string: wishLink), url.scheme == "http" || url.scheme == "https" {
            linkState = .valid
        } else {
            linkState = .invalid(L10n.invalidUrl)
            isValid = false
            if errorMessage == nil {
                errorMessage = L10n.invalidUrl
            }
        }
        
        if let priceValue = Double(price),
           priceValue > 0 {
            priceState = .valid
            self.priceValue = priceValue
        } else {
            priceState = .invalid(L10n.invalidPrice)
            isValid = false
            if errorMessage == nil {
                errorMessage = L10n.invalidPrice
            }
        }
        
        if isValid {
            state = .valid
        }
        
        return (isValid, errorMessage)
    }
    
    
    func save(to wishes: Binding<[Wish]>, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let (isValid, errorMessage) = validate()
        guard isValid else {
            let message = errorMessage ?? L10n.fillAllFields
            state = .error(message)
            onError(message)
            return
        }
        
        state = .saving
        
        // network request imitation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newWish = Wish(id: UUID(),
                               name: self.name,
                               image: self.imageLink,
                               price: self.priceValue,
                               currency: self.currency,
                               link: self.wishLink,
                               isTaken: false)
            wishes.wrappedValue.append(newWish)
            
            self.state = .success
            onSuccess()
        }
    }
    
}

enum FieldState: Equatable {
    case valid
    case invalid(String)
}

enum AddNewItemState: Equatable {
    case idle
    case validating
    case valid
    case saving
    case success
    case error(String)
}

struct AddNewItemView: View {
    @Binding var isShown: Bool
    @Binding var wishes: [Wish]
    
    @StateObject private var viewModel = AddNewItemViewModel()
    @State var showErrorAlert: Bool = false
    @State var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(AppOpacityLevels.backgroundOpacity)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        isShown = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(Color(Asset.primaryColor.color))
                    }
                    .frame(width: AppDimensions.iconSize,
                           height: AppDimensions.iconSize)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                Image("filofax")
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppDimensions.newItemImageSize,
                           height: AppDimensions.newItemImageSize)
                    .clipShape(.circle)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    TextField(L10n.nameHint, text: $viewModel.name)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: viewModel.name) { _, _ in
                            viewModel.nameState = .valid
                        }
                    if case .invalid(let message) = viewModel.nameState {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    TextField(L10n.linkHint, text: $viewModel.wishLink)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: viewModel.wishLink) { _, _ in
                            viewModel.linkState = .valid
                        }
                    if case .invalid(let message) = viewModel.linkState {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                
                HStack {
                    TextField(L10n.priceHint, text: $viewModel.price)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: .infinity)
                    Picker("", selection: $viewModel.currency) {
                        ForEach(viewModel.currencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(Color(Asset.primaryColor.color))
                }
                .padding(AppPaddings.padding8)
                .background(Color(.systemGray6))
                .cornerRadius(AppRadiuses.roundedRectangleRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius)
                        .stroke(Color(.systemGray5), lineWidth: AppDimensions.borderThin)
                )
                .shadow(color: AppShadows.medium.color,
                        radius: AppShadows.medium.radius,
                        x: AppShadows.medium.x,
                        y: AppShadows.medium.y)
                
                Button {
                    viewModel.save(to: $wishes) {
                        withAnimation {
                            isShown = false
                        }
                    } onError: {message in
                        showErrorAlert = true
                        errorMessage = message
                        viewModel.state = .idle
                    }
                } label: {
                    if viewModel.state == .saving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(height: 20)
                    } else {
                        Text(L10n.createLabel)
                            .padding(.horizontal, AppPaddings.padding16)
                            .foregroundStyle(Color(Asset.greenButtonTextColor.color))
                    }
                }
                .padding()
                .background(Color(Asset.primaryColor.color))
                .cornerRadius(AppRadiuses.buttonRadius)
                .padding(.top, AppPaddings.padding20)
            }
            .disabled(viewModel.state == .saving)
            .padding(AppPaddings.padding20)
            .cornerRadius(AppRadiuses.roundedRectangleRadius)
            .background(Color(Asset.backgroundColor.color))
            .shadow(color: AppShadows.small.color,
                    radius: AppShadows.small.radius,
                    x: AppShadows.small.x,
                    y: AppShadows.small.y)
            .padding(.horizontal, AppPaddings.padding16)
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text(L10n.attention),
                      message: Text(errorMessage),
                      dismissButton: .default(Text(L10n.okLabel)))
            }
        }
    }
}

#Preview {
    AddNewItemView(isShown: .constant(true), wishes: .constant([]))
}
