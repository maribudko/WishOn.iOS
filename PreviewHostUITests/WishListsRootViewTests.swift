//
//  PreviewHostUITests.swift
//  PreviewHostUITests
//
//  Created by Mari Budko on 18.07.2025.
//

import XCTest
import WOCore

final class WishListsRootViewTests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(Constants.wishListRootScreen)
        app.launch()
    }
    
    func testEmptyWishListVisible() throws {
        let emptyLabel = app.staticTexts[AccessibilityIdentifiers.emptyWishList]
        XCTAssertTrue(emptyLabel.waitForExistence(timeout: 2.0), "Empty list should be shown.")
    }
    
    func testCalendarButtonExists() throws {
        let button = app.buttons[AccessibilityIdentifiers.showCalendarButton]
        XCTAssertTrue(button.exists, "Calendar button should exist.")
    }
    
    func testProfileButtonExists() throws {
        let button = app.buttons[AccessibilityIdentifiers.showProfileButton]
        XCTAssertTrue(button.exists, "Profile button should exist.")
    }
    
    func testAddButtonExists() throws {
        let button = app.buttons[AccessibilityIdentifiers.addWishlistButton]
        XCTAssertTrue(button.exists, "Add button should exist.")
    }
    
    func testToGiveButtonExists() throws {
        let button = app.buttons[AccessibilityIdentifiers.showToGiveViewButton]
        XCTAssertTrue(button.exists, "ToGive button should exist.")
    }
    
    func testAddWishListButtonNavigatesToWishListView() {
        let button = app.buttons[AccessibilityIdentifiers.addWishlistButton]
        XCTAssertTrue(button.exists, "Add button should exist.")
        
        button.tap()
        
        let newWishListTextField = app.staticTexts[AccessibilityIdentifiers.newWishListLabel]
        let exists = newWishListTextField.waitForExistence(timeout: 2.0)
        
        debugPrint(app.debugDescription)
        
        XCTAssertTrue(exists, "Should navigate to NewWishList screen.")
    }
    
    func testToGiveButtonNavigatesToToGiveView() {
        let button = app.buttons[AccessibilityIdentifiers.showToGiveViewButton]
        XCTAssertTrue(button.exists, "ToGive button should exist.")
        
        button.tap()

        let toGiveLabel = app.staticTexts[AccessibilityIdentifiers.toGiveLabel]
        let exists = toGiveLabel.waitForExistence(timeout: 2.0)
        
        XCTAssertTrue(exists, "Should navigate to ToGive screen.")
    }
    
    func testNewWishListSaveButtonNavigatesBack() {
        let button = app.buttons[AccessibilityIdentifiers.addWishlistButton]
        XCTAssertTrue(button.exists, "Add button should exist.")
        
        button.tap()
        
        let newWishListTextField = app.staticTexts[AccessibilityIdentifiers.newWishListLabel]
        let exists = newWishListTextField.waitForExistence(timeout: 2.0)
        
        XCTAssertTrue(exists, "Should navigate to NewWishList screen.")
        
        let saveButton = app.buttons[AccessibilityIdentifiers.newWishListSaveButton]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()
        
        let rootViewLabel = app.staticTexts[AccessibilityIdentifiers.wishListsLabel]
        if !rootViewLabel.waitForExistence(timeout: 5) {
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            add(attachment)
            XCTFail("Expected rootViewLabel did not appear")
        }
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}
