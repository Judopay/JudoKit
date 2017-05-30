//
//  Receipt.swift
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

open class Receipt {
    
    /// the receipt ID - nil for a list of all receipts
    fileprivate (set) var receiptId: String?
    /// The current Session to access the Judo API
    open var APISession: Session?
    
    /**
    Initialization for a Receipt Object
    
    If you want to use the receipt function, you need to enable it in your judo Dashboard
    
    - Parameter receiptId: the receipt ID as a String - if nil, completion function will return a list of all transactions
    
    - Returns: a Receipt Object for reactive usage
    
    - Throws: LuhnValidationError if the receiptId does not match
    */
    init(receiptId: String? = nil) throws {
        // luhn check the receipt id
        self.receiptId = receiptId
    }
    
    
    /**
     apiSession caller - this method sets the session variable and returns itself for further use
     
     - Parameter session: the API session which is used to call the Judo endpoints
     
     - Returns: reactive self
     */
    open func apiSession(_ session: Session) -> Self {
        self.APISession = session
        return self
    }
    

    /**
    Completion caller - this method will automatically trigger a Session Call to the judo REST API and execute the request based on the information that were set in the previous methods.
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive self
    */
    open func completion(_ block: @escaping JudoCompletionBlock) -> Self {
        var path = "transactions"

        if let rec = self.receiptId {
            path += "/\(rec)"
        }
        
        self.APISession?.GET(path, parameters: nil) { (dictionary, error) -> () in
            block(dictionary, error)
        }
        return self
    }
    
    
    /**
    This method will return a list of receipts
    
    See [List all transactions](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/#transactions>) for more information.
    
    - Parameter pagination: The offset, number of items and order in which to return the items
    - Parameter block: a completion block that is called when the request finishes
    */
    open func list(_ pagination: Pagination, block: @escaping JudoCompletionBlock) {
        let path = "transactions?pageSize=\(pagination.pageSize)&offset=\(pagination.offset)&sort=\(pagination.sort.rawValue)"
        self.APISession?.GET(path, parameters: nil) { (dictionary, error) -> () in
            block(dictionary, error)
        }
    }
    
}
