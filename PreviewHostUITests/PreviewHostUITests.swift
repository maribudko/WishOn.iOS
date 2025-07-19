//
//  PreviewHostUITests.swift
//  PreviewHostUITests
//
//  Created by Mari Budko on 18.07.2025.
//

import XCTest

final class PreviewHostUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testEmptyWishListVisible() throws {
        let emptyLabel = app.staticTexts["emptyWishList"]
        XCTAssertTrue(emptyLabel.waitForExistence(timeout: 2.0), "Empty list should be shown.")
    }
    
    func testCalendarButtonExists() throws {
        let button = app.buttons["showCalendarButton"]
        XCTAssertTrue(button.exists, "Calendar button should exist.")
    }
    
    func testProfileButtonExists() throws {
        let button = app.buttons["showProfileButton"]
        XCTAssertTrue(button.exists, "Profile button should exist.")
    }
    
    func testAddButtonExists() throws {
        let button = app.buttons["addWishlistButton"]
        XCTAssertTrue(button.exists, "Add button should exist.")
    }
    
    func testToGiveButtonExists() throws {
        let button = app.buttons["showToGiveViewButton"]
        XCTAssertTrue(button.exists, "ToGive button should exist.")
    }
    
    func testAddWishListButtonNavigatesToWishListView() {
        let button = app.buttons["addWishlistButton"]
        XCTAssertTrue(button.exists, "Add button should exist.")
        
        button.tap()
        
        let newWishListTextField = app.textFields["newWishListView"]
        let exists = newWishListTextField.waitForExistence(timeout: 2.0)
        
        XCTAssertTrue(exists, "Should navigate to NewWishList screen.")
    }
    
    func testToGiveButtonNavigatesToToGiveView() {
        let button = app.buttons["showToGiveViewButton"]
        XCTAssertTrue(button.exists, "ToGive button should exist.")
        
        button.tap()

        let toGiveLabel = app.staticTexts["toGiveLabel"]
        let exists = toGiveLabel.waitForExistence(timeout: 2.0)
        
        XCTAssertTrue(exists, "Should navigate to ToGive screen.")
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}
