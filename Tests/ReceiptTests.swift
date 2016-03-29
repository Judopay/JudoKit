//
//  ReceiptTests.swift
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

class ReceiptTests: JudoTestCase {
    
    func testJudoTransactionReceipt() {
        // Given
        let receiptID = "1491273"
        
        let expectation = self.expectationWithDescription("receipt fetch expectation")
        
        do {
            try judo.receipt(receiptID).completion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            })
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    
    func testJudoTransactionAllReceipts() {
        // Given
        let expectation = self.expectationWithDescription("all receipts fetch expectation")
        
        do {
            try judo.receipt().completion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            })
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    
    func testJudoTransactionReceiptWithPagination() {
        // Given
        let page = Pagination(pageSize: 4, offset: 8, sort: Sort.Ascending)
        let expectation = self.expectationWithDescription("all receipts fetch expectation")
        
        let receipt = try! judo.receipt()
        
        receipt.list(page) { (dict, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            } else {
                XCTAssertEqual(dict!.items.count, 5)
                XCTAssertEqual(dict!.pagination!.offset, 8)
            }
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
    }
    
}
