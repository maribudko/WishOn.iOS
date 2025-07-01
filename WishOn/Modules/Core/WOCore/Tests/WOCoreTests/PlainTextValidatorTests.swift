//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import Testing
@testable import WOCore

struct PlainTextValidatorTests {
    var validator = PlainTextValidator()
    
    @Test("Valid text returns true")
    func testValidText() {
        #expect(validator.validate("some text") == true)
    }
    
    @Test("Short text returns false")
    func testTooShortText() {
        #expect(validator.validate("so") == false)
    }
    
    @Test("Empty text return false")
    func testEmptyText() {
        #expect(validator.validate("") == false)
    }
}
