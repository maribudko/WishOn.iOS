//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import XCTest
@testable import WOCore

final class PriceValidatorTests: XCTestCase {
    var validator: PriceValidator!
    
    override func setUp() {
        super.setUp()
        validator = PriceValidator()
    }
    
    func testValidDecimalWithDot() {
        XCTAssertTrue(validator.validate("10.99"))
    }

    func testValidDecimalWithComma() {
        XCTAssertTrue(validator.validate("10,99"))
    }

    func testZeroPrice() {
        XCTAssertFalse(validator.validate("0"))
    }

    func testNegativePrice() {
        XCTAssertFalse(validator.validate("-5.0"))
    }

    func testInvalidText() {
        XCTAssertFalse(validator.validate("abc"))
    }
}
