//
//  JudoErrors.swift
//  Judo
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

import Foundation

/// judo global error domain specification
public let JudoErrorDomain = "com.judopay.error"


/**
 **JudoError**
 
 The JudoError object holds all the information about errors that occurred within the SDK or at any stage when making a call to the judo API
 */
public struct JudoError: ErrorType {
    
    private let UnableToProcessRequestErrorDesc = "Sorry, we're currently unable to process this request."
    private let UnableToVaildteErrorDesc = "Sorry, we've been unable to validate your card. Please check your details and try again or use an alternative card."
    private let UnableToAcceptErrorDesc = "Sorry, but we are currently unable to accept payments to this account. Please contact customer services."
    
    private let UnableToProcessRequestErrorTitle = "Unable to process"
    private let UnableToValidateErrorTitle = "Unable to validate"
    private let UnableToAcceptErrorTitle = "Unable to accept"
    
    private let ParameterError = "A parameter entered into the dictionary (request body to Judo API) is faulty"
    private let ResponseParseError = "An error with the response from the backend API"
    private let LuhnValidationError = "Luhn validation checks failed"
    private let JudoIDInvalidError = "Luhn validation on JudoID failed"
    private let SerializationError = "The information returned by the backend API does not return proper JSON data"
    private let RequestError = "The request failed when trying to communicate to the API"
    private let TokenSecretError = "Token and secret information is not provided"
    private let CardAndTokenError = "Both a card and a token were provided in the transaction request"
    private let AmountMissingError = "An amount object was not provided in the transaction request"
    private let CardOrTokenMissingError = "The card object and the token object were not provided in the transaction request"
    private let PKPaymentMissingError = "The pkPayment object was not provided in the ApplePay transaction"
    private let JailbrokenDeviceDisallowedError = "The device the code is currently running is jailbroken. Jailbroken devices are not allowed when instantiating a new Judo session"
    private let InvalidOperationError = "It is not possible to create a transaction object with anything else than Payment, PreAuth or RegisterCard"
    private let Failed3DSError = "After receiving the 3DS payload, when the payload has faulty data, the WebView fails to load the 3DS Page or the resolution page"
    private let UnknownError = "An unknown error that can occur when making API calls"
    private let UserDidCancel = "Received when user cancels the payment journey"
    
    /// The judo error code
    public var code: JudoErrorCode
    /// The message of the error
    public var message: String?
    /// The category of the error
    public var category: JudoErrorCategory?
    /// An array of model errors if available
    public var details: [JudoModelError]?
    
    //The suggested display title.
    public var suggestedDisplayTitle : String?
    
    //The suggested display message.
    public var suggestedDisplayMessage : String?
    
    //A (hopefully) helpful hint for the developer consuning this error
    public var developerHint : String?
    
    /// A reference for a NSError version of the receiver
    public var bridgedError: NSError?
    
    /// A payload if available
    public var payload: JSONDictionary?
    
    /// An explanation if available (nil by default)
    public var explanation: String? = nil
    /// A resolution if available (nil by default)
    public var resolution: String? = nil
    
