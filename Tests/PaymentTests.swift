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
    
    // TODO: Investigate. Test is disabled because the API returns not_Found instead of validation_Passed
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
                    XCTFail("api call did not respond with an error")
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

    func testVCOPayment() {
        do {
            // Given I have a Payment
            let payment = try judo.payment(myJudoId, amount: oneGBPAmount, reference: validReference)

            // When I provide all the required fields
            let callId = "2587385100467218001"
            let encryptedKey = "xJRr2tLAs0n0ztToEMhhG8ELBg3mi7TKLVuqn4pA3FAHhgvR29y1YUhVMdrradFw6gk6+XwF05JEdL6uSWhjH8ZMZoBUsHbglqtg0pnm8tbDQzmaBzztLnOaPbwVYLe8"
            let encryptedPaymentData = "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"
            payment.vcoResult(VCOResult(callId: callId, encryptedKey: encryptedKey, encryptedPaymentData: encryptedPaymentData))

            // Then I should be able to make a payment
            let expectation = self.expectation(description: "payment expectation")

            try payment.completion({ (response, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.items.first)
                XCTAssertEqual(response?.items.first?.result, .success)
                expectation.fulfill()
            })
        } catch {
            XCTFail("exception thrown: \(error)")
        }

        self.waitForExpectations(timeout: 30, handler: nil)
    }
}
