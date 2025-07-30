//
//  LoginViewTests.swift
//  PreviewHostUITests
//
//  Created by Mari Budko on 28.07.2025.
//

import XCTest
import WOCore

final class LoginViewTests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append(Constants.loginScreen)
        app.launch()
    }
    
    func testLoginButtonsAreVisible() {
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.googleAuthButton].exists)
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.appleAuthButton].exists)
    }
    
    func testGoogleAuthButtonExists() {
        let button = app.buttons[AccessibilityIdentifiers.googleAuthButton]
        XCTAssertTrue(button.exists, "Google auth button should exist.")
    }
    
    func testAppleAuthButtonExists() {
        let button = app.buttons[AccessibilityIdentifiers.appleAuthButton]
        XCTAssertTrue(button.exists, "Apple auth button should exist.")
    }
}
