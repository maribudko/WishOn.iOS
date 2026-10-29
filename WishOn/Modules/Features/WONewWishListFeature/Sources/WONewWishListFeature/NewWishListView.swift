//
//  NewWishListView.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import PhotosUI
import SwiftUI
import UIKit
import WOResources
import WODesign
import DependencyInjection
import WOCore
import WOAddNewItemFeature

public struct NewWishListState {
    let name: TextFieldViewState
    let description: TextFieldViewState
    let datePicker: DatePickerViewState
    let backIcon: IconViewState
    let dropDownIcon: IconViewState
    let saveIcon: IconViewState
    let plusIcon: IconViewState
    let date: String
    let isDatePickerVisible: Bool
    
    public init(name: TextFieldViewState, description: TextFieldViewState, datePicker: DatePickerViewState, backIcon: IconViewState, dropDownIcon: IconViewState, saveIcon: IconViewState, plusIcon: IconViewState, date: String, isDatePickerVisible: Bool) {
        self.name = name
        self.description = description
        self.datePicker = datePicker
        self.backIcon = backIcon
        self.dropDownIcon = dropDownIcon
        self.saveIcon = saveIcon
        self.plusIcon = plusIcon
        self.date = date
        self.isDatePickerVisible = isDatePickerVisible
    }
}

public enum FocusedField: Hashable {
    case name
    case description
}

