//
//  Transaction.swift
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
import CoreLocation
import PassKit

/// intended for subclassing paths
public protocol TransactionPath {
    /// path variable made for subclassing
    static var path: String { get }
}

/// intended for classes that can be queried for lists
public protocol SessionProtocol {
    
    /// the current API Session
    var APISession: Session? { get set }
    
    /**
     a method to set the API session in a fluent way
     
     - parameter session: the session to set
     
     - returns: Self
     */
    func apiSession(session: Session) -> Self
    
    /**
     designated initializer
     
     - returns: an instance of the receiving type
     */
    init()
}

/// Superclass Helper for Payment, Pre-auth and RegisterCard
public class Transaction: SessionProtocol {
    
    /// The current transaction if there is one - for preventing multiple transactions running at the same time
    private var currentTransactionReference: String? = nil
    
    internal var parameters = [String:AnyObject]();
    
    /// The current Session to access the Judo API
    public var APISession: Session?
    
    /// The judo ID for the transaction
    public private (set) var judoID: String {
        didSet {
            self.parameters["judoId"] = judoID
        }
    }
    
    /// The reference of the transaction
    public private (set) var reference: Reference {
        didSet {
            self.parameters["yourConsumerReference"] = reference.yourConsumerReference
            self.parameters["yourPaymentReference"] = reference.yourPaymentReference
            if let metaData = reference.yourPaymentMetaData {
                self.parameters["yourPaymentMetaData"] = metaData
            }
        }
    }
    
    /// The amount and currency of the transaction
    public private (set) var amount: Amount? {
        didSet {
            guard let amount = amount else { return }
            self.parameters["amount"] = amount.amount
            self.parameters["currency"] = amount.currency.rawValue
        }
    }
    
    /// The card info of the transaction
    public private (set) var card: Card? {
        didSet {
            self.parameters["cardNumber"] = card?.number
            self.parameters["expiryDate"] = card?.expiryDate
            self.parameters["cv2"] = card?.cv2
            self.parameters["cardAddress"] = card?.address?.dictionaryRepresentation()
            self.parameters["startDate"] = card?.startDate
            self.parameters["issueNumber"] = card?.issueNumber
        }
    }
    
    /// The payment token of the transaction
    public private (set) var payToken: PaymentToken? {
        didSet {
            self.parameters["consumerToken"] = payToken?.consumerToken
            self.parameters["cardToken"] = payToken?.cardToken
            self.parameters["cv2"] = payToken?.cv2
        }
    }
    
    /// Location coordinate for fraud prevention in this transaction
    public private (set) var location: CLLocationCoordinate2D? {
        didSet {
            guard let location = location else { return }
            self.parameters["consumerLocation"] = ["latitude":NSNumber(double: location.latitude), "longitude":NSNumber(double: location.longitude)]
        }
    }
    
    /// Device identification for this transaction
    public private (set) var deviceSignal: JSONDictionary? {
        didSet {
            self.parameters["clientDetails"] = deviceSignal
        }
    }
    
    /// Mobile number of the entity initiating the transaction
    public private (set) var mobileNumber: String? {
        didSet {
            self.parameters["mobileNumber"] = mobileNumber
        }
    }
    
    /// Email address of the entity initiating the transaction
    public private (set) var emailAddress: String? {
        didSet {
            self.parameters["emailAddress"] = emailAddress
        }
    }
    
    /// Support for Apple Pay transactions added in Base
    public private (set) var pkPayment: PKPayment? {
        didSet {
            guard let pkPayment = pkPayment else { return }
            var tokenDict = JSONDictionary()
            if #available(iOS 9.0, *) {
                tokenDict["paymentInstrumentName"] = pkPayment.token.paymentMethod.displayName
            } else {
                tokenDict["paymentInstrumentName"] = pkPayment.token.paymentInstrumentName
            }
            if #available(iOS 9.0, *) {
                tokenDict["paymentNetwork"] = pkPayment.token.paymentMethod.network
            } else {
                tokenDict["paymentNetwork"] = pkPayment.token.paymentNetwork
            }
            do {
                tokenDict["paymentData"] = try NSJSONSerialization.JSONObjectWithData(pkPayment.token.paymentData, options: NSJSONReadingOptions.MutableLeaves) as? JSONDictionary
            } catch {
                return // BAIL
            }
            
