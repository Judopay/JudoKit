//
//  TransactionProcess.swift
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

/// Superclass Helper for Collection, Void and Refund
public class TransactionProcess: NSObject {
    
    /// The receipt ID for a collection, void or refund
    public private (set) var receiptID: String
    /// The amount of the collection, void or refund
    public private (set) var amount: Amount
    /// The payment reference String for a collection, void or refund
    public private (set) var paymentReference: String = ""
    /// The current Session to access the Judo API
    public var APISession: Session?
    
    
    /**
     Starting point and a reactive method to create a collection, void or refund
     
     - Parameter receiptID: the receiptID identifying the transaction you wish to collect, void or refund - has to be luhn-valid
     - Parameter amount: The amount to process
     
     - Throws: LuhnValidationError judoID does not match the given length or is not luhn valid
     */
    init(receiptID: String, amount: Amount) throws {
        // Initialize variables
        self.receiptID = receiptID
        self.amount = amount
        super.init()
        
        guard let uuidString = UIDevice.currentDevice().identifierForVendor?.UUIDString else {
            throw JudoError(.UnknownError)
        }
        let finalString = String((uuidString + String(NSDate())).characters.filter { ![":", "-", "+"].contains(String($0)) }).stringByReplacingOccurrencesOfString(" ", withString: "")
        self.paymentReference = finalString.substringToIndex(finalString.endIndex.advancedBy(-4))
        
        // Luhn check the receipt ID
        if !receiptID.isLuhnValid() {
            throw JudoError(.LuhnValidationError)
        }
    }
    
    
    /**
     apiSession caller - this method sets the session variable and returns itself for further use
     
     - Parameter session: the API session which is used to call the Judo endpoints
     
     - Returns: reactive self
     */
    public func apiSession(session: Session) -> Self {
        self.APISession = session
        return self
    }
    
    
    /**
     Completion caller - this method will automatically trigger a Session Call to the judo REST API and execute the request based on the information that were set in the previous methods
     
     - Parameter block: a completion block that is called when the request finishes
     
     - Returns: reactive self
     */
    public func completion(block: JudoCompletionBlock) -> Self {
        
        guard let parameters = self.APISession?.progressionParameters(self.receiptID, amount: self.amount, paymentReference: self.paymentReference) else { return self }
        
        self.APISession?.POST(self.path(), parameters: parameters) { (dict, error) -> Void in
            block(dict, error)
        }
        
        return self
    }
    
    
    /**
     Helper method for extensions of this class to be able to access the dynamic path value
     
     - returns: the rest api access path of the current class
     */
    public func path() -> String {
        return (self.dynamicType as! TransactionPath.Type).path
    }
    
}
