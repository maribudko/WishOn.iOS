//
//  File.swift
//  WOAddNewItemFeature
//
//  Created by Mari Budko on 21.08.2025.
//

import Foundation
import Testing
import UIKit
import WOCore
import WOResources
@testable import WOAddNewItemFeature

@Test func addButtonInitiallyDisabled() {
    let viewModel = makeViewModel()
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func addButtonEnablesOnValidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("120.0")
    
    #expect(viewModel.isAddButtonEnabled == true)
}

@Test func addButtonDisablesOnNameInvalidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("A")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("120.0")
    
    viewModel.onFieldLostFocus(.name)
    
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func addButtonDisablesOnUrlInvalidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("@@@@")
    viewModel.onPriceChanged("120.0")
    
    viewModel.onFieldLostFocus(.url)
    
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func addButtonDisablesOnPriceInvalidInput() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("-120.0")
    
    viewModel.onFieldLostFocus(.price)
    
    #expect(viewModel.isAddButtonEnabled == false)
}

@Test func currencyChangeUpdatesViewState() {
    let viewModel = makeViewModel()
    viewModel.onCurrencyChanged(L10n.eur)
    
    #expect(viewModel.viewState.price.currency == L10n.eur)
}

@Test func createAllowsAnItemWithoutLink() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Notebook")
    viewModel.onPriceChanged("40")
    
    viewModel.viewState.button.action()
    
    #expect(viewModel.createdWish?.name == "Notebook")
    #expect(viewModel.createdWish?.link == "")
    #expect(viewModel.showAlert == false)
}

@Test func pickedPhotoStaysWhenTheLinkIsCleared() {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent("wish-item-\(UUID().uuidString)", isDirectory: true)
    let viewModel = makeViewModel()
    viewModel.photoDirectory = directory
    viewModel.onNameChanged("Mug")
    viewModel.onPriceChanged("10")
    viewModel.onPhotoPicked(sampleItemPhoto)
    viewModel.onUrlChanged("")
    
    viewModel.viewState.button.action()
    
    let image = viewModel.createdWish?.image ?? ""
    #expect(image.hasPrefix(WishListImageStore.prefix))
    #expect(WishListImageStore.fileURL(for: image, directory: directory) != nil)
    #expect(viewModel.pickedImage != nil)
    try? FileManager.default.removeItem(at: directory)
}

private let sampleItemPhoto: UIImage = {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8))
    return renderer.image { context in
        UIColor.blue.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 8, height: 8))
    }
}()

@Test func createKeepsWishUntilDialogCloses() {
    let viewModel = makeViewModel()
    viewModel.onNameChanged("Test Name")
    viewModel.onUrlChanged("https://google.com")
    viewModel.onPriceChanged("120.0")
    
    viewModel.viewState.button.action()
    
    #expect(viewModel.createdWish?.name == "Test Name")
    #expect(viewModel.createdWish?.link == "https://google.com")
    #expect(viewModel.createdWish?.price == 120)
    #expect(viewModel.createdWish?.currency == L10n.uah)
    #expect(viewModel.createdWish?.isTaken == false)
    #expect(viewModel.showAlert == false)
    #expect(viewModel.viewState.button.label == L10n.addToList)
}

private func makeViewModel() -> AddNewItemViewModel {
    let stateMachine = AddNewItemStateMachine(crossIcon: .init(icon: SFSymbolsIcon(symbol: .close)))
    let stateFactory = AddNewItemStateFactory()
    return AddNewItemViewModel(stateMachine: stateMachine, stateFactory: stateFactory)
}


