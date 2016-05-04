//
//  PreAuthTests.swift
//  JudoTests
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
import CoreLocation
@testable import JudoKit

class RegisterCardTests: JudoTestCase {
    
    
    func testRegisterCard() {
        do {
            let payment = try judo.registerCard(myJudoId, reference: validReference)
            XCTAssertNotNil(payment)
        } catch {
            XCTFail()
        }
    }
    
    
    func testJudoMakeValidRegisterCard() {
        do {
            // Given I have a Register Card
            let payment = try judo.registerCard(myJudoId, reference: validReference)
            
            // When I provide all the required fields
            payment.card(validVisaTestCard)
            
            // Then I should be able to register a card
            let expectation = self.expectationWithDescription("payment expectation")
            
            try payment.completion({ (response, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.first)
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakePaymentWithoutReference() {
        do {
            // Given I have a Register Card
            // When I do not provide a consumer reference
            let payment = try judo.registerCard(myJudoId, reference: invalidReference)
            
            payment.card(validVisaTestCard)
            
            // Then I should receive an error
            let expectation = self.expectationWithDescription("payment expectation")
            
            try payment.completion({ (response, error) -> () in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                XCTAssertEqual(error!.code, JudoErrorCode.General_Model_Error)
                
                XCTAssertEqual(error?.details?.count, 2)
                
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
}
