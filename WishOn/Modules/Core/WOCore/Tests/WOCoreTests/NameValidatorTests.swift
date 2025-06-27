//
//  File.swift
//  WOCore
//
//  Created by Mari Budko on 27.06.2025.
//

import Foundation
import XCTest
@testable import WOCore

final class NameValidatorTests: XCTestCase {
    var validator: NameValidator!
    
    override func setUp() {
        super.setUp()
        validator = NameValidator()
    }
    
    func testValidName() {
        XCTAssertTrue(validator.validate("Mari"))
    }
    
    func testEmptyName() {
        XCTAssertFalse(validator.validate(""))
    }
    
    func testShortName() {
        XCTAssertFalse(validator.validate("a"))
    }
    
    
}