public struct NewWishlistView: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusedField: FocusedField?
    
    @ObservedObject var viewModel: NewWishListViewModel
    @State var isNewItemDialogVisible: Bool = false
    @State private var showPhotoSourceDialog = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedWish: Wish?
    
    public init( viewModel: NewWishListViewModel) {
        self.viewModel = viewModel
    }

    private var fieldBorder: Color {
        HomeGridPalette.subtitle.opacity(AppOpacityLevels.homeGridTabDivider)
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
        VStack {
            ZStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    IconView(viewState: viewModel.viewState.backIcon)
                        .font(.title)
                        .foregroundColor(HomeGridPalette.icon)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityIdentifier(AccessibilityIdentifiers.newWishListBackButton)
                
                Text(viewModel.screenTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(HomeGridPalette.title)
                    .accessibilityIdentifier(AccessibilityIdentifiers.newWishListLabel)
                
                if viewModel.isEditable {
                    Button {
                        viewModel.onSaveTapped()
                    } label: {
                        IconView(viewState: viewModel.viewState.saveIcon)
                            .font(.body.weight(.semibold))
                            .foregroundColor(HomeGridPalette.icon)
                    }
                    .disabled(viewModel.isSaving)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityIdentifier(AccessibilityIdentifiers.newWishListSaveButton)
                }
            }
            
            HStack {
                coverButton
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
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
                .disabled(!viewModel.isEditable)
                .padding(.horizontal, AppPaddings.padding16)
                .accessibilityIdentifier(AccessibilityIdentifiers.newWishListName)
            
            TextFieldView(
                viewState: viewModel.viewState.description,
                textColor: HomeGridPalette.title,
                fieldBackground: HomeGridPalette.card,
                borderColor: fieldBorder,
                placeholderColor: HomeGridPalette.subtitle,
                accent: HomeGridPalette.accent,
                onTextChanged: viewModel.onDescriptionChanged(_:)
            )
                .focused($focusedField, equals: .description)
                .disabled(!viewModel.isEditable)
                .padding(.horizontal, AppPaddings.padding16)
                .accessibilityIdentifier(AccessibilityIdentifiers.newWishListDescription)
            
            HStack {
                dateLabel
                if viewModel.isEditable, !viewModel.viewState.date.isEmpty {
                    Button {
                        viewModel.clearDate()
                    } label: {
                        Image(systemName: SFSymbols.close.name)
                            .foregroundColor(HomeGridPalette.icon)
                    }
                }
                if viewModel.isEditable {
                    Button {
                        viewModel.setDatePickerVisibility(true)
                    } label: {
                        IconView(viewState: viewModel.viewState.dropDownIcon)
                            .foregroundColor(HomeGridPalette.icon)
                            .frame(alignment: .trailing)
                            .background(Color.clear)
                    }
                }
            }
            .padding(AppPaddings.padding8)
            .background(HomeGridPalette.card)
            .cornerRadius(AppPaddings.padding5)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadiuses.roundedRectangleRadius)
                    .stroke(fieldBorder, lineWidth: AppDimensions.borderThin)
            )
            .shadow(color: AppShadows.homeGridCard.color,
                    radius: AppShadows.medium.radius,
                    x: AppShadows.medium.x,
                    y: AppShadows.small.y)
            .padding(.horizontal, AppPaddings.padding16)
            
            wishesCard
                .padding(.horizontal, AppPaddings.padding16)
                .padding(.top, AppPaddings.padding10)
                .padding(.bottom, AppPaddings.padding10)
        }

        if viewModel.isEditable {
            Button {
                isNewItemDialogVisible = true
            } label: {
                IconView(viewState: viewModel.viewState.plusIcon)
                    .frame(width: AppDimensions.fabSize, height: AppDimensions.fabSize)
                    .foregroundColor(HomeGridPalette.accent)
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.plusCircleFillButton)
            .padding()
        }
        }
        .sheet(item: $selectedWish) { wish in
            WishItemSheet(wish: wish)
        }
        .background(HomeGridPalette.background.ignoresSafeArea())
        .background(DismissKeyboardOnOutsideTap { focusedField = nil })
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .onChange(of: viewModel.didSave) { didSave in
            if didSave {
                presentationMode.wrappedValue.dismiss()
            }
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
                        viewModel.onCoverImagePicked(image)
                        photoItem = nil
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraImagePicker(
                onImage: { viewModel.onCoverImagePicked($0) },
                onDismiss: { showCamera = false }
            )
            .ignoresSafeArea()
        }
        .alert(
            L10n.attention,
            isPresented: Binding(
                get: { viewModel.saveErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearSaveError()
                    }
                }
            )
        ) {
            Button(L10n.okLabel, role: .cancel) {
                viewModel.clearSaveError()
            }
        } message: {
            Text(viewModel.saveErrorMessage ?? "")
        }
        .gesture(DragGesture().onChanged { value in
            if value.translation.width > AppDimensions.minimumGestureSize {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .overlay(content: {
            if viewModel.viewState.isDatePickerVisible {
                DatePickerView(viewState: viewModel.viewState.datePicker)
            }
            if isNewItemDialogVisible {
                AppAssembler.shared
                    .resolver
                    .resolve(AddNewItemModule.self)
                    .view(isShown: $isNewItemDialogVisible) { wish in
                        viewModel.addWish(wish)
                    }
            }
        })
    }

    private var wishesCard: some View {
        VStack(alignment: .leading, spacing: AppPaddings.padding8) {
            Text(L10n.wishesCountLabel(viewModel.wishes.count))
                .font(.title3.weight(.semibold))
                .foregroundColor(HomeGridPalette.title)
                .padding(.horizontal, AppPaddings.padding16)
                .padding(.top, AppPaddings.padding16)

            if viewModel.wishes.isEmpty {
                Text(L10n.noWishesLabel)
                    .foregroundColor(HomeGridPalette.subtitle)
                    .padding(.horizontal, AppPaddings.padding16)
                    .padding(.bottom, AppPaddings.padding16)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.wishes.enumerated()), id: \.element.id) { index, wish in
                            if index > 0 {
                                Rectangle()
                                    .fill(HomeGridPalette.subtitle.opacity(AppOpacityLevels.homeGridTabDivider))
                                    .frame(height: AppDimensions.homeGridTabDividerHeight)
                                    .padding(.horizontal, AppPaddings.padding16)
                            }
                            Button {
                                selectedWish = wish
                            } label: {
                                wishRow(wish)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, viewModel.isEditable ? AppDimensions.fabSize : AppPaddings.padding16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(HomeGridPalette.card)
        .clipShape(RoundedRectangle(cornerRadius: AppRadiuses.radius12, style: .continuous))
        .shadow(
            color: AppShadows.homeGridCard.color,
            radius: AppShadows.homeGridCard.radius,
            x: AppShadows.homeGridCard.x,
            y: AppShadows.homeGridCard.y
        )
    }
    
    private func wishRow(_ wish: Wish) -> some View {
        HStack(alignment: .center, spacing: AppPaddings.padding16) {
            wishThumbnail(wish)
            VStack(alignment: .leading, spacing: AppPaddings.padding5) {
                Text(wish.name)
                    .font(.body)
                    .foregroundColor(HomeGridPalette.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                if let price = WishDisplay.price(for: wish) {
                    Text(price)
                        .font(.body.weight(.semibold))
                        .foregroundColor(HomeGridPalette.title)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if WishDisplay.websiteURL(for: wish.link) != nil {
                Image(systemName: SFSymbols.link.name)
                    .font(.body.weight(.semibold))
                    .foregroundColor(HomeGridPalette.accent)
            }
        }
        .padding(.horizontal, AppPaddings.padding16)
        .padding(.vertical, AppPaddings.padding10)
    }
    
    private func wishThumbnail(_ wish: Wish) -> some View {
        ZStack {
            HomeGridPalette.coverPlaceholder
            if let url = WishDisplay.websiteURL(for: wish.image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        thumbnailPlaceholder
                    }
                }
            } else if let localURL = WishListImageStore.fileURL(for: wish.image),
                      let localImage = UIImage(contentsOfFile: localURL.path) {
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFill()
            } else {
                thumbnailPlaceholder
            }
        }
        .frame(width: AppDimensions.wishRowThumbnailSize, height: AppDimensions.wishRowThumbnailSize)
        .clipShape(RoundedRectangle(cornerRadius: AppRadiuses.radius10, style: .continuous))
    }
    
    private var thumbnailPlaceholder: some View {
        Image(asset: Asset.blankImage)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .padding(AppPaddings.padding14)
            .foregroundColor(HomeGridPalette.accent)
    }
    
    @ViewBuilder
    private var dateLabel: some View {
        let label = Text(viewModel.viewState.date.isEmpty ? L10n.dateHint : viewModel.viewState.date)
            .foregroundColor(viewModel.viewState.date.isEmpty ? HomeGridPalette.subtitle : HomeGridPalette.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppPaddings.padding8)
        if viewModel.isEditable {
            Button {
                viewModel.setDatePickerVisibility(true)
            } label: {
                label
            }
            .buttonStyle(.plain)
        } else {
            label
        }
    }

    private var coverButton: some View {
        let photo = coverPhoto
            .frame(width: AppDimensions.newItemImageSize, height: AppDimensions.newItemImageSize)
            .background(HomeGridPalette.coverPlaceholder)
            .clipShape(.circle)
        return Group {
            if viewModel.isEditable {
                Button {
                    showPhotoSourceDialog = true
                } label: {
                    photo
                }
                .buttonStyle(.plain)
            } else {
                photo
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.newWishListImage)
        .accessibilityLabel(L10n.chooseWishlistPhoto)
    }
    
    @ViewBuilder
    private var coverPhoto: some View {
        if let coverImage = viewModel.coverImage {
            Image(uiImage: coverImage)
                .resizable()
                .scaledToFill()
        } else if let coverImageURL = viewModel.coverImageURL {
            AsyncImage(url: coverImageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    coverPlaceholder
                }
            }
        } else {
            coverPlaceholder
        }
    }

    private var coverPlaceholder: some View {
        Image(asset: Asset.blankImage)
            .resizable()
            .renderingMode(.template)
            .scaledToFill()
            .foregroundColor(HomeGridPalette.accent)
    }
}

#Preview {
    let stateMachine = NewWishListStateMachine(
        backIcon: IconState(icon: SFSymbolsIcon(symbol: .back)),
        dropDownIcon: IconState(icon: SFSymbolsIcon(symbol: .down)),
        saveIcon: IconState(icon: SFSymbolsIcon(symbol: .checkmark)),
        plusIcon: IconState(icon: SFSymbolsIcon(symbol: .plusCircle), isResizable: true)
    )
    let viewStateFactory = NewWishListStateFactory()
    
    return NewWishlistView(viewModel: NewWishListViewModel(stateMachine: stateMachine, stateFactory: viewStateFactory))
}
