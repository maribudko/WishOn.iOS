//
//  File.swift
//  WONewWishListFeature
//
//  Created by Mari Budko on 21.08.2025.
//

import Foundation
import Testing
import UIKit
import WOCore
import WOResources
@testable import WONewWishListFeature

@Test func initialStateIsCorrect() {
    let viewModel = makeViewModel()
    
    #expect(viewModel.viewState.name.text.isEmpty == true)
    #expect(viewModel.viewState.description.text.isEmpty == true)
    #expect(viewModel.viewState.isDatePickerVisible == false)
    #expect(viewModel.wishes.isEmpty == true)
}

@Test func nameChangesUpdatesViewState() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Some Wishlist")
    #expect(viewModel.viewState.name.text == "Some Wishlist")
}

@Test func addWishAppendsItemToTheList() {
    let viewModel = makeViewModel()
    let wish = Wish(
        id: UUID(),
        name: "Book",
        image: "",
        price: 10,
        currency: L10n.uah,
        link: "https://google.com",
        isTaken: false
    )
    
    viewModel.addWish(wish)
    
    #expect(viewModel.wishes.count == 1)
    #expect(viewModel.wishes.first?.name == "Book")
}

@Test func descriptionChangesUpdatesViewState() {
    let viewModel = makeViewModel()
    viewModel.onDescriptionChanged("Some description for Some Wishlist")
    #expect(viewModel.viewState.description.text == "Some description for Some Wishlist")
}

@Test func saveSendsTheListWithItsWishes() async {
    var saved: WishList?
    let viewModel = makeViewModel { wishList, completion in
        saved = wishList
        completion(nil)
    }
    viewModel.onNameChanged("Birthday")
    viewModel.onDescriptionChanged("Gifts")
    viewModel.addWish(sampleWish)
    
    viewModel.onSaveTapped()
    await waitUntil { viewModel.didSave }
    
    #expect(saved?.name == "Birthday")
    #expect(saved?.description == "Gifts")
    #expect(saved?.wishes.count == 1)
    #expect(saved?.wishes.first?.name == "Book")
    #expect(saved?.eventDate == nil)
    #expect(saved?.ownerUid == nil)
    #expect(saved?.image == nil)
    #expect(saved?.avatar == nil)
    #expect(viewModel.didSave == true)
    #expect(viewModel.isSaving == false)
}

@Test func saveStoresTheChosenPhoto() async throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("wishlist-covers-\(UUID().uuidString)", isDirectory: true)
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: directory) }
    
    var saved: WishList?
    let viewModel = makeViewModel { wishList, completion in
        saved = wishList
        completion(nil)
    }
    viewModel.coverImageDirectory = directory
    viewModel.onNameChanged("Birthday")
    viewModel.onCoverImagePicked(samplePhoto)
    
    #expect(viewModel.coverImage != nil)
    #expect(WishListImageStore.fileURL(for: "gift", directory: directory) == nil)
    
    viewModel.onSaveTapped()
    await waitUntil { viewModel.didSave }
    
    let key = try #require(saved?.image)
    let avatar = try #require(saved?.avatar)
    #expect(key.hasPrefix(WishListImageStore.prefix))
    #expect(WishListImageStore.fileURL(for: key, directory: directory) != nil)
    #expect(WishListImageStore.image(fromAvatar: avatar) != nil)
}

@Test func saveRejectsAShortName() {
    var didCallSave = false
    let viewModel = makeViewModel { _, _ in
        didCallSave = true
    }
    viewModel.onNameChanged("A")
    
    viewModel.onSaveTapped()
    
    #expect(didCallSave == false)
    #expect(viewModel.didSave == false)
    #expect(viewModel.viewState.name.errorMessage == L10n.nameCannotBeEmpty)
}

@Test func saveKeepsTheScreenOpenWhenWritingFails() async {
    let viewModel = makeViewModel { _, completion in
        completion(NSError(domain: "WishList", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permission denied"]))
    }
    viewModel.onNameChanged("Birthday")
    
    viewModel.onSaveTapped()
    await waitUntil { viewModel.saveErrorMessage != nil }
    
    #expect(viewModel.didSave == false)
    #expect(viewModel.saveErrorMessage == "Permission denied")
}

private func waitUntil(condition: @escaping () -> Bool) async {
    for _ in 0..<20 where !condition() {
        try? await Task.sleep(nanoseconds: 50_000_000)
    }
}

private let samplePhoto: UIImage = {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
    return renderer.image { context in
        UIColor.red.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 8, height: 8))
    }
}()

private let sampleWish = Wish(
    id: UUID(),
    name: "Book",
    image: "",
    price: 10,
    currency: L10n.uah,
    link: "https://google.com",
    isTaken: false
)

@Test func existingListKeepsItsIdentityWhenSaved() async {
    let id = UUID()
    let created = Date(timeIntervalSince1970: 1_700_000_000)
    let event = Date(timeIntervalSince1970: 1_800_000_000)
    let list = WishList(
        id: id,
        name: "Birthday",
        image: nil,
        eventDate: event,
        wishes: [sampleWish],
        description: "Gifts",
        createdAt: created,
        ownerUid: nil
    )
    var saved: WishList?
    let viewModel = makeViewModel(existing: list) { wishList, completion in
        saved = wishList
        completion(nil)
    }
    
    #expect(viewModel.isEditable == true)
    #expect(viewModel.screenTitle == L10n.wishlistDetails)
    #expect(viewModel.viewState.name.text == "Birthday")
    #expect(viewModel.viewState.description.text == "Gifts")
    #expect(viewModel.viewState.date.isEmpty == false)
    #expect(viewModel.wishes.count == 1)
    
    viewModel.onSaveTapped()
    await waitUntil { viewModel.didSave }
    
    #expect(saved?.id == id)
    #expect(saved?.createdAt == created)
    #expect(saved?.eventDate == event)
    #expect(saved?.name == "Birthday")
}

@Test func anotherPersonsListCannotBeSaved() {
    let list = WishList(
        id: UUID(),
        name: "Birthday",
        image: nil,
        eventDate: nil,
        wishes: [],
        description: nil,
        createdAt: nil,
        ownerUid: "someone-else"
    )
    var didSave = false
    let viewModel = makeViewModel(existing: list, isEditable: true) { _, completion in
        didSave = true
        completion(nil)
    }
    
    viewModel.onSaveTapped()
    
    #expect(viewModel.isEditable == false)
    #expect(didSave == false)
    #expect(viewModel.didSave == false)
}

private func makeViewModel(
    existing: WishList? = nil,
    isEditable: Bool = true,
    onSave: @escaping WishListSaveHandler = { _, completion in completion(nil) }
) -> NewWishListViewModel {
    let stateMachine = NewWishListStateMachine(backIcon: .init(icon: SFSymbolsIcon(symbol: .back)),
                                               dropDownIcon: .init(icon: SFSymbolsIcon(symbol: .down)),
                                               saveIcon: .init(icon: SFSymbolsIcon(symbol: .arrowDown)),
                                               plusIcon: .init(icon: SFSymbolsIcon(symbol: .plusCircle)))
    let stateFactory = NewWishListStateFactory()
    return .init(
        stateMachine: stateMachine,
        stateFactory: stateFactory,
        onSave: onSave,
        existing: existing,
        isEditable: isEditable
    )
}
