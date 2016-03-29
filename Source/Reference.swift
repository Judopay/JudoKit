//
//  Reference.swift
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
 
 **Referencing a transaction**
 
 the Reference object is supposed to simplify storing reference data like consumer, payment references and metadata dictionary that can hold an arbitrary set of key value based information
 
 you create a reference object by calling the initializer with a reference of your consumer.
 
 If you have used the reference to register a card, make sure that the consumer reference stays the same for making token based transactions
 
 ```
 guard let references = Reference(consumerRef: "consumer0053252") else { return }
 ```
 
 the Reference initializer returns an optional because of the payment reference which is being generated using the `identifierForVendor()` method on `UIDevice.currentDevice()`. The method returns an optional value and thus can return nil in certain device states.

 If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.

*/
public class Reference: NSObject {
    /// Your reference for this consumer
    public let yourConsumerReference: String
    /// Your reference for this payment
    public let yourPaymentReference: String
    /// An object containing any additional data you wish to tag this payment with. The property name and value are both limited to 50 characters, and the whole object cannot be more than 1024 characters
    public let yourPaymentMetaData: [String : String]?
    
    
    /**
     Private designated initializer
     
     - parameter consumerRef: Consumer reference string
     - parameter paymentRef:  Payment reference string
     - parameter metaData:    Meta data dictionary (defaults to nil)
     
     - returns: a Reference object
     */
    private init(consumerRef: String, paymentRef: String, metaData: [String : String]? = nil) {
        self.yourConsumerReference = consumerRef
        self.yourPaymentReference = paymentRef
        self.yourPaymentMetaData = metaData
    }
    
    
    /**
     Convenience initializer that will generate a unique payment reference
     
     - parameter consumerRef: The consumer reference for a Reference
     - parameter metaData:    An optional field for any arbitrary data that is tied to a certrain transaction
     
     - returns: a Reference object
     */
    public convenience init?(consumerRef: String, metaData: [String : String]? = nil) {
        guard let uuidString = UIDevice.currentDevice().identifierForVendor?.UUIDString else { return nil }
        let finalString = String((uuidString + String(NSDate())).characters.filter { ![":", "-", "+"].contains(String($0)) }).stringByReplacingOccurrencesOfString(" ", withString: "")
        self.init(consumerRef: consumerRef, paymentRef: finalString.substringToIndex(finalString.endIndex.advancedBy(-4)), metaData: metaData)
    }
    
}