            self.parameters["pkPayment"] = ["token":tokenDict]
        }
    }
    
    /// hidden parameter to enable recurring payments
    public private (set) var initialRecurringPayment: Bool = false {
        didSet {
            self.parameters["InitialRecurringPayment"] = initialRecurringPayment
        }
    }
    

    /**
    Starting point and a reactive method to create a payment or pre-auth
    
    - Parameter judoID: the number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount: The amount to process
    - Parameter reference: the reference
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not luhn valid
    */
    public init(judoID: String, amount: Amount?, reference: Reference) throws {
        self.judoID = judoID
        self.amount = amount
        self.reference = reference
        
        self.parameters["judoId"] = judoID
        self.parameters["yourConsumerReference"] = reference.yourConsumerReference
        self.parameters["yourPaymentReference"] = reference.yourPaymentReference
        if let metaData = reference.yourPaymentMetaData {
            self.parameters["yourPaymentMetaData"] = metaData
        }
        
        if let amount = amount {
            self.parameters["amount"] = amount.amount
            self.parameters["currency"] = amount.currency.rawValue
        }
        
        // judo ID validation
        let strippedJudoID = judoID.stripped
        
        if !strippedJudoID.isLuhnValid() {
            throw JudoError(.LuhnValidationError)
        }
        
        if kJudoIDLenght ~= strippedJudoID.characters.count  {
            self.judoID = strippedJudoID
        } else {
            throw JudoError(.JudoIDInvalidError)
        }
    }
    
    
    /**
     Internal initializer for the purpose of creating an instance for listing payments or preAuths
     */
    public required init() {
        self.judoID = ""
        self.amount = nil
        self.reference = Reference(consumerRef: "")!
    }
    
    
    /**
    If making a card payment, add the details here
    
    - Parameter card: a card object containing the information from which to make a payment
    
    - Returns: reactive self
    */
    public func card(card: Card) -> Self {
        self.card = card
        return self
    }

    
    /**
    If a card payment or a card registration has been previously made, add the token to make a repeat payment
    
    - Parameter token: a token-string from a previous payment or registration
    
    - Returns: reactive self
    */
    public func paymentToken(token: PaymentToken) -> Self {
        self.payToken = token
        return self
    }
    
    
    /**
    Reactive method to set location information of the user, this method is optional and is used for fraud prevention
    
    - Parameter location: a CLLocationCoordinate2D which represents the current location of the user
    
    - Returns: reactive self
    */
    public func location(location: CLLocationCoordinate2D) -> Self {
        self.location = location
        return self
    }
    
    
    /**
    Reactive method to set device signal information of the device, this method is optional and is used for fraud prevention
    
    - Parameter deviceSignal: a Dictionary which contains information about the device
    
    - Returns: reactive self
    */
    public func deviceSignal(deviceSignal: JSONDictionary) -> Self {
        self.deviceSignal = deviceSignal
        return self
    }
    
    
    /**
    Reactive method to set contact information of the user such as mobile number and email address, this method is optional
    
    - Parameter mobileNumber: a mobile number String
    - Parameter emailAddress: an email address String
    
    - Returns: reactive self
    */
    public func contact(mobileNumber : String?, _ emailAddress : String? = nil) -> Self {
        self.mobileNumber = mobileNumber
        self.emailAddress = emailAddress
        return self
    }
    
    
    /**
    For creating an Apple Pay Transaction, use this method to add the PKPayment object
    
    - Parameter payment: the PKPayment object
    
    - Returns: reactive self
    */
    public func pkPayment(payment: PKPayment) -> Self {
        self.pkPayment = payment
        return self
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
    
    - Throws: ParameterError one or more of the given parameters were in the incorrect format or nil
    - Throws: CardAndTokenError multiple methods of payment have been provided, please make sure to only provide one method
    - Throws: CardOrTokenMissingError no method of transaction was provided, please provide either a card, paymentToken or PKPayment
    - Throws: AmountMissingError no amount has been provided
    - Throws: DuplicateTransactionError please provide a new Reference object if this transaction is not a duplicate
    */
    public func completion(block: JudoCompletionBlock) throws -> Self {
        
        if self.card != nil && self.payToken != nil {
            throw JudoError(.CardAndTokenError)
        } else if self.card == nil && self.payToken == nil && self.pkPayment == nil {
            throw JudoError(.CardOrTokenMissingError)
        }
        
        if !(self.dynamicType == RegisterCard.self) && self.amount == nil {
            throw JudoError(.AmountMissingError)
        }
        
        if self.reference.yourPaymentReference == self.currentTransactionReference {
            throw JudoError(.DuplicateTransactionError)
        }
        self.currentTransactionReference = self.reference.yourPaymentReference
        
        self.APISession?.POST(self.path(), parameters: self.parameters, completion: block)
        
        return self
    }
    
    
    /**
    threeDSecure call - this method will automatically trigger a Session Call to the judo REST API and execute the finalizing 3DS call on top of the information that had been sent in the previous methods
    
    - Parameter dictionary: the dictionary that contains all the information from the 3DS UIWebView Request
    - Parameter receiptID: the receipt for the given Transaction
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive self
    */
    public func threeDSecure(dictionary: JSONDictionary, receiptID: String, block: JudoCompletionBlock) -> Self {
        
        var paymentDetails = JSONDictionary()
        
        if let paRes = dictionary["PaRes"] as? String {
            paymentDetails["PaRes"] = paRes
        }
        
        if let md = dictionary["MD"] as? String {
            paymentDetails["md"] = md
        }
        
        paymentDetails["receiptID"] = receiptID
        
        self.APISession?.PUT("transactions/" + receiptID, parameters: paymentDetails, completion: block)

        return self
    }
    
    
    /**
    This method will return a list of transactions, filtered to just show the payment or preAuth transactions. The method will show the first 10 items in a Time Descending order
    
    See [List all transactions](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/#transactions>) for more information.
    
    - Parameter block: a completion block that is called when the request finishes
    */
    public func list(block: JudoCompletionBlock) {
        self.list(nil, block: block)
    }
    
    
    /**
    This method will return a list of transactions, filtered to just show the payment or pre-auth transactions.
    
    See [List all transactions](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/#transactions>) for more information.
    
    - Parameter pagination: The offset, number of items and order in which to return the items
    - Parameter block: a completion block that is called when the request finishes
    */
    public func list(pagination: Pagination?, block: JudoCompletionBlock) {
        var path = self.path()
        if let pag = pagination {
            path = path + "?pageSize=\(pag.pageSize)&offset=\(pag.offset)&sort=\(pag.sort.rawValue)"
        }
        self.APISession?.GET(path, parameters: nil, completion: block)
    }
    
    
    /**
    Helper method for extensions of this class to be able to access the dynamic path value
    
    :returns: the rest api access path of the current class
    */
    public func path() -> String {
        return (self.dynamicType as! TransactionPath.Type).path
    }

}