    /// domain (mandatory string for ErrorType subclassing)
    public var domain: String { return JudoErrorDomain }
    /// _domain (mandatory string for ErrorType subclassing)
    public var _domain: String { return JudoErrorDomain }
    /// code (mandatory string for ErrorType subclassing)
    public var _code: Int { return self.code.rawValue }
    
    
    /**
     Initializer
     
     - parameter code:     Error code
     - parameter message:  Optional error message
     - parameter category: Optional error category
     - parameter details:  Optional error details
     
     - returns: a JudoError object
     */
    public init(_ code: JudoErrorCode, _ message: String? = nil, _ category: JudoErrorCategory? = nil, details: [JudoModelError]? = nil) {
        self.code = code
        self.message = message
        self.category = category
        self.details = details
        self.setDisplayAndHintPropertiesBasedOnErrorType()
    }
    
    
    /**
     Initializer
     
     - parameter code: error code
     - parameter dict: error details dictionary
     
     - returns: a JudoError object
     */
    public init(_ code: JudoErrorCode, dict: JSONDictionary) {
        let errorCode = dict["code"]
        let errorMessage = dict["message"]
        let errorCategory = dict["category"]
        let errorExplanation = dict["explanation"]
        let errorResolution = dict["resolution"]
        let detailsArray = dict["details"]
        
        if let errorCode = errorCode as? Int, let judoError = JudoErrorCode(rawValue: errorCode) {
            self.code = judoError
        } else {
            self.code = .Unknown
        }
        
        if let errorMessage = errorMessage as? String {
            self.message = errorMessage
        }
        
        if let errorCategory = errorCategory as? Int, let judoErrorCategory = JudoErrorCategory(rawValue: errorCategory) {
            self.category = judoErrorCategory
        }
        
        if let errorExplanation = errorExplanation as? String {
            self.explanation = errorExplanation
        }
        
        if let errorResolution = errorResolution as? String {
            self.resolution = errorResolution
        }
        
        if let detailsArray = detailsArray as? [JSONDictionary] {
            var modelItemArray = [JudoModelError]()
            detailsArray.forEach { modelItemArray.append(JudoModelError(dict: $0)) }
            self.details = modelItemArray
        }
        
        self.setDisplayAndHintPropertiesBasedOnErrorType()
    }
    
    
    /**
     Initializer
     
     - parameter code:    a JudoErrorCode
     - parameter payload: a payload to pass on with the error
     
     - returns: a JudoError object
     */
    public init(_ code: JudoErrorCode, payload: JSONDictionary) {
        self.code = code
        self.category = nil
        self.message = nil
        self.details = nil
        self.payload = payload
        
        self.setDisplayAndHintPropertiesBasedOnErrorType()
    }
    
    
    /**
     Initializer
     
     - parameter code:         a JudoErrorCode
     - parameter bridgedError: the original NSError
     
     - returns: a JudoError object
     */
    public init(_ code: JudoErrorCode, bridgedError: NSError) {
        self.code = code
        self.category = nil
        self.message = nil
        self.details = nil
        self.bridgedError = bridgedError
        
        self.setDisplayAndHintPropertiesBasedOnErrorType()
    }
    
    
    /**
     Initializer
     
     - parameter code:    a JudoErrorCode
     - parameter message: a message that describes the error
     
     - returns: a JudoError object
     */
    public init(_ code: JudoErrorCode, message: String) {
        self.code = code
        self.category = nil
        self.message = message
        self.details = nil
        
        self.setDisplayAndHintPropertiesBasedOnErrorType()
    }
    
    
    /**
     Bridge an NSError to JudoError
     
     - parameter error: the NSError to bridge from
     
     - returns: a JudoError object
     */
    public static func fromNSError(error: NSError) -> JudoError {
        if let errorCode = error.userInfo["code"] as? Int, judoErrorCode = JudoErrorCode(rawValue: errorCode) {
            return JudoError(judoErrorCode, dict: error.userInfo as! JSONDictionary)
        } else {
            return JudoError(.UnknownError, bridgedError: error)
        }
    }
    
    
    /**
     Get the raw value of the code of the receiver
     
     - returns: judo error code as Integer
     */
    public func rawValue() -> Int {
        return self.code.rawValue
    }
    
    
    /**
     Bridge an object of JudoError type to NSError
     
     - returns: an NSError object
     */
    public func toNSError() -> NSError {
        if let bridgedError = self.bridgedError {
            return bridgedError
        }
        var userInfoDict = [String : AnyObject]()
        if let message = self.message {
            userInfoDict["message"] = message
        }
        if let category = self.category {
            userInfoDict["category"] = category.rawValue
        }
        if let details = self.details {
            userInfoDict["details"] = details as? AnyObject
        }
        if let modelErrors = self.details {
            userInfoDict["modelErrors"] = modelErrors.map({ $0.rawValue }).flatMap({ $0 })
        }
        return NSError(domain: JudoErrorDomain, code: self.code.rawValue, userInfo: userInfoDict)
    }
    
    private mutating func setDisplayAndHintPropertiesBasedOnErrorType()
    {
        guard code != .Unknown else { return }
        
        switch(code)
        {
            case .ParameterError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.ParameterError
            break
            
            case .LuhnValidationError:
                self.suggestedDisplayTitle = self.UnableToValidateErrorTitle
                self.suggestedDisplayMessage = self.UnableToVaildteErrorDesc
                self.developerHint = self.LuhnValidationError
            break
            
            case .JudoIDInvalidError:
                self.suggestedDisplayTitle = self.UnableToAcceptErrorTitle
                self.suggestedDisplayMessage = self.UnableToAcceptErrorDesc
                self.developerHint = self.JudoIDInvalidError
            break
            
            case .ResponseParseError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.ResponseParseError
            break
            
            case .SerializationError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.SerializationError
            break
            
            case .RequestError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.RequestError
            break
            
            case .TokenSecretError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.TokenSecretError
            break
            
            case .CardAndTokenError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.CardAndTokenError
            break
            
            case .AmountMissingError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.AmountMissingError
            break
            
            case .CardOrTokenMissingError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.CardOrTokenMissingError
            break
            
            case .PKPaymentMissingError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.PKPaymentMissingError
            break
            
            case .JailbrokenDeviceDisallowedError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.JailbrokenDeviceDisallowedError
            break
            
            case .InvalidOperationError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.InvalidOperationError
            break
            
            case .Failed3DSError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.Failed3DSError
            break
            
            case .UnknownError:
                self.suggestedDisplayTitle = self.UnableToProcessRequestErrorTitle
                self.suggestedDisplayMessage = self.UnableToProcessRequestErrorDesc
                self.developerHint = self.UnknownError
            break
            
            case .UserDidCancel:
                self.developerHint = self.UserDidCancel
            break
            
            default:
            
            break
        }
    }
}

