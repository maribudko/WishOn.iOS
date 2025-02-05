//
//  WishOnUITests.swift
//  WishOnUITests
//
//  Created by Mari Budko on 26.11.2024.
//

import XCTest

final class NewWishListViewUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    func testUIElements() {
        let createWishlistButton = app.buttons[L10n.addNewWishlist]
        XCTAssertTrue(createWishlistButton.exists)
        
        createWishlistButton.tap()
        
        XCTAssertTrue(app.images["filofax"].exists)
        XCTAssertTrue(app.textFields["Name"].exists)
        XCTAssertTrue(app.textFields["Description"].exists)
        XCTAssertTrue(app.textFields["Date"].exists)
        // XCTAssertTrue(app.buttons["plusCircleFillButton"].exists)
    }
    
    func testTextFieldsInput() {
        
        let createWishlistButton = app.buttons[L10n.addNewWishlist]
        if createWishlistButton.exists {
            createWishlistButton.tap()
        }
            
        XCTAssertTrue(app.staticTexts["New wishlist"].exists)
            
        let nameField = app.textFields["Name"]
        let descriptionField = app.textFields["Description"]
            
            
        nameField.tap()
        nameField.typeText("My wishlist")
            
        descriptionField.tap()
        descriptionField.typeText("My description")
            
        XCTAssertEqual(nameField.value as? String, "My wishlist")
        XCTAssertEqual(descriptionField.value as? String, "My description")
        
    }
}
