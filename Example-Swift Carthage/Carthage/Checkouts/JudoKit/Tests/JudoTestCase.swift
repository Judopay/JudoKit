//
//  JudoTestCase.swift
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

class JudoTestCase: XCTestCase {
    
    var judo = JudoKit(token: token, secret: secret)
    
    let validVisaTestCard = Card(number: "4976000000003436", expiryDate: "12/20", securityCode: "452")
    let declinedVisaTestCard = Card(number: "4221690000004963", expiryDate: "12/20", securityCode: "125")
    
    let oneGBPAmount = Amount(amountString: "1.00", currency: .GBP)
    let invalidAmount = Amount(amountString: "", currency: .GBP)
    let invalidCurrencyAmount = Amount(amountString: "1.00", currency: Currency(""))
    
    let validReference = Reference(consumerRef: "consumer reference")!
    
    let invalidReference = Reference(consumerRef: "")!
    
    override func setUp() {
        super.setUp()
        judo.sandboxed(true)
    }
    
    override func tearDown() {
        judo.sandboxed(false)
        super.tearDown()
    }
    
}
