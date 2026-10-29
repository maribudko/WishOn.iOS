//
//  NewItemView.swift
//  WishOn
//
//  Created by Mari Budko on 01.12.2024.
//

import PhotosUI
import SwiftUI
import UIKit
import WOResources
import WODesign
import WOCore

public struct AddNewItemState {
    public let name: TextFieldViewState
    public let link: TextFieldViewState
    public let price: PriceInputViewState
    public let button: ButtonViewState
    public let crossIcon: IconViewState
    
    public  init(name: TextFieldViewState, link: TextFieldViewState, price: PriceInputViewState, button: ButtonViewState, crossIcon: IconViewState) {
        self.name = name
        self.link = link
        self.price = price
        self.button = button
        self.crossIcon = crossIcon
    }
}

public enum FocusableField: Hashable {
    case name
    case link
    case price
}

public struct AddNewItemView: View {
    @FocusState private var focusedField: FocusableField?
    @State private var previousFocusedField: FocusableField?

    
    @Binding var isShown: Bool
    @State private var showPhotoSourceDialog = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var photoItem: PhotosPickerItem?
    
    @ObservedObject var viewModel: AddNewItemViewModel
    
    public init(isShown: Binding<Bool>, viewModel: AddNewItemViewModel) {
        self._isShown = isShown
        self.viewModel = viewModel
    }

    private var fieldBorder: Color {
        HomeGridPalette.subtitle.opacity(AppOpacityLevels.homeGridTabDivider)
    }

    @ViewBuilder
    private var itemImage: some View {
        if let pickedImage = viewModel.pickedImage {
            Image(uiImage: pickedImage)
                .resizable()
                .scaledToFill()
        } else if let url = viewModel.previewImageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    placeholderImage
                }
            }
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        Image(asset: Asset.blankImage)
            .resizable()
            .renderingMode(.template)
            .scaledToFill()
            .foregroundColor(HomeGridPalette.accent)
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(AppOpacityLevels.backgroundOpacity)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        isShown = false
                    } label: {
                        IconView(viewState: viewModel.viewState.crossIcon)
                            .foregroundColor(HomeGridPalette.icon)
                    }
                    .frame(width: AppDimensions.iconSize,
                           height: AppDimensions.iconSize)
                    .accessibilityIdentifier(AccessibilityIdentifiers.addNewItemCloseButton)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button {
                    showPhotoSourceDialog = true
                } label: {
                    itemImage
                        .frame(width: AppDimensions.newItemImageSize,
                               height: AppDimensions.newItemImageSize)
                        .background(HomeGridPalette.coverPlaceholder)
                        .clipShape(.circle)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier(AccessibilityIdentifiers.addNewItemImage)
                .accessibilityLabel(L10n.chooseWishlistPhoto)
                
                TextFieldView(
                    viewState: viewModel.viewState.name,
                    textColor: HomeGridPalette.title,
                    fieldBackground: HomeGridPalette.card,
                    borderColor: fieldBorder,
                    placeholderColor: HomeGridPalette.subtitle,
                    accent: HomeGridPalette.accent,
                    onTextChanged: viewModel.onNameChanged(_:)
                )
                .focused($focusedField, equals: .name)
                .accessibilityIdentifier(AccessibilityIdentifiers.addNewItemName)
                
                TextFieldView(
                    viewState: viewModel.viewState.link,
                    textColor: HomeGridPalette.title,
                    fieldBackground: HomeGridPalette.card,
                    borderColor: fieldBorder,
                    placeholderColor: HomeGridPalette.subtitle,
                    accent: HomeGridPalette.accent,
                    onTextChanged: viewModel.onUrlChanged(_:)
                )
                .focused($focusedField, equals: .link)
                .accessibilityIdentifier(AccessibilityIdentifiers.addNewItemLink)
                
                PriceInputView(
                    viewState: viewModel.viewState.price,
                    onCurrencyChanged: viewModel.onCurrencyChanged(_:),
                    onPriceChanged: viewModel.onPriceChanged(_:)
                )
                .focused($focusedField, equals: .price)
                .accessibilityIdentifier(AccessibilityIdentifiers.addNewItemPrice)
                
                ButtonView(
                    buttonViewState: viewModel.viewState.button,
                    fill: HomeGridPalette.accent,
                    titleColor: HomeGridPalette.onAccent
                )
                    .disabled(!viewModel.isAddButtonEnabled)
                    .opacity(viewModel.isAddButtonEnabled ? 1 : 0.5)
                    .accessibilityIdentifier(AccessibilityIdentifiers.addNewItemCreateButton)
            }
            .padding(AppPaddings.padding20)
            .background(HomeGridPalette.background)
            .cornerRadius(AppRadiuses.roundedRectangleRadius)
            .shadow(color: AppShadows.homeGridCard.color,
                    radius: AppShadows.small.radius,
                    x: AppShadows.small.x,
                    y: AppShadows.small.y)
            .padding(.horizontal, AppPaddings.padding16)
            .background(DismissKeyboardOnOutsideTap { focusedField = nil })
            .preferredColorScheme(.light)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(L10n.attention),
                    message: Text(viewModel.alertMessage ?? ""),
                    dismissButton: .default(Text(L10n.okLabel))
                )
            }
            .confirmationDialog(L10n.chooseWishlistPhoto, isPresented: $showPhotoSourceDialog, titleVisibility: .visible) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button(L10n.camera) {
                        showCamera = true
                    }
                }
                Button(L10n.photoLibrary) {
                    showPhotoLibrary = true
                }
                Button(L10n.cancelLabel, role: .cancel) {}
            }
            .photosPicker(isPresented: $showPhotoLibrary, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            viewModel.onPhotoPicked(image)
                            photoItem = nil
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraImagePicker(
                    onImage: { viewModel.onPhotoPicked($0) },
                    onDismiss: { showCamera = false }
                )
                .ignoresSafeArea()
            }
            .alert(
                L10n.attention,
                isPresented: Binding(
                    get: { viewModel.photoErrorMessage != nil },
                    set: { isPresented in
                        if !isPresented {
                            viewModel.photoErrorMessage = nil
                        }
                    }
                )
            ) {
                Button(L10n.okLabel, role: .cancel) {
                    viewModel.photoErrorMessage = nil
                }
            } message: {
                Text(viewModel.photoErrorMessage ?? "")
            }
            .onChange(of: focusedField) { newFocus in
                if let lostFocus = previousFocusedField, lostFocus != newFocus {
                    switch lostFocus {
                    case .name:
                        viewModel.onFieldLostFocus(.name)
                    case .link:
                        viewModel.onFieldLostFocus(.url)
                    case .price:
                        viewModel.onFieldLostFocus(.price)
                    }
                }
                previousFocusedField = newFocus
            }
        }
    }
}

#Preview {
    let stateMachine = AddNewItemStateMachine(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close)))
    let stateFactory = AddNewItemStateFactory()
    let viewModel = AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
    
    return AddNewItemView(isShown: .constant(true), viewModel: viewModel)
}
