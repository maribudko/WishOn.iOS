//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import Foundation
import XCTest
@testable import WOCore

final class PlainTextValidatorTests: XCTestCase {
    var validator: PlainTextValidator!
    
    override func setUp() {
        super.setUp()
        validator = PlainTextValidator()
    }
    
    func testValidText() {
        XCTAssertTrue(validator.validate("some text"))
    }
    
    func testShortText() {
        XCTAssertFalse(validator.validate("hi"))
    }
    
    func testEmptyText() {
        XCTAssertFalse(validator.validate(""))
    }
    
}
