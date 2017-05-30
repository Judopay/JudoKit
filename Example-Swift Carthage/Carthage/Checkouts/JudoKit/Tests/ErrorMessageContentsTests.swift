//
//  ErrorMessageContentsTests.swift
//  JudoKitObjC
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

class ErrorMessageContentsTests: JudoTestCase {
    
    let UnableToProcessRequestErrorDesc = "Sorry, we're currently unable to process this request."
    let UnableToVaildteErrorDesc = "Sorry, we've been unable to validate your card. Please check your details and try again or use an alternative card."
    let UnableToAcceptErrorDesc = "Sorry, but we are currently unable to accept payments to this account. Please contact customer services."
    
    let UnableToProcessRequestErrorTitle = "Unable to process"
    let UnableToValidateErrorTitle = "Unable to validate"
    let UnableToAcceptErrorTitle = "Unable to accept"
    
    let ParameterError = "A parameter entered into the dictionary (request body to Judo API) is faulty"
    let ResponseParseError = "An error with the response from the backend API"
    let LuhnValidationError = "Luhn validation checks failed"
    let JudoIDInvalidError = "Luhn validation on JudoID failed"
    let SerializationError = "The information returned by the backend API does not return proper JSON data"
    let RequestError = "The request failed when trying to communicate to the API"
    let TokenSecretError = "Token and secret information is not provided"
    let CardAndTokenError = "Both a card and a token were provided in the transaction request"
    let AmountMissingError = "An amount object was not provided in the transaction request"
    let CardOrTokenMissingError = "The card object and the token object were not provided in the transaction request"
    let PKPaymentMissingError = "The pkPayment object was not provided in the ApplePay transaction"
    let JailbrokenDeviceDisallowedError = "The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session"
    let InvalidOperationError = "It is not possible to create a transaction object with anything else than Payment, PreAuth or RegisterCard"
    let Failed3DSError = "After receiving the 3DS payload, when the payload has faulty data, the WebView fails to load the 3DS Page or the resolution page"
    let UnknownError = "An unknown error that can occur when making API calls"
    let UserDidCancel = "Received when user cancels the payment journey"
    
    fileprivate func testError(_ errorCode : JudoErrorCode, expectedTitle: String?, expectedDesc: String?, expectedDevHint: String?) {
        let actual = JudoError(errorCode)

        XCTAssertEqual(actual.title,expectedTitle)
        XCTAssertEqual(actual.message, expectedDesc)
        XCTAssertEqual(actual.resolution, expectedDevHint)
    }
    
    func testParameterError() {
        testError(.parameterError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.ParameterError)
    }

    func testResponseParseError() {
        testError(.responseParseError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.ResponseParseError)
    }
    
    func testLuhnValidationError() {
        testError(.luhnValidationError, expectedTitle: self.UnableToValidateErrorTitle, expectedDesc: self.UnableToVaildteErrorDesc, expectedDevHint: self.LuhnValidationError)
    }
    
    func testJudoIDInvalidError() {
        testError(.judoIDInvalidError, expectedTitle: self.UnableToAcceptErrorTitle, expectedDesc: self.UnableToAcceptErrorDesc, expectedDevHint: self.JudoIDInvalidError)
    }
    
    func testSerializationError() {
        testError(.serializationError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.SerializationError)
    }
    
    func testRequestError() {
        testError(.requestError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.RequestError)
    }
    
    func testTokenSecretError() {
        testError(.tokenSecretError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.TokenSecretError)
    }
    
    func testCardAndTokenError() {
        testError(.cardAndTokenError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.CardAndTokenError)
    }
    
    func testAmountMissingError() {
        testError(.amountMissingError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.AmountMissingError)
    }
    
    func testCardOrTokenMissingError() {
        testError(.cardOrTokenMissingError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.CardOrTokenMissingError)
    }
    
    func testPKPaymentMissingError() {
        testError(.pkPaymentMissingError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.PKPaymentMissingError)
    }
    
    func testJailbrokenDeviceDisallowedError() {
        testError(.jailbrokenDeviceDisallowedError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.JailbrokenDeviceDisallowedError)
    }
    
    func testInvalidOperationError() {
        testError(.invalidOperationError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.InvalidOperationError)
    }
    
    func testFailed3DSError() {
        testError(.failed3DSError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.Failed3DSError)
    }
    
    func testUnknownError() {
        testError(.unknownError, expectedTitle: self.UnableToProcessRequestErrorTitle, expectedDesc: self.UnableToProcessRequestErrorDesc, expectedDevHint: self.UnknownError)
    }
    
    func testUserDidCancel() {
        testError(.userDidCancel, expectedTitle: nil, expectedDesc: nil, expectedDevHint: self.UserDidCancel)
    }
}
