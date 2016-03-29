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
public class JudoError: NSObject, ErrorType {
    
    /// The judo error code
    public var code: JudoErrorCode
    /// The message of the error
    public var message: String?
    /// The category of the error
    public var category: JudoErrorCategory?
    /// An array of model errors if available
    public var details: [JudoModelError]?
    
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
        super.init()
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
        
        super.init()
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
        super.init()
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
        super.init()
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
        super.init()
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
            userInfoDict["details"] = details
        }
        if let modelErrors = self.details {
            userInfoDict["modelErrors"] = modelErrors.map({ $0.rawValue }).flatMap({ $0 })
        }
        return NSError(domain: JudoErrorDomain, code: self.code.rawValue, userInfo: userInfoDict)
    }
    
}

