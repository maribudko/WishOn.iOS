//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 01.07.2025.
//

import Testing
@testable import WOCore

struct NameValidatorTests {
    var validator = NameValidator()
    
    @Test("Valid name returns true")
    func testValidName() {
        #expect(validator.validate("Marina") == true)
    }
    
    @Test("Empty name returns false")
    func testEmptyName() {
        #expect(validator.validate("") == false)
    }
    
    @Test("Short name returns false")
    func testTooShortName() {
        #expect(validator.validate("M") == false)
    }
}
