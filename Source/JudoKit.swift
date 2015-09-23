//
//  Payment.swift
//  Judo
//
//  Copyright (c) 2015 Alternative Payments Ltd
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
import Judo

public typealias TransactionBlock = (Response?, NSError?) -> ()
public typealias ErrorHandlerBlock = NSError -> ()

@objc public class JudoKit: NSObject {
    
    /// set the address verification service to true to prompt the user to input his country and post code information
    public static var avsEnabled: Bool = false
    
    
    /**
    a mandatory method that sets the token and secret for making payments with Judo
    
    - Parameter token:  a string object representing the token
    - Parameter secret: a string object representing the secret
    */
    public static func setToken(token: String, andSecret secret: String) {
        Judo.setToken(token, secret: secret)
    }
    
    
    /**
    set the app to sandboxed mode
    
    - parameter enabled: true to set the SDK to sandboxed mode
    */
    public static func sandboxed(enabled: Bool) {
        Judo.sandboxed = enabled
    }
    
    
    // MARK: Transactions
    
    
    /**
    Objective C accessible method to make a payment
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount of the payment
    - parameter currency:     the currency in which the payment should be made (default is GBP)
    - parameter payRef:       the payment reference
    - parameter consRef:      the consumer reference
    - parameter metaData:     arbitrary dictionary that can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a JSON Dictionary or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc static public func payment(judoID: String, amount: NSDecimalNumber, currency: String? = nil, payRef: String, consRef: String, metaData: [String:String]?, completion: (([AnyObject]?, NSError?) -> ()), errorHandler: ErrorHandlerBlock) {
        let complBlock: TransactionBlock = { (response, error) in
            var respArray: [AnyObject]? = nil
            if let response = response {
                respArray = response.items.map { $0.rawData }
            }
            completion(respArray, error)
        }
        
        let ref = Reference(consumerRef: consRef, paymentRef: payRef, metaData: metaData)
        self.payment(judoID, amount: Amount(amount, currency), reference: ref, completion: complBlock, errorHandler: errorHandler)
    }
    
    
    /**
    Main payment method
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    static public func payment(judoID: String, amount: Amount, reference: Reference, completion: TransactionBlock, errorHandler: ErrorHandlerBlock) {
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, completion: completion, encounteredError: errorHandler)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    
    /**
    Objective C accessible method to make a preAuth
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount of the payment
    - parameter currency:     the currency in which the payment should be made (default is GBP)
    - parameter payRef:       the payment reference
    - parameter consRef:      the consumer reference
    - parameter metaData:     arbitrary dictionary that can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a JSON Dictionary or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc static public func preAuth(judoID: String, amount: NSDecimalNumber, currency: String? = nil, payRef: String, consRef: String, metaData: [String:String]?, completion: (([AnyObject]?, NSError?) -> ()), errorHandler: ErrorHandlerBlock) {
        let complBlock: TransactionBlock = { (response, error) in
            var respArray: [AnyObject]? = nil
            if let response = response {
                respArray = response.items.map { $0.rawData }
            }
            completion(respArray, error)
        }
        let ref = Reference(consumerRef: consRef, paymentRef: payRef, metaData: metaData)
        self.preAuth(judoID, amount: Amount(amount, currency), reference: ref, completion: complBlock, errorHandler: errorHandler)
    }
    
    
    /**
    Make a preAuth using this method
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    static public func preAuth(judoID: String, amount: Amount, reference: Reference, completion: TransactionBlock, errorHandler: ErrorHandlerBlock) {
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, encounteredError: errorHandler)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    
    // MARK: Register Card
    
    
    /**
    Objective C accessible method to initiate a card registration
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount of the payment
    - parameter currency:     the currency in which the payment should be made (default is GBP)
    - parameter payRef:       the payment reference
    - parameter consRef:      the consumer reference
    - parameter metaData:     arbitrary dictionary that can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a JSON Dictionary or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc static public func registerCard(judoID: String, amount: NSDecimalNumber, currency: String? = nil, payRef: String, consRef: String, metaData: [String:String]?, completion: (([AnyObject]?, NSError?) -> ()), errorHandler: ErrorHandlerBlock) {
        let complBlock: TransactionBlock = { (response, error) in
            var respArray: [AnyObject]? = nil
            if let response = response {
                respArray = response.items.map { $0.rawData }
            }
            completion(respArray, error)
        }
        let ref = Reference(consumerRef: consRef, paymentRef: payRef, metaData: metaData)
        self.registerCard(judoID, amount: Amount(amount, currency), reference: ref, completion: complBlock, errorHandler: errorHandler)
    }
    
    
    /**
    Initiates a card registration
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    static public func registerCard(judoID: String, amount: Amount, reference: Reference, completion: TransactionBlock, errorHandler: ErrorHandlerBlock) {
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .RegisterCard, completion: completion, encounteredError: errorHandler)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    
    // MARK: Token Transactions
    
    
    /**
    Objective C accessible method to initiate a token payment
    
    - parameter judoID:         the judoID of the merchant to receive the payment
    - parameter amount:         the amount of the payment
    - parameter currency:       the currency in which the payment should be made (default is GBP)
    - parameter payRef:         the payment reference
    - parameter consRef:        the consumer reference
    - parameter metaData:       arbitrary dictionary that can hold any kind of JSON formatted information
    - parameter cardDetails:    a Dictionary containing the last four numbers of the card, the expiry date String and the card token
    - parameter consumerToken:  the consumer token that has been returned from a card registration response
    - parameter completion:     the completion handler which will respond with a JSON Dictionary or an NSError
    - parameter errorHandler:   arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc static public func tokenPayment(judoID: String, amount: NSDecimalNumber, currency: String? = nil, payRef: String, consRef: String, metaData: [String:String]?, cardDetails: [String:String], consumerToken: String, completion: (([AnyObject]?, NSError?) -> ()), errorHandler: ErrorHandlerBlock) {
        let complBlock: TransactionBlock = { (response, error) in
            var respArray: [AnyObject]? = nil
            if let response = response {
                respArray = response.items.map { $0.rawData }
            }
            completion(respArray, error)
        }
        let ref = Reference(consumerRef: consRef, paymentRef: payRef, metaData: metaData)
        let payToken = PaymentToken(consumerToken: consumerToken, cardToken: cardDetails["cardToken"])
        self.tokenPayment(judoID, amount: Amount(amount, currency), reference: ref, cardDetails: CardDetails(cardDetails), paymentToken: payToken!, completion: complBlock, errorHandler: errorHandler)
    }
    
    
    /**
    Initiates the token payment process
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter cardDetails:  the card details to present in the input fields
    - parameter paymentToken: the consumer and card token to make a token payment with
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    static public func tokenPayment(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: TransactionBlock, errorHandler: ErrorHandlerBlock) {
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .Payment, completion: completion, encounteredError: errorHandler, cardDetails: cardDetails, paymentToken: paymentToken)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    
    /**
    Objective C accessible method to initiate a token pre auth
    
    - parameter judoID:         the judoID of the merchant to receive the payment
    - parameter amount:         the amount of the payment
    - parameter currency:       the currency in which the payment should be made (default is GBP)
    - parameter payRef:         the payment reference
    - parameter consRef:        the consumer reference
    - parameter metaData:       arbitrary dictionary that can hold any kind of JSON formatted information
    - parameter cardDetails:    a Dictionary containing the last four numbers of the card, the expiry date String and the card token
    - parameter consumerToken:  the consumer token that has been returned from a card registration response
    - parameter completion:     the completion handler which will respond with a JSON Dictionary or an NSError
    - parameter errorHandler:   arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc static public func tokenPreAuth(judoID: String, amount: NSDecimalNumber, currency: String? = nil, payRef: String, consRef: String, metaData: [String:String]?, cardDetails: [String:String], consumerToken: String, completion: (([AnyObject]?, NSError?) -> ()), errorHandler: ErrorHandlerBlock) {
        let complBlock: TransactionBlock = { (response, error) in
            var respArray: [AnyObject]? = nil
            if let response = response {
                respArray = response.items.map { $0.rawData }
            }
            completion(respArray, error)
        }
        let ref = Reference(consumerRef: consRef, paymentRef: payRef, metaData: metaData)
        let payToken = PaymentToken(consumerToken: consumerToken, cardToken: cardDetails["cardToken"])
        self.tokenPreAuth(judoID, amount: Amount(amount, currency), reference: ref, cardDetails: CardDetails(cardDetails), paymentToken: payToken!, completion: complBlock, errorHandler: errorHandler)
    }
    
    
    /**
    Initiates the token pre auth process
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter cardDetails:  the card details to present in the input fields
    - parameter paymentToken: the consumer and card token to make a token payment with
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    static public func tokenPreAuth(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: TransactionBlock, errorHandler: ErrorHandlerBlock) {
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, encounteredError: errorHandler, cardDetails: cardDetails, paymentToken: paymentToken)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}
