//
//  Response.swift
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
 **Response**
 
 Response object is created out of the JSON response of the judo API for seamless handling of values returned in any call. 
 
 The response object can hold multiple transaction objects and supports pagination if available.
 
 In most cases (successful Payment, Pre-auth or RegisterCard operation) a Response object will hold one TransactionData object. Supporting CollectionType protocol, you can access the elements by subscripting `let transactionData = response[0]` or using the available variable `response.first` as a more readable approach.
 
 
*/
public class Response: NSObject, GeneratorType, ArrayLiteralConvertible {
    /// The current pagination response
    public let pagination: Pagination?
    /// The array that contains the transaction response objects
    public private (set) var items = [TransactionData]()
    /// Helper to count in case of Generation of elements for loops
    public var indexInSequence = 0
    
    
    /**
     Convenience initializer for ArrayLiteralConvertible support
     
     - parameter elements: elements in a sequential type
     
     - returns: a Response object
     */
    public convenience required init(arrayLiteral elements: TransactionData...) {
        self.init()
        for element in elements {
            self.append(element)
        }
    }
    
    
    /**
    Initialize a Response object with pagination if available
    
    - Parameter pagination: the pagination information for the response
    
    - Returns: a Response object
    */
    init(_ pagination: Pagination?) {
        self.pagination = pagination
    }
    
    
    /**
    Add an element on to the items
    
    - Parameter element: the element to add to the items Array
    */
    public func append(element: TransactionData) {
        self.items.append(element)
    }
    
    
    /**
    Calculate the next page from available data
    
    - Returns: a newly calculated Pagination object based on the Response object
    */
    public func nextPage() -> Pagination? {
        guard let page = self.pagination else { return nil }
        
        return Pagination(pageSize: page.pageSize, offset: page.offset + page.pageSize, sort: page.sort)
    }
    
    // MARK: - GeneratorType
    
    /**
    GeneratorType method to aid when using the object in a loop
    
    - returns: generated next element
    */
    public func next() -> TransactionData? {
        switch items {
        case _ where !items.isEmpty:
            if indexInSequence < items.count {
                let element = items[indexInSequence]
                indexInSequence.advancedBy(1)
                return element
            }
            indexInSequence = 0
            return nil
        default:
            return nil
        }
    }
    
}


/// Response extensions for SequenceType and CollectionType
extension Response: SequenceType, CollectionType {
    
    public typealias Index = Int
    
    /// start index of the sequence
    public var startIndex: Int {
        return 0
    }
    
    
    /// end index of the sequence
    public var endIndex: Int {
        return items.endIndex
    }
    
    
    /**
     create a subscript for a given index
     
     - parameter i: index of subscript
     
     - returns: subscript for a given index
     */
    public subscript(i: Int) -> TransactionData {
        return items[i]
    }
    
    
    /**
     generator for the TransactionData type
     
     - returns: an IndexingGenerator object
     */
    public func generate() -> IndexingGenerator<[TransactionData]> {
        return self.items.generate()
    }

}


/**
 **PaymentToken**
 
 A PaymentToken object which is one part to be used in any token transactions
*/
public class PaymentToken: NSObject {
    /// Our unique reference for this Consumer. Used in conjunction with the card token in repeat transactions.
    public let consumerToken: String
    /// Can be used to charge future payments against this card.
    public let cardToken: String
    /// CV2 of the card
    public var cv2: String?
    
    
    /**
     Designated initializer for non-optional values
     
     - parameter consumerToken: Consumer token string
     - parameter cardToken:     Card token string
     
     - returns: a PaymentToken object
     */
    public init(consumerToken: String, cardToken: String, cv2: String? = nil) {
        self.consumerToken = consumerToken
        self.cardToken = cardToken
        self.cv2 = cv2
        super.init()
    }
    
}


/**
 **Consumer**
 
 Consumer stores information about a reference and a consumer token to be used in any kind of token transaction.
*/
public class Consumer: NSObject {
    /// Our unique reference for this Consumer. Used in conjunction with the card token in repeat transactions.
    public let consumerToken: String
    /// Your reference for this Consumer as you sent in your request.
    public let yourConsumerReference: String
    
    
    /**
     Designated initializer
     
     - parameter dict: the consumer dictionary which was return from the judo REST API
     
     - returns: a Consumer object
     */
    public init(_ dict: JSONDictionary) {
        self.consumerToken = dict["consumerToken"] as! String
        self.yourConsumerReference = dict["yourConsumerReference"] as! String
        super.init()
    }
    
    
    /**
     Designated initializer
     
     - parameter consumerToken:     A consumer token string
     - parameter consumerReference: A consumer reference string
     
     - returns: a consumer object
     */
    public init(consumerToken: String, consumerReference: String) {
        self.consumerToken = consumerToken
        self.yourConsumerReference = consumerReference
        super.init()
    }

}


