//
//  NewWishListViewModel.swift
//  WishOn
//
//  Created by Mari Budko on 06.06.2025.
//

import Foundation
import UIKit
import WOCore
import WOResources

public typealias WishListSaveHandler = (WishList, @escaping (Error?) -> Void) -> Void

public final class NewWishListViewModel: ObservableObject {
    @Published private(set) var viewState: NewWishListState
    @Published var wishes: [Wish] = []
    @Published private(set) var isSaving = false
    @Published private(set) var didSave = false
    @Published private(set) var coverImage: UIImage?
    @Published private(set) var coverImageURL: URL?
    @Published var saveErrorMessage: String?
    let isEditable: Bool
    let screenTitle: String
    let listKind: WishListKind
    
    private let stateMachine: NewWishListStateMachine
    private let stateFactory: NewWishListStateFactory
    private let onSave: WishListSaveHandler
    private let listId: UUID
    private let createdAt: Date?
    private var coverImageKey: String?
    private var avatar: String?
    var coverImageDirectory = WishListImageStore.defaultDirectory()
    
    public init(
        stateMachine: NewWishListStateMachine,
        stateFactory: NewWishListStateFactory,
        onSave: @escaping WishListSaveHandler = { _, completion in completion(nil) },
        existing: WishList? = nil,
        isEditable: Bool = true,
        kind: WishListKind = .wishlist
    ) {
        self.stateMachine = stateMachine
        self.stateFactory = stateFactory
        self.onSave = onSave
        self.listId = existing?.id ?? UUID()
        self.createdAt = existing?.createdAt
        let ownerCanEdit = existing.map(Self.canEdit) ?? true
        self.isEditable = isEditable && ownerCanEdit
        self.listKind = existing?.kind ?? kind
        self.screenTitle = Self.screenTitle(for: listKind, isNew: existing == nil)
        if let existing {
            stateMachine.apply(existing)
            wishes = existing.wishes
            coverImageKey = existing.image
            avatar = existing.avatar
            let cover = Self.cover(from: existing)
            coverImage = cover.image
            coverImageURL = cover.url
        }
        self.viewState = stateFactory.make(from: stateMachine.state)
        stateMachine.onStateChanged = { [weak self] in
            self?.updateViewState()
        }
    }
    
    public static func canEdit(_ wishList: WishList) -> Bool {
        guard let ownerUid = wishList.ownerUid else { return true }
        return ownerUid == CurrentUserManager.signedInUid()
    }
    
    public func onNameChanged(_ name: String) {
        stateMachine.setNameText(name)
        updateViewState()
    }
    
    public func onDescriptionChanged(_ description: String) {
        stateMachine.setDescriptionText(description)
        updateViewState()
    }
    
    public func onFieldLostFocus(_ kind: NewWishListStateMachine.TextFieldKind) {
        stateMachine.setDidLoseFocus(kind)
        updateViewState()
    }
    
    public func setDatePickerVisibility(_ isVisible: Bool) {
        stateMachine.setDatePickerVisibility(isVisible)
        updateViewState()
    }
    
    public func clearDate() {
        stateMachine.clearDate()
        updateViewState()
    }
    
    public func addWish(_ wish: Wish) {
        wishes.append(wish)
    }
    
    public func toggleWishCompleted(_ id: UUID) {
        guard listKind == .list, isEditable else { return }
        wishes = wishes.map { wish in
            wish.id == id ? wish.with(isCompleted: !wish.isCompleted) : wish
        }
    }
    
    private static func screenTitle(for kind: WishListKind, isNew: Bool) -> String {
        switch kind {
        case .wishlist:
            return isNew ? L10n.newWishlistLbl : L10n.wishlistDetails
        case .list:
            return L10n.plainListTitle
        }
    }
    
    public func onCoverImagePicked(_ image: UIImage) {
        do {
            let saved = try WishListImageStore.save(image, id: listId, directory: coverImageDirectory)
            coverImageKey = saved.storageKey
            avatar = saved.avatar
            coverImageURL = nil
            if let url = WishListImageStore.fileURL(for: saved.storageKey, directory: coverImageDirectory),
               let saved = UIImage(contentsOfFile: url.path) {
                coverImage = saved
            } else {
                coverImage = image
            }
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }
    
    public func onSaveTapped() {
        guard isEditable, !isSaving else { return }
        guard let wishList = stateMachine.makeWishList(
            id: listId,
            wishes: wishes,
            image: coverImageKey,
            avatar: avatar,
            createdAt: createdAt,
            kind: listKind
        ) else {
            updateViewState()
            return
        }
        
        isSaving = true
        onSave(wishList) { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isSaving = false
                if let error {
                    self.saveErrorMessage = error.localizedDescription
                } else {
                    self.didSave = true
                }
            }
        }
    }
    
    public func clearSaveError() {
        saveErrorMessage = nil
    }
    
    private func updateViewState() {
        viewState = stateFactory.make(from: stateMachine.state)
    }
    
    private static func cover(from wishList: WishList) -> (image: UIImage?, url: URL?) {
        if let image = wishList.image,
           let url = URL(string: image),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            return (nil, url)
        }
        if let key = wishList.image,
           let fileURL = WishListImageStore.fileURL(for: key),
           let image = UIImage(contentsOfFile: fileURL.path) {
            return (image, nil)
        }
        return (WishListImageStore.image(fromAvatar: wishList.avatar), nil)
    }
}
