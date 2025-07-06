//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import Testing
@testable import WOCore

struct URLValidatorTests {
    let validator = UrlValidator()
    
    @Test("Valid http URL returns true")
    func testValidHttpURL() {
        #expect(validator.validate("http://www.google.com") == true)
    }
    
    @Test("Valid https URL returns true")
    func testValidHttpsUrl() {
        #expect(validator.validate("https://google.com") == true)
    }
    
    @Test("Invalid scheme returns false")
    func testInvalidScheme() {
        #expect(validator.validate("ftp://example.com") == false)
    }
    
    @Test("Malformed URL returns false")
    func testMalformedUrl() {
        #expect(validator.validate("just text") == false)
    }
}
