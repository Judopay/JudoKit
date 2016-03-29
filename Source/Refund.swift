//
//  Refund.swift
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


/** 
Refunding a successful payment is easy, simply identify the original receipt ID for the payment and the amount you wish to refund. When we've received this request, we check to ensure there is a sufficient balance to process the refund and then process the request accordingly. Here is an example to how you can make a Refund with the SDK.

### Refund by ID and amount
```swift
    myJudoSession.refund(receiptID, amount: amount).completion({ (dict, error) -> () in
        if let error = error {
            // error
        } else {
            // success
        }
    })
```

*/
public class Refund: TransactionProcess, TransactionPath {
    
    /// path variable for a refund of a payment
    public static var path: String { get { return "/transactions/refunds" } }
    
}
