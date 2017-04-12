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
public class Session : NSObject {
    
    /// The endpoint for REST API calls to the judo API
    fileprivate (set) var endpoint = "https://gw1.judopay.com/"
    
    fileprivate let judoBundleId = "com.judo.JudoKit"
    
    
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
    
    public func certPath()->String{
        if sandboxed {
            return "judopay-sandbox.com"
        } else {
            return "gw1.judopay.com"
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
    public func POST(_ path: String, parameters: JSONDictionary, completion: @escaping JudoCompletionBlock) {
        
        // Create request
        let request = self.judoRequest(endpoint + path)
        
        // Rquest method
        request.httpMethod = "POST"
        
        // Safely create request body for the request
        let requestBody: Data?
        
        do {
            requestBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("body serialization failed")
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, JudoError(.serializationError))
            })
            return // BAIL
        }
        
        request.httpBody = requestBody
        
        // Create a data task
        let task = self.task(request as URLRequest, completion: completion)
        
        // Initiate the request
        task.resume()
    }
    
    
    /**
     GET Helper Method for accessing the judo REST API
     
     - Parameter path:       the path
     - Parameter parameters: information that is set in the HTTP Body
     - Parameter completion: completion callblack block with the results
     */
    func GET(_ path: String, parameters: JSONDictionary?, completion: @escaping JudoCompletionBlock) {
        
        // Create request
        let request = self.judoRequest(endpoint + path)
        
        request.httpMethod = "GET"
        
        if let params = parameters {
            let requestBody: Data?
            do {
                requestBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch  {
                print("body serialization failed")
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(.serializationError))
                })
                return
            }
            request.httpBody = requestBody
        }
        
        let task = self.task(request as URLRequest, completion: completion)
        
        // Initiate the request
        task.resume()
    }
    
    
    /**
     PUT Helper Method for accessing the judo REST API - PUT should only be accessed for 3DS transactions to fulfill the transaction
     
     - Parameter path:       the path
     - Parameter parameters: information that is set in the HTTP Body
     - Parameter completion: completion callblack block with the results
     */
    func PUT(_ path: String, parameters: JSONDictionary, completion: @escaping JudoCompletionBlock) {
        // Create request
        let request = self.judoRequest(endpoint + path)
        
        // Request method
        request.httpMethod = "PUT"
        
        // Safely create request body for the request
        let requestBody: Data?
        
        do {
            requestBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("body serialization failed")
            DispatchQueue.main.async(execute: { () -> Void in
                completion(nil, JudoError(.serializationError))
            })
            return // BAIL
        }
        
        request.httpBody = requestBody
        
        // Create a data task
        let task = self.task(request as URLRequest, completion: completion)
        
        // Initiate the request
        task.resume()
    }
    
    // MARK: Helpers
    
    
    /**
     Helper Method to create a JSON HTTP request with authentication
     
     - Parameter url: the url for the request
     
     - Returns: a JSON HTTP request with authorization set
     */
    public func judoRequest(_ url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        // json configuration header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("5.0.0", forHTTPHeaderField: "API-Version")
        
        // Adds the version and lang of the SDK to the header
        request.addValue(self.getUserAgent(), forHTTPHeaderField: "User-Agent")
        
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
    
    private func getUserAgent() -> String {
        let device = UIDevice()
        let mainBundle = Bundle.main
        
        var userAgentParts = [String]()
        
        //Base user agent
        userAgentParts.append("iOS-Swift/\(JudoKitVersion)")
        
        //Model
        userAgentParts.append(device.model)
        
        //Operating system
        userAgentParts.append("\(device.systemName)/\(device.systemVersion)")
        
        //App Name and version
        if let appName = mainBundle.object(forInfoDictionaryKey: "CFBundleName") as? String, let appVersion = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            userAgentParts.append("\(appName.replacingOccurrences(of: " ", with: ""))/\(appVersion)")
        }
        
        //Platform running on (simulator or device)
        if let platformName = mainBundle.object(forInfoDictionaryKey: "DTPlatformName") as? String {
            userAgentParts.append(platformName)
        }
        
        return userAgentParts.joined(separator: " ")
    }
    
    /**
     Helper Method to create a JSON HTTP request with authentication
     
     - Parameter request: the request that is accessed
     - Parameter completion: a block that gets called when the call finishes, it carries two objects that indicate whether the call was a success or a failure
     
     - Returns: a NSURLSessionDataTask that can be used to manipulate the call
     */
    public func task(_ request: URLRequest, completion: @escaping JudoCompletionBlock) -> URLSessionDataTask {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return urlSession.dataTask(with: request, completionHandler: { (data, resp, err) -> Void in
            
            // Error handling
            if data == nil, let error = err {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError.fromNSError(error as NSError))
                })
                return // BAIL
            }
            
            // Unwrap response data
            guard let upData = data else {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(.requestError))
                })
                return // BAIL
            }
            
            // Serialize JSON Dictionary
            let json: JSONDictionary?
            do {
                json = try JSONSerialization.jsonObject(with: upData, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary
            } catch {
                print(error)
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(.serializationError))
                })
                return // BAIL
            }
            
            // Unwrap optional dictionary
            guard let upJSON = json else {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(.serializationError))
                })
                return
            }
            
            // If an error occur
            if let errorCode = upJSON["code"] as? Int, let judoErrorCode = JudoErrorCode(rawValue: errorCode) {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(judoErrorCode, dict: upJSON))
                })
                return // BAIL
            }
            
            // Check if 3DS was requested
            if upJSON["acsUrl"] != nil && upJSON["paReq"] != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(.threeDSAuthRequest, payload: upJSON))
                })
                return // BAIL
            }
            
            // Create pagination object
            var paginationResponse: Pagination?
            
            if let offset = upJSON["offset"] as? NSNumber, let pageSize = upJSON["pageSize"] as? NSNumber, let sort = upJSON["sort"] as? String {
                paginationResponse = Pagination(pageSize: pageSize.intValue, offset: offset.intValue, sort: Sort(rawValue: sort)!)
            }
            
            var result = Response(paginationResponse)
            
            
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
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(nil, JudoError(.responseParseError))
                })
                return // BAIL
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
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
    func progressionParameters(_ receiptId: String, amount: Amount, paymentReference: String, deviceSignal: JSONDictionary?) -> JSONDictionary {
        var dictionary = ["receiptId":receiptId, "amount": amount.amount, "yourPaymentReference": paymentReference] as [String : Any]
        if let deviceSignal = deviceSignal {
            dictionary["clientDetails"] = deviceSignal
        }
        return dictionary as JSONDictionary
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

extension Session: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString?)))
        SecTrustSetPolicies(serverTrust!, policies);
        
        // Evaluate server certificate
        var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
        let status = SecTrustEvaluate(serverTrust!, &result)
        var isServerTrusted:Bool = false
        if status == errSecSuccess {
            let unspecified = SecTrustResultType(rawValue: SecTrustResultType.unspecified.rawValue)
            let proceed = SecTrustResultType(rawValue: SecTrustResultType.proceed.rawValue)
            
            isServerTrusted = result == unspecified || result == proceed
        }
        
        // Get local and remote cert data
        let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
        let bundle = Bundle.init(identifier: judoBundleId)
        let pathToCert = bundle?.path(forResource: certPath(), ofType: "cer")
        let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
        
        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificate as Data)) {
            let credential:URLCredential = URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
}

