//
//  AuthenticationTests.swift
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
@testable import JudoKit

class AuthenticationTests: JudoTestCase {
    
    func testCreateJudoTransactionRequest() {
        // Given I have an SDK
        // And I have valid token and secret
        let myToken = token
        let mySecret = secret
        // And I have a luhn valid Judo ID
        let myLuhnValidJudoId = "1000009"
        
        // When I access the API
        let myJudoSession = JudoKit(token: myToken, secret: mySecret)
        
        // Then I can make a request
        let request = try! myJudoSession.transaction(.Payment, judoId: myLuhnValidJudoId, amount: oneGBPAmount, reference: validReference)
        
        XCTAssertNotNil(request)
    }
    
    func testTransactionInvalidTokenSecretNoPaymentMethod() {
        // Given I have an SDK
        // And I have invalid token and secret
        let invalidToken = "a3xQdxP6iHdWg1zy"
        let invalidSecret = "2094c2f5484ba42557917aad2b2c2d294a35dddadb93de3c35d6910e6c461bfb"
        
        let myLuhnValidJudoId = "1000009"
        
        let myInvalidJudoSession = JudoKit(token: invalidToken, secret: invalidSecret)
        
        let expectation = self.expectation(description: "testTransactionInvalidTokenSecretNoPaymentMethod")
        
        do {
            // When I make a transaction
            let payment = try myInvalidJudoSession.payment(myLuhnValidJudoId, amount: Amount(amountString: "1.00", currency: .GBP), reference: Reference(consumerRef: "reference")!)
            
            try payment.completion { (response, error) in
                XCTFail()
                expectation.fulfill()
            }
            
        } catch {
            // Then an error is returned
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
        
    }
    
    func testTransactionInvalidTokenSecretValidCard() {
        // Given I have an SDK
        // And I have invalid token and secret
        let invalidToken = "a3xQdxP6iHdWg1zy"
        let invalidSecret = "2094c2f5484ba42557917aad2b2c2d294a35dddadb93de3c35d6910e6c461bfb"
        
        let myLuhnValidJudoId = "1000009"
        
        let myInvalidJudoSession = JudoKit(token: invalidToken, secret: invalidSecret)
        
        let expectation = self.expectation(description: "testTransactionInvalidTokenSecretValidCard")
        
        do {
            // When I make a transaction
            let payment = try myInvalidJudoSession.payment(myLuhnValidJudoId, amount: Amount(amountString: "1.00", currency: .GBP), reference: Reference(consumerRef: "reference")!).card(validVisaTestCard)
            
            try payment.completion { (response, error) in
                // Then an error is returned
                XCTAssertEqual(error!.code, JudoErrorCode.authenticationFailure)
                expectation.fulfill()
            }
            
        } catch {
            // No exception should have been thrown
            XCTFail()
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    
    func testTransactionInvalidJudoId() {
        // Given I have an SDK
        // And I have invalid token and secret
        let myLuhnValidJudoId = "1000009"
        
        let expectation = self.expectation(description: "testTransactionInvalidTokenSecretValidCard")
        
        do {
            // When I make a transaction
            let payment = try judo.payment(myLuhnValidJudoId, amount: oneGBPAmount, reference: validReference).card(validVisaTestCard)
            
            try payment.completion { (response, error) in
                // Then an error is returned
                XCTAssertEqual(error!.code, JudoErrorCode.accountLocationNotFound)
                expectation.fulfill()
            }
            
        } catch {
            // No exception should have been thrown
            XCTFail()
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    
    func testValidTransaction() {
        // Given I have a Transaction
        // And I have a valid judo ID
        let payment = try! judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference).card(validVisaTestCard)
        
        let expectation = self.expectation(description: "testValidTransaction")
        
        // When I submit any valid transaction with the valid judo ID
        try! payment.completion { (response, error) in
            
            // Then I receive a valid transaction response
            XCTAssertNotNil(response)
            
            XCTAssertNotNil(response?.items.first)
            
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
