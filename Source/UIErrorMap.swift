//
//  UIErrorMap.swift
//  JudoKit
//
//  Created by Ashley Barrett on 18/04/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import Foundation

public class UIErrorMap
{
    private let UnableToProcessRequestErrorDesc = "Sorry, we're currently unable to process this request."
    private let UnableToVaildteErrorDesc = "Sorry, we've been unable to validate your card. Please check your details and try again or use an alternative card."
    private let UnableToAcceptErrorDesc = "Sorry, but we are currently unable to accept payments to this account. Please contact customer services."
    
    private let UnableToProcessRequestErrorTitle = "Unable to process"
    private let UnableToValidateErrorTitle = "Unable to validate"
    private let UnableToAcceptErrorTitle = "Unable to accept"

    private func buildUiErrorDict() -> [JudoErrorCode: UIError]
    {
        var dict: [JudoErrorCode: UIError] = [:]
        
        dict[.ParameterError] = map("A parameter entered into the dictionary (request body to Judo API) is faulty")
        dict[.ResponseParseError] = map("An error with the response from the backend API")
        dict[.LuhnValidationError] = map("Luhn validation checks failed", title: self.UnableToValidateErrorTitle, message: self.UnableToVaildteErrorDesc)
        dict[.JudoIDInvalidError] = map("Luhn validation on JudoID failed", title: self.UnableToAcceptErrorTitle, message: self.UnableToAcceptErrorDesc)
        dict[.SerializationError] = map("The information returned by the backend API does not return proper JSON data")
        dict[.RequestError] = map("The request failed when trying to communicate to the API")
        dict[.TokenSecretError] = map("Token and secret information is not provided")
        dict[.CardAndTokenError] = map("Both a card and a token were provided in the transaction request")
        dict[.AmountMissingError] =  map("An amount object was not provided in the transaction request")
        dict[.CardOrTokenMissingError] = map("The card object and the token object were not provided in the transaction request")
        dict[.PKPaymentMissingError] = map("The pkPayment object was not provided in the ApplePay transaction")
        dict[.JailbrokenDeviceDisallowedError] = map("The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session")
        dict[.InvalidOperationError] = map("It is not possible to create a transaction object with anything else than Payment, PreAuth or RegisterCard")
        dict[.Failed3DSError] = map("After receiving the 3DS payload, when the payload has faulty data, the WebView fails to load the 3DS Page or the resolution page")
        dict[.UnknownError] = map("An unknown error that can occur when making API calls")
        dict[.UserDidCancel] = map("Received when user cancels the payment journey", title: nil, message: nil)
        
        return dict
    }
    
    private func map(hint: String, title: String?, message: String?) -> UIError
    {
        return UIError(tile: title, message: message, hint: hint)
    }
    
    private func map(hint: String) -> UIError
    {
        return map(hint, title: self.UnableToProcessRequestErrorTitle, message: self.UnableToProcessRequestErrorDesc)
    }
    
    public func mapErrorCodeToUIError(code: JudoErrorCode) -> UIError?
    {
        let dict = buildUiErrorDict()

        return dict[code]
    }
}