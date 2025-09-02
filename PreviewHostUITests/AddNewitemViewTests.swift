//
//  AddNewitemViewTests.swift
//  PreviewHostUITests
//
//  Created by Mari Budko on 08.08.2025.
//

import XCTest
import WOCore
import WOResources

final class AddNewitemViewTests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(Constants.addNewItemScreen)
        app.launch()
    }
    
    func testAddNewItemButtonsExists() {
        let closeButton = app.buttons[AccessibilityIdentifiers.addNewItemCloseButton]
        let createButton = app.buttons[AccessibilityIdentifiers.addNewItemCreateButton]
        
        XCTAssertTrue(createButton.exists)
        XCTAssertTrue(closeButton.exists)
    }
  
    func testAddNewItemImageExists() {
        let image = app.images[AccessibilityIdentifiers.addNewItemImage]
        XCTAssertTrue(image.exists)
    }
    
    func testAdNewItemTextFieldsExist() {
        let name = app.textFields[AccessibilityIdentifiers.addNewItemName]
        let link = app.textFields[AccessibilityIdentifiers.addNewItemLink]
        let price = app.textFields[AccessibilityIdentifiers.addNewItemPrice]
        
        XCTAssertTrue(name.exists)
        XCTAssertTrue(link.exists)
        XCTAssertTrue(price.exists)
    }
    
    func testAddNewItemValidInputEnablesButton() {
        let name = app.textFields[AccessibilityIdentifiers.addNewItemName]
        let link = app.textFields[AccessibilityIdentifiers.addNewItemLink]
        let createButton = app.buttons[AccessibilityIdentifiers.addNewItemCreateButton]
        
        name.tap()
        name.typeText("New iPhone")
        
        link.tap()
        link.typeText("https://apple.com")
        
        let price = app.textFields[AccessibilityIdentifiers.addNewItemPrice]
        price.tap()
        price.typeText("1200")
        
        XCTAssertTrue(createButton.isEnabled)
    }
    
    func testAddNewItemInvalidLinkShowsAlert() {
        let name = app.textFields[AccessibilityIdentifiers.addNewItemName]
        let link = app.textFields[AccessibilityIdentifiers.addNewItemLink]
        let createButton = app.buttons[AccessibilityIdentifiers.addNewItemCreateButton]
        
        name.tap()
        name.typeText("Some Name")
        
        link.tap()
        link.typeText("Invalid link")
        
        XCTAssertFalse(createButton.isEnabled)
        
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}
