//
//  JudoKit.swift
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
import PassKit
import DeviceDNA

let JudoKitVersion = "6.2.14"

/**
 A method that checks if the device it is currently running on is jailbroken or not
 
 - returns: true if device is jailbroken
 */
public func isCurrentDeviceJailbroken() -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: "/private/var/lib/apt/")
}


/// Entry point for interacting with judoKit
public class JudoKit {
    
    /// JudoKit local judo session
    public var apiSession = Session()
    
    /// the theme of the current judoKitSession
    public var theme: Theme = Theme()
    
    /// currently active JudoPayViewController if available
    public weak var activeViewController: JudoPayViewController?
    
    /// Fraud Prevention
    fileprivate let deviceDNA: DeviceDNA
    
    private var deviceSignals: JSONDictionary?
    
    /**
     designated initializer of JudoKit
     
     - Parameter token:                  a string object representing the token
     - Parameter secret:                 a string object representing the secret
     - parameter allowJailbrokenDevices: boolean that indicates whether jailbroken devices are restricted
     
     - Throws JailbrokenDeviceDisallowedError: In case jailbroken devices are not allowed, this method will throw an exception if it is run on a jailbroken device
     
     - returns: a new instance of JudoKit
     */
    public init(token: String, secret: String, allowJailbrokenDevices: Bool) throws {
        // Check if device is jailbroken and SDK was set to restrict access
        if !allowJailbrokenDevices && isCurrentDeviceJailbroken() {
            throw JudoError(.jailbrokenDeviceDisallowedError)
        }
        
        let credentials = Credentials(token: token, secret: secret)
        self.deviceDNA = DeviceDNA(credentials: credentials)
        
        self.setToken(token, secret: secret)
    }
    
    
    /**
     convenience initializer of JudoKit
     
     - Parameter token:  a string object representing the token
     - Parameter secret: a string object representing the secret
     
     - returns: a new instance of JudoKit
     */
    public convenience init(token: String, secret: String) {
        try! self.init(token: token, secret: secret, allowJailbrokenDevices: true)
    }
    
    /**
     Completion caller - this method will automatically trigger a Session Call to the judo REST API and execute the request based on the information that were set in the previous methods
     
     - Parameter transaction: the transaction to be completed
     - Parameter block: a completion block that is called when the request finishes
     */
    open func completion(_ transaction: Transaction, block: @escaping JudoCompletionBlock) throws {
        if let device = self.deviceSignals {
            _ = try transaction.deviceSignal(device).completion(block)
        }
        else {
            self.deviceDNA.getDeviceSignals({ (device, error) in
                if let device = device as JSONDictionary? {
                    _ = transaction.deviceSignal(device)
                }
                
                do {
                    _ = try transaction.completion(block)
                }
                catch let error as JudoError{
                    block(nil, error)
                }
                catch {
                    block(nil, JudoError(.unknown))
                }
            })
        }
    }
    
    // MARK: Configuration
    
    /**
     Set the app to sandboxed mode
     
     - parameter enabled: true to set the SDK to sandboxed mode
     */
    public func sandboxed(_ enabled: Bool) {
        self.apiSession.sandboxed = enabled
    }
    
    
    /**
     A mandatory function that sets the token and secret for making payments with judo
     
     - Parameter token:  a string object representing the token
     - Parameter secret: a string object representing the secret
     */
    public func setToken(_ token: String, secret: String) {
        let plainString = token + ":" + secret
        let plainData = plainString.data(using: String.Encoding.isoLatin1)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        self.apiSession.authorizationHeader = "Basic " + base64String
    }
    
    
    /**
     A function to check whether a token and secret has been set
     
     - Returns: a Boolean indicating whether the parameters have been set
     */
    public func didSetTokenAndSecret() -> Bool {
        return self.apiSession.authorizationHeader != nil
    }
    