/**
 **TransactionData**
 
 TransactionData is an object that references all information in correspondance with a Transaction with the judo API
*/
public class TransactionData: NSObject {
    /// Our reference for this transaction. Keep track of this as it's needed to process refunds or collections later
    public let receiptID: String
    /// Your original reference for this payment
    public let yourPaymentReference: String
    /// The type of Transaction, either "Payment" or "Refund"
    public let type: TransactionType
    /// Date and time of the Transaction including time zone offset
    public let createdAt: NSDate
    /// The result of this transactions, this will either be "Success" or "Declined"
    public let result: TransactionResult
    /// A message detailing the result.
    public let message: String?
    /// The number (e.g. "123-456" or "654321") identifying the Merchant to whom payment has been made
    public let judoID: String
    /// The trading name of the Merchant to whom payment has been made
    public let merchantName: String
    /// How the Merchant will appear on the Consumers statement
    public let appearsOnStatementAs: String
    /// If present this will show the total value of refunds made against the original payment
    public let refunds: Amount?
    /// This is the original value of this transaction before refunds
    public let originalAmount: Amount?
    /// This will show the remaining balance of the transaction after refunds. You cannot refund more than the original payment
    public let netAmount: Amount?
    /// This is the value of this transaction (if refunds available it is the amount after refunds)
    public let amount: Amount
    /// Information about the card used in this transaction
    public let cardDetails: CardDetails
    /// Details of the Consumer for use in repeat payments
    public let consumer: Consumer
    /// Raw data of the received dictionary
    public let rawData: [String : AnyObject]
    
    /**
    Create a TransactionData object from a dictionary
    
    - Parameter dict: the dictionary
    
    - Returns: a TransactionData object
    */
    public init(_ dict: JSONDictionary) throws {
        guard let receiptID = dict["receiptId"] as? String,
            let yourPaymentReference = dict["yourPaymentReference"] as? String,
            let typeString = dict["type"] as? String,
            let type = TransactionType(rawValue: typeString),
            let createdAtString = dict["createdAt"] as? String,
            let createdAt = ISO8601DateFormatter.dateFromString(createdAtString),
            let resultString = dict["result"] as? String,
            let result = TransactionResult(rawValue: resultString),
            let judoID = dict["judoId"] as? NSNumber,
            let merchantName = dict["merchantName"] as? String,
            let appearsOnStatementAs = dict["appearsOnStatementAs"] as? String,
            let currency = dict["currency"] as? String,
            let amountString = dict["amount"] as? String,
            let cardDetailsDict = dict["cardDetails"] as? JSONDictionary,
            let consumerDict = dict["consumer"] as? JSONDictionary else {
                self.receiptID = ""
                self.yourPaymentReference = ""
                self.type = TransactionType.Payment
                self.createdAt = NSDate()
                self.result = TransactionResult.Error
                self.message = ""
                self.judoID = ""
                self.merchantName = ""
                self.appearsOnStatementAs = ""
                self.refunds = Amount(amountString: "1", currency: .XOR)
                self.originalAmount = Amount(amountString: "1", currency: .XOR)
                self.netAmount = Amount(amountString: "1", currency: .XOR)
                self.amount = Amount(amountString: "1", currency: .XOR)
                self.cardDetails = CardDetails(nil)
                self.consumer = Consumer(consumerToken: "", consumerReference: "")
                self.rawData = [String : AnyObject]()
                super.init()
                throw JudoError(.ResponseParseError)
        }
        
        self.receiptID = receiptID
        self.yourPaymentReference = yourPaymentReference
        self.type = type
        self.createdAt = createdAt
        self.result = result
        self.message = dict["message"] as? String
        self.judoID = String(judoID.integerValue)
        self.merchantName = merchantName
        self.appearsOnStatementAs = appearsOnStatementAs
        
        if let refunds = dict["refunds"] as? String {
            self.refunds = Amount(amountString: refunds.strippedCommas, currency: Currency(currency))
        } else {
            self.refunds = nil
        }
        
        if let originalAmount = dict["originalAmount"] as? String {
            self.originalAmount = Amount(amountString: originalAmount.strippedCommas, currency: Currency(currency))
        } else {
            self.originalAmount = nil
        }
        
        if let netAmount = dict["netAmount"] as? String {
            self.netAmount = Amount(amountString: netAmount.strippedCommas, currency: Currency(currency))
        } else {
            self.netAmount = nil
        }
        
        self.amount = Amount(amountString: amountString.strippedCommas, currency: Currency(currency))
        
        self.cardDetails = CardDetails(cardDetailsDict)
        self.consumer = Consumer(consumerDict)
        self.rawData = dict
        
        super.init()
    }
    
    
    /**
    Generates a PaymentToken object from existing information
    
    - Returns: a PaymentToken object that has been generated from the current objects information
    */
    public func paymentToken() -> PaymentToken? {
        guard let cardToken = self.cardDetails.cardToken else { return nil }
        return PaymentToken(consumerToken: self.consumer.consumerToken, cardToken: cardToken)
    }
}


/**
 Type of Transaction
 
 - Payment: A Payment Transaction
 - PreAuth: A Pre-auth Transaction
 - Refund:  A Refund Transaction
 - RegisterCard: Register a Card
 - Collection: A Pre-Auth Collection
 - VOID: A Pre-Auth Void
*/
public enum TransactionType: String {
    /// A Payment Transaction
    case Payment
    /// A Pre-auth Transaction
    case PreAuth
    /// A Refund Transaction
    case Refund
    /// TransactionTypeRegisterCard for registering a card for a later transaction
    case RegisterCard
    /// A Collection
    case Collection
    /// VOID
    case VOID
}


/**
 Result of a Transaction
 
 - Success:  Successful transaction
 - Declined: Declined transaction
 - Error:    Something went wrong
*/
public enum TransactionResult: String {
    /// Successful transaction
    case Success
    /// Declined transaction
    case Declined
    /// Something went wrong
    case Error
}

// MARK: Helper


/// Formatter for ISO8601 Dates that are returned from the webservice
let ISO8601DateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPOSIXLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"
    return dateFormatter
}()

