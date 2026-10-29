//
//  AddNEwItemViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 15.05.2025.
//

import Foundation
import UIKit
import WOCore
import WOResources

public final class AddNewItemViewModel: ObservableObject {
    @Published private(set) var viewState: AddNewItemState
    @Published var showAlert: Bool = false
    @Published var alertMessage: String?
    @Published var isAddButtonEnabled: Bool = false
    
    private let stateMachine: AddNewItemStateMachine
    private let stateFactory: AddNewItemStateFactory
    
    public var onSuccess: (() -> Void)?
    var createdWish: Wish?
    @Published private(set) var previewImageURL: URL?
    @Published private(set) var pickedImage: UIImage?
    @Published var photoErrorMessage: String?
    var photoDirectory = WishListImageStore.defaultDirectory()

    private let linkPreviewLoader: LinkPreviewLoading
    private let photoId = UUID()
    private var didPickPhoto = false
    private var previewTask: Task<Void, Never>?
    var previewDelayNanoseconds: UInt64 = 700_000_000
    
    public convenience init(stateMachine: AddNewItemStateMachine, stateFactory: AddNewItemStateFactory) {
        self.init(
            stateMachine: stateMachine,
            stateFactory: stateFactory,
            linkPreviewLoader: URLSessionLinkPreviewLoader()
        )
    }

    init(
        stateMachine: AddNewItemStateMachine,
        stateFactory: AddNewItemStateFactory,
        linkPreviewLoader: LinkPreviewLoading
    ) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.linkPreviewLoader = linkPreviewLoader
        self.viewState = stateFactory.make(from: stateMachine.state)
        
        stateMachine.didRequestShowAlert = {[weak self] message in
            self?.alertMessage = message
            self?.showAlert = true
        }
        stateMachine.didCreateWish = { [weak self] wish in
            self?.createdWish = wish
            self?.onSuccess?()
        }
    }
    
    //MARK: - User Actions
    public func onNameChanged(_ name: String) {
        stateMachine.setNameText(name)
        updateViewState()
    }
    
    public func onUrlChanged(_ url: String) {
        stateMachine.setUrlText(url)
        updateViewState()
        scheduleLinkPreview(for: url)
    }
    
    public func onPriceChanged(_ price: String) {
        stateMachine.setPriceText(price)
        updateViewState()
    }
    
    public func onCurrencyChanged(_ currency: String) {
        stateMachine.setCurrencyText(currency)
        updateViewState()
    }
    
    public func onFieldLostFocus(_ kind: AddNewItemStateMachine.TextFieldKind) {
        stateMachine.setDidLoseFocus(kind)
        updateViewState()
    }
    
    public func onPhotoPicked(_ image: UIImage) {
        do {
            let saved = try WishListImageStore.save(image, id: photoId, directory: photoDirectory)
            didPickPhoto = true
            pickedImage = WishListImageStore.image(fromAvatar: saved.avatar) ?? image
            stateMachine.setImageURL(saved.storageKey)
        } catch {
            photoErrorMessage = error.localizedDescription
        }
    }
    
    public func onAddTapped() {
        stateMachine.didTapAddButton()
        updateViewState()
    }
    
    private func updateViewState() {
        viewState = stateFactory.make(from: stateMachine.state)
        isAddButtonEnabled = stateMachine.state.addButton.isEnabled
    }

    private func scheduleLinkPreview(for rawURL: String) {
        previewTask?.cancel()
        let trimmed = rawURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed), UrlValidator().validate(trimmed) else {
            previewImageURL = nil
            if !didPickPhoto {
                stateMachine.setImageURL("")
            }
            return
        }

        previewTask = Task { [weak self] in
            let delay = self?.previewDelayNanoseconds ?? 0
            if delay > 0 {
                try? await Task.sleep(nanoseconds: delay)
            }
            guard !Task.isCancelled, let self else { return }
            let preview = await self.linkPreviewLoader.load(from: url)
            guard !Task.isCancelled, let preview else { return }
            await MainActor.run {
                self.apply(preview)
            }
        }
    }

    private func apply(_ preview: LinkPreview) {
        if let title = preview.title {
            stateMachine.setNameText(title)
        }
        if let price = preview.price {
            stateMachine.setPriceText(price)
        }
        if let currency = preview.currency {
            stateMachine.setCurrencyText(currency)
        }
        if !didPickPhoto {
            previewImageURL = preview.imageURL
            stateMachine.setImageURL(preview.imageURL?.absoluteString ?? "")
        }
        updateViewState()
    }
}