    // MARK: Transactions
    
    
    /**
    Main payment method
    
    - parameter judoId:       The judoId of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    public func invokePayment(_ judoId: String, amount: Amount, reference: Reference, cardDetails: CardDetails? = nil, completion: @escaping (Response?, JudoError?) -> ()) throws {
        let judoPayViewController = try JudoPayViewController(judoId: judoId, amount: amount, reference: reference, completion: completion, currentSession: self, cardDetails: cardDetails)
        self.initiateAndShow(judoPayViewController)
    }
    
    
    /**
    Make a pre-auth using this method
    
    - parameter judoId:       The judoId of the merchant to receive the pre-auth
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    public func invokePreAuth(_ judoId: String, amount: Amount, reference: Reference, cardDetails: CardDetails? = nil, completion: @escaping (Response?, JudoError?) -> ()) throws {
        let judoPayViewController = try JudoPayViewController(judoId: judoId, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, currentSession: self, cardDetails: cardDetails)
        self.initiateAndShow(judoPayViewController)
    }
    
    
    // MARK: Register Card
    
    
    
    /**
    Initiates a card registration
    
    - parameter judoId:       The judoId of the merchant to receive the pre-auth
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    public func invokeRegisterCard(_ judoId: String, amount: Amount, reference: Reference, cardDetails: CardDetails? = nil, completion: @escaping (Response?, JudoError?) -> ()) throws {
        let judoPayViewController = try JudoPayViewController(judoId: judoId, amount: amount, reference: reference, transactionType: .RegisterCard, completion: completion, currentSession: self, cardDetails: cardDetails)
        self.initiateAndShow(judoPayViewController)
    }
    
    
    // MARK: Token Transactions
    
    /**
    Initiates the token payment process
    
    - parameter judoId:       The judoId of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter cardDetails:  The card details to present in the input fields
    - parameter paymentToken: The consumer and card token to make a token payment with
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    public func invokeTokenPayment(_ judoId: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: @escaping (Response?, JudoError?) -> ()) throws {
        let judoPayViewController = try JudoPayViewController(judoId: judoId, amount: amount, reference: reference, transactionType: .Payment, completion: completion, currentSession: self, cardDetails: cardDetails, paymentToken: paymentToken)
        self.initiateAndShow(judoPayViewController)
    }
    
    
    /**
    Initiates the token pre-auth process
    
    - parameter judoId:       The judoId of the merchant to receive the pre-auth
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter cardDetails:  The card details to present in the input fields
    - parameter paymentToken: The consumer and card token to make a token payment with
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    public func invokeTokenPreAuth(_ judoId: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: @escaping (Response?, JudoError?) -> ()) throws {
        let judoPayViewController = try JudoPayViewController(judoId: judoId, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, currentSession: self, cardDetails: cardDetails, paymentToken: paymentToken)
        self.initiateAndShow(judoPayViewController)
    }
    
    
    /**
     Starting point and a reactive method to create a transaction that is sent to a certain judo ID
     
     - Parameter transactionType: The type of the transaction (payment, pre-auth or registercard)
     - Parameter judoId:          The recipient - has to be between 6 and 10 characters and luhn-valid
     - Parameter amount:          The amount of the Payment
     - Parameter reference:       The reference
     
     - Throws: JudoIDInvalidError    judoId does not match the given length or is not luhn valid
     - Throws: InvalidOperationError if you call this method with .Refund as a transactionType
     
     - Returns: a Payment Object
     */
    public func transaction(_ transactionType: TransactionType, judoId: String, amount: Amount, reference: Reference) throws -> Transaction {
        switch transactionType {
        case .Payment:
            return try self.payment(judoId, amount: amount, reference: reference)
        case .PreAuth:
            return try self.preAuth(judoId, amount: amount, reference: reference)
        case .RegisterCard:
            return try self.registerCard(judoId, reference: reference)
        default:
            throw JudoError(.invalidOperationError)
        }
    }
    
    
    /**
     Starting point and a reactive method to create a payment that is sent to a certain judo ID
     
     - Parameter judoId:    The recipient - has to be between 6 and 10 characters and luhn-valid
     - Parameter amount:    The amount of the Payment
     - Parameter reference: The reference
     
     - Throws: JudoIDInvalidError judoId does not match the given length or is not luhn valid
     
     - Returns: a Payment Object
     */
    public func payment(_ judoId: String, amount: Amount, reference: Reference) throws -> Payment {
        return try Payment(judoId: judoId, amount: amount, reference: reference).apiSession(self.apiSession)
    }
    
    
    /**
     Starting point and a reactive method to create a pre-auth that is sent to a certain judo ID
     
     - Parameter judoId:    The recipient - has to be between 6 and 10 characters and LUHN valid
     - Parameter amount:    The amount of the pre-auth
     - Parameter reference: The reference
     
     - Throws: JudoIDInvalidError judoId does not match the given length or is not LUHN valid
     
     - Returns: pre-auth Object
     */
    public func preAuth(_ judoId: String, amount: Amount, reference: Reference) throws -> PreAuth {
        return try PreAuth(judoId: judoId, amount: amount, reference: reference).apiSession(self.apiSession)
    }
    
    
    /**
     Starting point and a reactive method to create a RegisterCard that is sent to a certain judo ID
     
     - Parameter judoId:    The recipient - has to be between 6 and 10 characters and LUHN valid
     - Parameter amount:    The amount of the RegisterCard
     - Parameter reference: The reference
     
     - Throws: JudoIDInvalidError judoId does not match the given length or is not LUHN valid
     
     - Returns: a RegisterCard Object
     */
    public func registerCard(_ judoId: String, reference: Reference) throws -> RegisterCard {
        return try RegisterCard(judoId: judoId, amount: nil, reference: reference).apiSession(self.apiSession)
    }
    
    
    /**
     Creates a Receipt object which can be used to query for the receipt of a given ID.
     
     The receipt ID has to be LUHN valid, an error will be thrown if the receipt ID does not pass the LUHN check.
     
     If you want to use the receipt function - you need to enable that in the judo Dashboard - Your Apps - Permissions for the given App
     
     - Parameter receiptId: The receipt ID as a String
     
     - Throws: LuhnValidationError if the receiptId does not match
     
     - Returns: a Receipt Object for reactive usage
     */
    public func receipt(_ receiptId: String? = nil) throws -> Receipt {
        return try Receipt(receiptId: receiptId).apiSession(self.apiSession)
    }
    
    
    /**
     Creates a Collection object which can be used to collect a previously pre-authorized transaction
     
     - Parameter receiptId:        The receipt of the previously authorized transaction
     - Parameter amount:           The amount to be transacted
     - Parameter paymentReference: The payment reference string
     
     - Throws: LuhnValidationError judoId does not match the given length or is not LUHN valid
     
     - Returns: a Collection object for reactive usage
     */
    public func collection(_ receiptId: String, amount: Amount) throws -> Collection {
        return try Collection(receiptId: receiptId, amount: amount).apiSession(self.apiSession)
    }
    
    
    /**
     Creates a Refund object which can be used to refund a previous transaction
     
     - Parameter receiptId:        The receipt of the previous transaction
     - Parameter amount:           The amount to be refunded (will check if funds are available in your account)
     - Parameter paymentReference: The payment reference string
     
     - Throws: LuhnValidationError judoId does not match the given length or is not LUHN valid
     
     - Returns: a Refund object for reactive usage
     */
    public func refund(_ receiptId: String, amount: Amount) throws -> Refund {
        return try Refund(receiptId: receiptId, amount: amount).apiSession(self.apiSession)
    }
    
    
    /**
     Creates a VoidTransaction object which can be used to void a previous preAuth
     
     - Parameter receiptId:        The receipt of the previous transaction
     - Parameter amount:           The amount to be refunded (will check if funds are available in your account)
     - Parameter paymentReference: The payment reference string
     
     - Throws: LuhnValidationError judoId does not match the given length or is not LUHN valid
     
     - Returns: a Void object for reactive usage
     */
    public func voidTransaction(_ receiptId: String, amount: Amount) throws -> VoidTransaction {
        return try VoidTransaction(receiptId: receiptId, amount: amount).apiSession(self.apiSession)
    }
    
    
    /**
     Creates an instance of a class that conforms to SessionProtocol. This means that anything related to Payments or PreAuths can be queried for a list
     
     - parameter type: the type
     
     - returns: a new instance that can be used to fetch information
     */
    public func list<T:SessionProtocol>(_ type: T.Type) -> T {
        var transaction = T()
        transaction.APISession = self.apiSession
        return transaction
    }
    
