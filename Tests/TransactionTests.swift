//
//  TransactionTests.swift
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

class TransactionTests: JudoTestCase {
    
    func testTransaction() {
        // Given I have a Transaction
        let makePayment = try! judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference)
        
        // And I have valid card details
        makePayment.card(validVisaTestCard)
        
        let expectation = self.expectation(description: "testTransactionExpectation")
        
        // When I submit the card details
        try! makePayment.completion({ (response, error) -> () in
            // And the transaction is successful
            // Then I receive a successful response
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.items.first)
            XCTAssertEqual(response?.items.first?.result, TransactionResult.Success)
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testTransactionDeclinedResponse() {
        // Given I have a Transaction
        let makePayment = try! judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference)
        
        // And I have valid card details
        makePayment.card(declinedVisaTestCard)
        
        let expectation = self.expectation(description: "testTransactionDeclinedResponseExpectation")
        
        // When I submit the card details
        try! makePayment.completion({ (response, error) -> () in
            // And the transaction is successful
            // Then I receive a successful response
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.items.first)
            XCTAssertEqual(response?.items.first?.result, TransactionResult.Declined)
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    
    
}
