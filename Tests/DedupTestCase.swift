//
//  DedupTestCase.swift
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

class DedupTestCase: JudoTestCase {

    func testJudoMakeSuccesfulDedupPayment() {
        do {
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference)
            
            payment.card(validVisaTestCard)
            
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                
                do {
                    
                    let payment2 = try self.judo.payment(myJudoId, amount: self.oneGBPAmount, reference: Reference(consumerRef: "consumer reference")!)
                    
                    payment2.card(self.validVisaTestCard)
                    
                    try payment2.completion({ (response, error) in
                        if let error = error {
                            XCTFail("api call failed with error: \(error)")
                        }
                        XCTAssertNotNil(response)
                        XCTAssertNotNil(response?.items.first)
                        expectation.fulfill()
                    })
                } catch {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
                
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    func testJudoMakeDeclinedDedupPayment() {
        do {
            // Given I have a Payment
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference)
            
            // When I provide all the required fields
            payment.card(validVisaTestCard)
            
            // Then I should be able to make a payment
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                
                do {
                    try payment.completion({ (response, error) in
                        XCTFail("api call should have thrown an error")
                    })
                    XCTFail("api call should have thrown an error")
                } catch {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
                
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }

}
