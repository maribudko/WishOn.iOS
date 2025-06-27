//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import Foundation
import XCTest
@testable import WOCore

final class URLValidatorTests: XCTestCase {
    var validator: UrlValidator!
    
    override func setUp() {
        super.setUp()
        validator = UrlValidator()
    }
    
    func testValidHttpURL() {
        XCTAssertTrue(validator.validate("http://www.google.com"))
    }
    
    func testValidHttpsUrl() {
        XCTAssertTrue(validator.validate("https://google.com"))
    }
    
    func testInvalidScheme() {
        XCTAssertFalse(validator.validate("ftp://example.com"))
    }
    
    func testMalformedUrl() {
        XCTAssertFalse(validator.validate("just text"))
    }
}
