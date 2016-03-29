//
//  Session.swift
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
import CoreLocation
import PassKit

/// The valid lengths of any judo Id
internal let kJudoIDLenght = (6...10)

/// Typealias for any Key value storage type objects
public typealias JSONDictionary = [String : AnyObject]

public typealias JudoCompletionBlock = (Response?, JudoError?) -> ()

/// The Session struct is a wrapper for the REST API calls
public class Session {
    
    /// The endpoint for REST API calls to the judo API
    private (set) var endpoint = "https://gw1.judopay.com/"
    
    
    /// identifying whether developers are using their own UI or the Judo Out of the box UI
    public var uiClientMode = false
    
    
    /// Set the app to sandboxed mode
    public var sandboxed: Bool = false {
        didSet {
            if sandboxed {
                endpoint = "https://gw1.judopay-sandbox.com/"
            } else {
                endpoint = "https://gw1.judopay.com/"
            }
        }
    }
    
    
    /// Token and secret are saved in the authorizationHeader for authentication of REST API calls
    var authorizationHeader: String?
    
    
    /**
    POST Helper Method for accessing the judo REST API
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    public func POST(path: String, parameters: JSONDictionary, completion: JudoCompletionBlock) {
        
        // Create request
        let request = self.judoRequest(endpoint + path)
        
        // Rquest method
        request.HTTPMethod = "POST"
        
        // Safely create request body for the request
        let requestBody: NSData?
        
        do {
            requestBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("body serialization failed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(nil, JudoError(.SerializationError))
            })
            return // BAIL
        }
        
        request.HTTPBody = requestBody
        
        // Create a data task
        let task = self.task(request, completion: completion)
        
        // Initiate the request
        task.resume()
    }
    
    
    /**
    GET Helper Method for accessing the judo REST API
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    func GET(path: String, parameters: JSONDictionary?, completion: JudoCompletionBlock) {
        
        // Create request
        let request = self.judoRequest(endpoint + path)
        
        request.HTTPMethod = "GET"
        
        if let params = parameters {
            let requestBody: NSData?
            do {
                requestBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            } catch  {
                print("body serialization failed")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(.SerializationError))
                })
                return
            }
            request.HTTPBody = requestBody
        }
        
        let task = self.task(request, completion: completion)
        
        // Initiate the request
        task.resume()
    }
    
    
    /**
    PUT Helper Method for accessing the judo REST API - PUT should only be accessed for 3DS transactions to fulfill the transaction
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    func PUT(path: String, parameters: JSONDictionary, completion: JudoCompletionBlock) {
        // Create request
        let request = self.judoRequest(endpoint + path)
        
        // Request method
        request.HTTPMethod = "PUT"
        
        // Safely create request body for the request
        let requestBody: NSData?
        
        do {
            requestBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("body serialization failed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(nil, JudoError(.SerializationError))
            })
            return // BAIL
        }
        
        request.HTTPBody = requestBody
        
        // Create a data task
        let task = self.task(request, completion: completion)
        
        // Initiate the request
        task.resume()
    }
    
    // MARK: Helpers
    
    
    /**
    Helper Method to create a JSON HTTP request with authentication
    
    - Parameter url: the url for the request
    
    - Returns: a JSON HTTP request with authorization set
    */
    public func judoRequest(url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        // json configuration header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("5.0.0", forHTTPHeaderField: "API-Version")
        
        // Adds the version and lang of the SDK to the header
        var bundle = NSBundle(identifier: "com.judo.JudoKit")
        if bundle == nil {
            bundle = NSBundle(forClass: self.dynamicType)
        }
        let version = bundle!.infoDictionary?["CFBundleShortVersionString"] ?? "Unknown"
        request.addValue("iOS-Version/\(version) lang/(Swift)", forHTTPHeaderField: "User-Agent")
        
        request.addValue("iOSSwift-\(version)", forHTTPHeaderField: "Sdk-Version")
        
        var uiClientModeString = "Judo-SDK"
        
        if uiClientMode {
            uiClientModeString = "Custom-UI"
        }
        
        request.addValue(uiClientModeString, forHTTPHeaderField: "UI-Client-Mode")
        
        // Check if token and secret have been set
        guard let authHeader = self.authorizationHeader else {
            print("token and secret not set")
            assertionFailure("token and secret not set")
            return request
        }
        
        // Set auth header
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    /**
    Helper Method to create a JSON HTTP request with authentication
    
    - Parameter request: the request that is accessed
    - Parameter completion: a block that gets called when the call finishes, it carries two objects that indicate whether the call was a success or a failure
    
    - Returns: a NSURLSessionDataTask that can be used to manipulate the call
    */
    public func task(request: NSURLRequest, completion: JudoCompletionBlock) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, resp, err) -> Void in
            
            // Error handling
            if data == nil, let error = err {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError.fromNSError(error))
                })
                return // BAIL
            }
            
            // Unwrap response data
            guard let upData = data else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(.RequestError))
                })
                return // BAIL
            }
            
            // Serialize JSON Dictionary
            let json: JSONDictionary?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(upData, options: NSJSONReadingOptions.AllowFragments) as? JSONDictionary
            } catch {
                print(error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(.SerializationError))
                })
                return // BAIL
            }
            
            // Unwrap optional dictionary
            guard let upJSON = json else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(.SerializationError))
                })
                return
            }
            
            // If an error occur
            if let errorCode = upJSON["code"] as? Int, let judoErrorCode = JudoErrorCode(rawValue: errorCode) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(judoErrorCode, dict: upJSON))
                })
                return // BAIL
            }
            
            // Check if 3DS was requested
            if upJSON["acsUrl"] != nil && upJSON["paReq"] != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(.ThreeDSAuthRequest, payload: upJSON))
                })
                return // BAIL
            }
            
            // Create pagination object
            var paginationResponse: Pagination?
            
            if let offset = upJSON["offset"] as? NSNumber, let pageSize = upJSON["pageSize"] as? NSNumber, let sort = upJSON["sort"] as? String {
                paginationResponse = Pagination(pageSize: pageSize.integerValue, offset: offset.integerValue, sort: Sort(rawValue: sort)!)
            }
            
            let result = Response(paginationResponse)
            
            
            do {
                if let results = upJSON["results"] as? Array<JSONDictionary> {
                    for item in results {
                        let transaction = try TransactionData(item)
                        result.append(transaction)
                    }
                } else {
                    let transaction = try TransactionData(upJSON)
                    result.append(transaction)
                }
            } catch {
                print(error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError(.ResponseParseError))
                })
                return // BAIL
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(result, nil)
            })
            
        })
        
    }
    
    
    /**
    Helper method to create a dictionary of all the parameters necessary for a refund or a collection
    
    - parameter receiptId:        The receipt ID for a refund or a collection
    - parameter amount:           The amount to process
    - parameter paymentReference: the payment reference
    
    - returns: a Dictionary containing all the information to submit for a refund or a collection
    */
    func progressionParameters(receiptId: String, amount: Amount, paymentReference: String) -> JSONDictionary {
        return ["receiptId":receiptId, "amount": amount.amount, "yourPaymentReference": paymentReference]
    }
    
    
}


// MARK: Pagination

/**
 **Pagination**

 Struct to save state of a paginated response
*/
public struct Pagination {
    var pageSize: Int = 10
    var offset: Int = 0
    var sort: Sort = .Descending
}


/**
 Enum to identify sorting direction
 
 - Descending: Descended Sorting
 - Ascending:  Ascended Sorting
 */
public enum Sort: String {
    /// Descended Sorting
    case Descending = "time-descending"
    /// Ascended Sorting
    case Ascending = "time-ascending"
}

