//
//  Payment.swift
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

open class Payment: Transaction, TransactionPath {
    
    /// path variable for this class
    open static var path: String { get { return "transactions/payments" } }
    
    
    /**
    If you need to check a payment before actually processing it, you can use the validate call, we'll perform our internal checks on the payment without sending it to consumer's bank. We check if the merchant identified by the judo ID can accept the payment, if the card can be accepted and if the card number passes the LUHN test.
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive Self
    */
    open func validate(_ block: @escaping (JudoCompletionBlock)) throws -> Self {
        if (self.card != nil && self.payToken != nil) {
            throw JudoError(.cardAndTokenError)
        } else if self.card == nil && self.payToken == nil {
            throw JudoError(.cardOrTokenMissingError)
        }
        
        self.APISession?.POST(type(of: self).path + "/validate", parameters: self.parameters) { (dict, error) -> Void in
            block(dict, error)
        }

        return self
    }

}
