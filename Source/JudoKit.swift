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
import JudoSecure
import Judo

public typealias TransactionBlock = (Response?, NSError?) -> ()

public class JudoKit: JPayViewDelegate {
    
    static public let sharedInstance = JudoKit()
    
    private var completionBlock: TransactionBlock?
    
    public static func setToken(token: String, andSecret secret: String) {
        Judo.setToken(token, secret: secret)
    }
    
    public static func sandboxed(enabled: Bool) {
        Judo.sandboxed = enabled
    }
    
    public func payment(judoID: String, amount: Amount, reference: Reference, completion: TransactionBlock?) {
        self.completionBlock = completion
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    public func preAuth(judoID: String, amount: Amount, reference: Reference, completion: TransactionBlock?) {
        self.completionBlock = completion
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    public func registerCard(judoID: String, amount: Amount, reference: Reference, completion: TransactionBlock?) {
        self.completionBlock = completion
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .RegisterCard)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    public func tokenPayment(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: TransactionBlock?) {
        self.completionBlock = completion
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .Payment, cardDetails: cardDetails, paymentToken: paymentToken)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

    public func tokenPreAuth(judoID: String, amount: Amount, reference: Reference, cardDetails: CardDetails, paymentToken: PaymentToken, completion: TransactionBlock?) {
        self.completionBlock = completion
        let vc = JPayViewController(judoID: judoID, amount: amount, reference: reference, transactionType: .PreAuth, cardDetails: cardDetails, paymentToken: paymentToken)
        vc.delegate = self
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    // MARK: JPayViewDelegate
    
    public func payViewControllerDidCancelPayment(controller: JPayViewController) {
        if let compl = self.completionBlock {
            compl(nil, JudoError.UserDidCancel as NSError)
        }
    }
    
    public func payViewController(controller: JPayViewController, didPaySuccessfullyWithResponse response: Response) {
        
    }
    
    public func payViewController(controller: JPayViewController, didFailPaymentWithError error: NSError) {
        
    }
    
    public func payViewController(controller: JPayViewController, didEncounterError error: NSError) {
        
    }


}
