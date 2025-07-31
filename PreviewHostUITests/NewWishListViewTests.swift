//
//  NewWishListViewTests.swift
//  PreviewHostUITests
//
//  Created by Mari Budko on 31.07.2025.
//

import XCTest
import WOCore

final class NewWishListViewTests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(Constants.newWishListScreen)
        app.launch()
        //print(app.debugDescription)
    }
    
    func testNewWishListViewShowsTitle() {
        let newWishListTitleLabel = app.staticTexts[AccessibilityIdentifiers.newWishListLabel]
        XCTAssertTrue(newWishListTitleLabel.waitForExistence(timeout: 2))
    }
    
    func testNewWishListBackButtonExists() {
        let backButton = app.buttons[AccessibilityIdentifiers.newWishListBackButton]
        XCTAssertTrue(backButton.exists)
    }
    
    func testNewWishListSaveButtonExists() {
        let saveButton = app.buttons[AccessibilityIdentifiers.newWishListSaveButton]
        XCTAssertTrue(saveButton.exists)
    }
    
    func testNewWishListImageExists() {
        let image = app.images[AccessibilityIdentifiers.newWishListImage]
        XCTAssertTrue(image.exists)
    }
    
    func testTapAddWishButtonShowsDialog() {
        let addItemButton = app.buttons[AccessibilityIdentifiers.plusCircleFillButton]
        XCTAssertTrue(addItemButton.exists)
        addItemButton.tap()
        
        let addNewItemNameField = app.textFields[AccessibilityIdentifiers.addNewItemName]
        let addNewItemLinkField = app.textFields[AccessibilityIdentifiers.addNewItemLink]
        XCTAssertTrue(addNewItemNameField.waitForExistence(timeout: 2))
        XCTAssertTrue(addNewItemLinkField.waitForExistence(timeout: 2))
    }
    
    func testEnterNameAndDescription() {
        let nameField = app.textFields[AccessibilityIdentifiers.newWishListName]
        let descriptionField = app.textFields[AccessibilityIdentifiers.newWishListDescription]
        
        XCTAssertTrue(nameField.exists)
        XCTAssertTrue(descriptionField.exists)
        
        nameField.tap()
        nameField.typeText("Birthday List")
        
        descriptionField.tap()
        descriptionField.typeText("Gifts for birthday")
        
        XCTAssertEqual(nameField.value as? String, "Birthday List")
        XCTAssertEqual(descriptionField.value as? String, "Gifts for birthday")
    }
    
    func testSaveButtonExists() {
        let saveButton = app.buttons[AccessibilityIdentifiers.newWishListSaveButton]
        XCTAssertTrue(saveButton.exists)
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}
