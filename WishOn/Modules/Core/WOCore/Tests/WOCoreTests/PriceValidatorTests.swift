//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import Testing
@testable import WOCore

struct PriceValidatorTests {
    var validator = PriceValidator()
    
    @Test("Valid decimal with dot returns true")
    func testValidDecimalWithDot() {
        #expect(validator.validate("10.99") == true)
    }
    
    @Test("Valid decimal with comma returns true")
    func testValidDecimalWithComma() {
        #expect(validator.validate("10,99") == true)
    }
    
    @Test("Zero price returns false")
    func testZeroPrice() {
        #expect(validator.validate("0") == false)
    }
    
    @Test("Negative price returns false")
    func testNegativePrice() {
        #expect(validator.validate("-10.00") == false)
    }
    
    @Test("Invalid text input returns false")
    func testInvalidTextInput() {
        #expect(validator.validate("text") == false)
    }
}
