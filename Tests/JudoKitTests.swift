//
//  JudoKitTests.swift
//  JudoKitTests
//
//  Created by Hamon Riazy on 12/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
@testable import JudoKit

class JudoKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardNumberFormat() {
        // Given
        let visaCardNumber = "46231344642" // VISA
        
        // When
        let visaCardFormatted = try! visaCardNumber.cardPresentationString(nil)
        
        // Then
        XCTAssertEqual(visaCardFormatted, "4623 1344 642")
        
        
        // Given
        let masterCardNumber = "5546231344642" // MasterCard
        
        // When
        let masterCardFormatted = try! masterCardNumber.cardPresentationString(nil)
        
        // Then
        XCTAssertEqual(masterCardFormatted, "5546 2313 4464 2")
        
        
        // Given
        let amexCardNumber = "3446231344642" // MasterCard
        
        // When
        let amexCardFormatted = try! amexCardNumber.cardPresentationString([Card.Configuration(.AMEX, 15)])
        
        // Then
        XCTAssertEqual(amexCardFormatted, "3446 231344 642")
        
        
    }
    
    
}
