//
//  JudoKitTests.swift
//  JudoKitTests
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
        let visaCardFormatted = try! visaCardNumber.cardPresentationString([Card.Configuration(.visa, 16)])
        
        // Then
        XCTAssertEqual(visaCardFormatted, "4623 1344 642")
        
        
        // Given
        let masterCardNumber = "5546231344642" // MasterCard
        
        // When
        let masterCardFormatted = try! masterCardNumber.cardPresentationString([Card.Configuration(.masterCard, 16)])
        
        // Then
        XCTAssertEqual(masterCardFormatted, "5546 2313 4464 2")
        
        
        // Given
        let amexCardNumber = "3446231344642" // MasterCard
        
        // When
        let amexCardFormatted = try! amexCardNumber.cardPresentationString([Card.Configuration(.amex, 15)])
        
        // Then
        XCTAssertEqual(amexCardFormatted, "3446 231344 642")
        
        
    }
    
    
}