    // MARK: Helper methods
    
    
    /**
    Helper method to initiate, pass information and show a JudoPay ViewController
    
    - parameter viewController: the viewController to initiate and show
    - parameter cardDetails:    optional dictionary that contains card info
    */
    func initiateAndShow(_ viewController: JudoPayViewController) {
        self.deviceDNA.getDeviceSignals { (device, error) in
            if let device = device as JSONDictionary? {
                self.deviceSignals = device
            }
        }
        
        self.activeViewController = viewController
        self.showViewController(viewController)
        //self.showViewController(UINavigationController(rootViewController: viewController))
    }
    
    
    /**
     Helper method to show a given ViewController on the top most view
     
     - parameter vc: the viewController to show
     */
    func showViewController(_ vc: UIViewController) {
        vc.modalPresentationStyle = .formSheet
       
        var viewController = UIApplication.shared.keyWindow?.rootViewController
        
//        if let presented = viewController?.presentedViewController {
        
            switch viewController {
            case is UINavigationController:
                let navigationController = viewController as! UINavigationController
                viewController = navigationController.viewControllers.last!
                if let presentedVC = viewController?.presentedViewController {
                    viewController = presentedVC
                }
                navigationController.pushViewController(vc, animated: true)
                
            case is UITabBarController:
                let tabBarController = viewController as! UITabBarController
                viewController = tabBarController.selectedViewController!
                if let presentedVC = viewController?.presentedViewController {
                    viewController = presentedVC
                }
                tabBarController.addChildViewController(vc)
                
            default:
                viewController?.present(vc, animated:true, completion:nil)
//            }
        }
        
        
    }
    
    
}
