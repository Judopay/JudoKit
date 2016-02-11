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
import Judo

/// Entry point for interacting with judoKit
@objc public class JudoKit: NSObject {
    
    /// JudoKit local judo session
    public let judoSession: Judo
    
    /// the theme of any judoSession
    public static var theme: JudoTheme = JudoTheme()
    
    /**
     designated initializer of JudoKit
     
     - Parameter token:  a string object representing the token
     - Parameter secret: a string object representing the secret
     
     - returns: a new instance of JudoKit
     */
    @objc public init(token: String, secret: String) {
        judoSession = Judo(token: token, secret: secret)
    }
    
    
    /**
    Set the app to sandboxed mode
    
    - parameter enabled: true to set the SDK to sandboxed mode
    */
    @objc public func sandboxed(enabled: Bool) {
        judoSession.sandboxed = enabled
    }
    
    // MARK: Transactions
    
    
    /**
    Main payment method
    
    - parameter judoID:       The judoID of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    @objc public func payment(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails? = nil, completion: (Response?, JudoError?) -> ()) {
        let judoPayViewController = JudoPayViewController(judoID: judoID, amount: amount, reference: reference, completion: completion, currentSession: judoSession)
        self.initiateAndShow(judoPayViewController, cardDetails: cardDetails)
    }
    
    
    /**
    Make a pre-auth using this method
    
    - parameter judoID:       The judoID of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    @objc public func preAuth(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails? = nil, completion: (Response?, JudoError?) -> ()) {
        let judoPayViewController = JudoPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, currentSession: judoSession)
        self.initiateAndShow(judoPayViewController, cardDetails: cardDetails)
    }
    
    
    // MARK: Register Card
    
    
    
    /**
    Initiates a card registration
    
    - parameter judoID:       The judoID of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    @objc public func registerCard(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails? = nil, completion: (Response?, JudoError?) -> ()) {
        let judoPayViewController = JudoPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .RegisterCard, completion: completion, currentSession: judoSession)
        self.initiateAndShow(judoPayViewController, cardDetails: cardDetails)
    }
    
    
    // MARK: Token Transactions
    
    /**
    Initiates the token payment process
    
    - parameter judoID:       The judoID of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter cardDetails:  The card details to present in the input fields
    - parameter paymentToken: The consumer and card token to make a token payment with
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    @objc public func tokenPayment(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: (Response?, JudoError?) -> ()) {
        let vc = UINavigationController(rootViewController: JudoPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .Payment, completion: completion, currentSession: judoSession, cardDetails: cardDetails, paymentToken: paymentToken))
        self.showViewController(vc)
    }
    
    
    /**
    Initiates the token pre-auth process
    
    - parameter judoID:       The judoID of the merchant to receive the payment
    - parameter amount:       The amount and currency of the payment (default is GBP)
    - parameter reference:    Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter cardDetails:  The card details to present in the input fields
    - parameter paymentToken: The consumer and card token to make a token payment with
    - parameter completion:   The completion handler which will respond with a Response Object or an NSError
    */
    @objc public func tokenPreAuth(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: (Response?, JudoError?) -> ()) {
        let vc = UINavigationController(rootViewController: JudoPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, completion: completion, currentSession: judoSession, cardDetails: cardDetails, paymentToken: paymentToken))
        self.showViewController(vc)
    }
    
    
    /**
    Executes an Apple Pay payment transaction
    
    - parameter judoID:     The judoID of the merchant to receive the payment
    - parameter amount:     The amount and currency of the payment (default is GBP)
    - parameter reference:  Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter payment:    The PKPayment object that is generated during an ApplePay process
    */
    @objc public func applePayPayment(judoID: String, amount: Amount, reference: Reference, payment: PKPayment, completion: (Response?, JudoError?) -> ()) {
        do {
            try judoSession.payment(judoID, amount: amount, reference: reference).pkPayment(payment).completion(completion)
        } catch {
            completion(nil, JudoError(.ParameterError))
        }
    }
    
    
    /**
    Executes an Apple Pay pre-auth transaction
    
    - parameter judoID:     The judoID of the merchant to receive the payment
    - parameter amount:     The amount and currency of the payment (default is GBP)
    - parameter reference:  Reference object that holds consumer and payment reference and a meta data dictionary which can hold any kind of JSON formatted information
    - parameter payment:    The PKPayment object that is generated during an ApplePay process
    */
    @objc public func applePayPreAuth(judoID: String, amount: Amount, reference: Reference, payment: PKPayment, completion: (Response?, JudoError?) -> ()) {
        do {
            try judoSession.preAuth(judoID, amount: amount, reference: reference).pkPayment(payment).completion(completion)
        } catch {
            completion(nil, JudoError(.ParameterError))
        }
    }
    
    // MARK: Helper methods
    
    
    /**
    Helper method to initiate, pass information and show a JudoPay ViewController
    
    - parameter viewController: the viewController to initiate and show
    - parameter cardDetails:    optional dictionary that contains card info
    */
    func initiateAndShow(viewController: JudoPayViewController, cardDetails: CardDetails? = nil) {
        viewController.myView.cardInputField.textField.text = cardDetails?.cardNumber
        viewController.myView.expiryDateInputField.textField.text = cardDetails?.formattedEndDate()
        self.showViewController(UINavigationController(rootViewController: viewController))
    }
    
    
    /**
     Helper method to show a given ViewController on the top most view
     
     - parameter vc: the viewController to show
     */
    func showViewController(vc: UIViewController) {
        vc.modalPresentationStyle = .FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
}
