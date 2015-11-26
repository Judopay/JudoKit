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
import PassKit
import Judo

/// Entry point for interacting with the JudoKit
@objc public class JudoKit: NSObject {
    
    /// a tintColor that is used to generate a theme for the Judo payment-form Solution
    public static var tintColor: UIColor = UIColor(red: 30/255, green: 120/255, blue: 160/255, alpha: 1.0)
    
    /// set the address verification service to true to prompt the user to input his country and post code information
    public static var avsEnabled: Bool = false
    
    
    /**
    a mandatory method that sets the token and secret for making payments with Judo
    
    - Parameter token:  a string object representing the token
    - Parameter secret: a string object representing the secret
    */
    @objc public static func setToken(token: String, andSecret secret: String) {
        Judo.setToken(token, secret: secret)
    }
    
    
    /**
    set the app to sandboxed mode
    
    - parameter enabled: true to set the SDK to sandboxed mode
    */
    @objc public static func sandboxed(enabled: Bool) {
        Judo.sandboxed = enabled
    }
    
    
    // MARK: Transactions
    
    
    /**
    Main payment method
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc public static func payment(judoID: String, amount: Amount, reference: Reference, completion: (Response?, JudoError?) -> (), errorHandler: JudoError -> ()) {
        let vc = UINavigationController(rootViewController: JPayViewController(judoID: judoID, amount: amount, reference: reference, completion: completion, encounteredError: errorHandler))
        vc.modalPresentationStyle = .FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    /**
    Make a preAuth using this method
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc public static func preAuth(judoID: String, amount: Amount, reference: Reference, completion: (Response?, JudoError?) -> (), errorHandler: JudoError -> ()) {
        let vc = UINavigationController(rootViewController: JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, encounteredError: errorHandler))
        vc.modalPresentationStyle = .FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: Register Card
    
    
    
    /**
    Initiates a card registration
    
    - parameter judoID:       the judoID of the merchant to receive the payment
    - parameter amount:       the amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   the completion handler which will respond with a Response Object or an NSError
    - parameter errorHandler: arbitrary error handler for more control to detect input or other non-fatal errors
    */
    @objc public static func registerCard(judoID: String, amount: Amount, reference: Reference, completion: (Response?, JudoError?) -> (), errorHandler: JudoError -> ()) {
        let vc = UINavigationController(rootViewController: JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .RegisterCard, completion: completion, encounteredError: errorHandler))
        vc.modalPresentationStyle = .FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: Token Transactions
    
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
    @objc public static func tokenPayment(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: (Response?, JudoError?) -> (), errorHandler: JudoError -> ()) {
        let vc = UINavigationController(rootViewController: JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .Payment, completion: completion, encounteredError: errorHandler, cardDetails: cardDetails, paymentToken: paymentToken))
        vc.modalPresentationStyle = .FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
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
    @objc public static func tokenPreAuth(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: (Response?, JudoError?) -> (), errorHandler: JudoError -> ()) {
        let vc = UINavigationController(rootViewController: JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, encounteredError: errorHandler, cardDetails: cardDetails, paymentToken: paymentToken))
        vc.modalPresentationStyle = .FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    /**
    executes an applePay payment transaction
    
    - parameter judoID:     the judoID of the merchant to receive the payment
    - parameter amount:     the amount and currency of the payment (default is GBP)
    - parameter reference:  Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter payment:    the PKPayment object that is generated during an ApplePay process
    */
    @objc public static func applePayPayment(judoID: String, amount: Amount, reference: Reference, payment: PKPayment, completion: (Response?, JudoError?) -> ()) {
        do {
            try Judo.payment(judoID, amount: amount, reference: reference).pkPayment(payment).completion(completion)
        } catch {
            completion(nil, JudoError(.ParameterError))
        }
    }
    
    
    /**
    executes an applePay preAuth transaction
    
    - parameter judoID:     the judoID of the merchant to receive the payment
    - parameter amount:     the amount and currency of the payment (default is GBP)
    - parameter reference:  Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter payment:    the PKPayment object that is generated during an ApplePay process
    */
    @objc public static func applePayPreAuth(judoID: String, amount: Amount, reference: Reference, payment: PKPayment, completion: (Response?, JudoError?) -> ()) {
        do {
            try Judo.preAuth(judoID, amount: amount, reference: reference).pkPayment(payment).completion(completion)
        } catch {
            completion(nil, JudoError(.ParameterError))
        }
    }
    
}
