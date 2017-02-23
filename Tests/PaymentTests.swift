//
//  PaymentTests.swift
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

class PaymentTests: JudoTestCase {
    
    func testPayment() {
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let amount = Amount(amountString: "30", currency: .GBP)
        do {
            let payment = try judo.payment(myJudoId, amount: amount, reference: references)
            XCTAssertNotNil(payment)
        } catch {
            XCTFail()
        }
    }
    
    func testJudoMakeValidPayment() {
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
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items.first)
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testJudoMakeValidPaymentWithDeviceSignals() {
        do {
            // Given I have a Payment
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference)
            
            // When I provide all the required fields
            payment.card(validVisaTestCard)
            
            // Then I should be able to make a payment
            let expectation = self.expectation(description: "payment expectation")
            
            try judo.completion(payment, block: { (response, error) in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items.first)
                expectation.fulfill()
            })

            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    func testJudoMakePaymentWithoutCurrency() {
        do {
            // Given I have a Payment
            // When I do not provide a currency
            let payment = try judo.payment(myJudoId, amount: invalidCurrencyAmount, reference: validReference)
            
            payment.card(validVisaTestCard)
            
            // Then I should receive an error
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                XCTAssertEqual(error!.code, JudoErrorCode.general_Model_Error)
                //This should be three. This is a known bug with the platform returning an uneeded extra model error about amount formattting.
                XCTAssertEqual(error?.details?.count, 4)
                
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testJudoMakePaymentWithSingaporeDollar() {
        do {
            // Given I have a Payment
            let amount = Amount(amountString: "17.72", currency: .SGD)
            let payment = try judo.payment(myJudoId, amount: amount, reference: validReference)
            
            // When I provide all the required fields
            payment.card(validVisaTestCard)
            
            // Then I should be able to make a payment
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items.first)
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testJudoMakePaymentWithoutReference() {
        do {
            // Given I have a Payment
            // When I do not provide a consumer reference
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: invalidReference)
            
            payment.card(validVisaTestCard)
            
            // Then I should receive an error
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                XCTAssertEqual(error!.code, JudoErrorCode.general_Model_Error)
                
                XCTAssertEqual(error?.details?.count, 2)
                
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func test_PassingAnEmptyPaymentReferenceMustResultInPaymentError() {
        do {
            // Given I have a Payment
            // When I provide an empty payment reference
            let reference = Reference(consumerRef: UUID().uuidString, paymentRef: "")
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: reference)
            
            payment.card(validVisaTestCard)
            
            // Then I should receive an error
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                XCTAssertEqual(error!.code, JudoErrorCode.general_Model_Error)
                
                XCTAssertEqual(error?.details?.count, 2)
                
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func test_PassingAWhiteSpacePaymentReferenceMustResultInPaymentError() {
        do {
            // Given I have a Payment
            // When I provide a whitespace payment reference
            let reference = Reference(consumerRef: UUID().uuidString, paymentRef: " ")
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: reference)
            
            payment.card(validVisaTestCard)
            
            // Then I should receive an error
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                XCTAssertEqual(error!.code, JudoErrorCode.general_Model_Error)
                
                XCTAssertEqual(error?.details?.count, 1)
                
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func test_PassingAPaymentReferenceOver50CharsMustResultInPaymentError() {
        do {
            // Given I have a Payment
            // When I do not provide a consumer reference
            let reference = Reference(consumerRef: UUID().uuidString, paymentRef: String(repeating: "a", count: 51))
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: reference)
            
            payment.card(validVisaTestCard)
            
            // Then I should receive an error
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                XCTAssertNil(response)
                XCTAssertNotNil(error)
                XCTAssertEqual(error!.code, JudoErrorCode.general_Model_Error)
                
                XCTAssertEqual(error?.details?.count, 1)
                
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func test_PassingAUniquePaymentReferenceMustResultInASuccessfulPayment() {
        do {
            // Given I have a Payment
            let reference = Reference(consumerRef: UUID().uuidString, paymentRef: UUID().uuidString)
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: reference)
            
            // When I provide all the required fields
            payment.card(validVisaTestCard)
            
            // Then I should be able to make a payment
            let expectation = self.expectation(description: "payment expectation")
            
            try payment.completion({ (response, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items.first)
                expectation.fulfill()
            })
            
            XCTAssertNotNil(payment)
            XCTAssertEqual(payment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testJudoMakeInvalidJudoIdPayment() throws {
        // Given
        // allowed length for judoId is 6 to 10 chars
        let tooShortJudoID = "33412" // 5 chars not allowed
        let tooLongJudoID = "33224433441" // 11 chars not allowed
        let luhnInvalidJudoID = "33224433"
        var parameterError = false

        // When
        do {
            try _ = judo.payment(tooShortJudoID, amount: oneGBPAmount, reference: validReference) // this should fail
        } catch let error as JudoError {
            // Then
            switch error.code {
            case .judoIDInvalidError, .luhnValidationError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
        
        parameterError = false
        // When
        do {
            try _ = judo.payment(tooLongJudoID, amount: oneGBPAmount, reference: validReference) // this should fail
        } catch let error as JudoError {
            switch error.code {
            case .judoIDInvalidError, .luhnValidationError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
        
        parameterError = false
        // When
        do {
            try _ = judo.payment(luhnInvalidJudoID, amount: oneGBPAmount, reference: validReference) // this should fail
        } catch let error as JudoError {
            switch error.code {
            case .judoIDInvalidError, .luhnValidationError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
    }
    
    
    func testJudoValidation() {
        // Given
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let card = Card(number: "4976000000003436", expiryDate: "12/20", securityCode: "452")
        let amount = Amount(amountString: "30", currency: .GBP)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"

        let expectation = self.expectation(description: "payment expectation")
        
        // When
        do {
            let makePayment = try judo.payment(myJudoId, amount: amount, reference: references).card(card).contact(mobileNumber, emailAddress).validate { dict, error in
                if let error = error {
                    XCTAssertEqual(error.code, JudoErrorCode.validation_Passed)
                } else {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            }
            // Then
            XCTAssertNotNil(makePayment)
            XCTAssertEqual(makePayment.judoId, myJudoId)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        self.waitForExpectations(timeout: 30.0, handler: nil)
        
    }

}
