//
//  MainViewUITests.swift
//  WishOnUITests
//
//  Created by Mari Budko on 31.01.2025.
//

import XCTest
import SwiftUI
@testable import WishOn

final class MainViewUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("isTesting")
        app.launch()
        
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAddNewWishlistButton() throws {
        let addNewWishlistButton = app.buttons[L10n.addNewWishlist]
        
        XCTAssertTrue(addNewWishlistButton.exists)
        
        addNewWishlistButton.tap()
        
        let addWishlistView = app.staticTexts["New wishlist"]
        XCTAssertTrue(addWishlistView.exists)
    }
    
    func testShowToGiveViewButton() throws {
        let showToGiveViewButton = app.buttons[L10n.toGive]
        
        XCTAssertTrue(showToGiveViewButton.exists)
        
        showToGiveViewButton.tap()
        
        let toGiveView = app.staticTexts["To Give"]
        XCTAssertTrue(toGiveView.exists)
    }

    
    func testShowCalendarButton() throws {
        let showCalendarButton = app.buttons[AccessibilityIdentifiers.showCalendarButton]
        
        XCTAssertTrue(showCalendarButton.exists)
        
        showCalendarButton.tap()
    }
    
    func testShowProfileButton() throws {
        let showProfileButton = app.buttons[AccessibilityIdentifiers.showProfileButton]
        
        XCTAssertTrue(showProfileButton.exists)
        
        showProfileButton.tap()
        
    }

    func testEmptyWishlist() throws {
        
        let app = XCUIApplication()
        app.launchArguments.append("--emptyList")
        app.launch()
        
        let emptyView = app.staticTexts[AccessibilityIdentifiers.emptyWishList]
        XCTAssertTrue(emptyView.exists)
    }

    func testNonEmptyWishlist() throws {
        
        let firstWishlistCard = app.images["star.fill"]
        
        firstWishlistCard.tap()
        
        let wishListDetailView = app.staticTexts["WishList Details"]
        
        let exists = wishListDetailView.exists
        XCTAssertTrue(exists)
    }
    
    func testTextDisplay() throws {
        let helloText = app.staticTexts[L10n.helloWisher]
        XCTAssertTrue(helloText.exists)
        
        let aboutWisherText = app.staticTexts[L10n.aboutWisherPromt]
        XCTAssertTrue(aboutWisherText.exists)
    }



}


