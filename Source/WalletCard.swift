//
//  WalletCard.swift
//  JudoKit
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

open class WalletCard: NSObject, NSCoding {
    let id: UUID
    let cardNumberLastFour: String
    let expiryDate: String
    let cardToken: String
    let cardType: CardLogoType?
    var assignedName: String?
    let dateCreated: Date
    let dateUpdated: Date?
    var defaultPaymentMethod: Bool
    /// Card token and Consumer token
    let paymentToken: PaymentToken?
    let cardDetails: CardDetails?
    
    fileprivate init(id: UUID, cardNumberLastFour: String, expiryDate: String, cardToken: String, cardType: CardLogoType, assignedName: String?, dateCreated: Date, dateUpdated: Date?, defaultPaymentMethod: Bool, paymentToken: PaymentToken, cardDetails: CardDetails) {
        self.id = id
        self.cardNumberLastFour = cardNumberLastFour
        self.expiryDate = expiryDate
        self.cardToken = cardToken
        self.cardType = cardType
        self.assignedName = assignedName
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.defaultPaymentMethod = defaultPaymentMethod
        self.paymentToken = paymentToken
        self.cardDetails = cardDetails
    }
    
    convenience init(cardNumberLastFour: String, expiryDate: String, cardToken: String, cardType: CardLogoType, assignedName: String?, defaultPaymentMethod: Bool, paymentToken: PaymentToken, cardDetails: CardDetails) {
        self.init(id: UUID(), cardNumberLastFour: cardNumberLastFour, expiryDate: expiryDate, cardToken: cardToken, cardType: cardType, assignedName: assignedName, dateCreated: Date(), dateUpdated: Date(), defaultPaymentMethod: defaultPaymentMethod, paymentToken: paymentToken, cardDetails: cardDetails)
    }
    
    func hasCardExpired() -> Bool {
        let splitExpiryDate = self.expiryDate.components(separatedBy: "/")
        let month = Int(splitExpiryDate[0])
        let year = Int("20\(splitExpiryDate[1])")
        
        var dateComponents = DateComponents(year: year, month: month)

        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .year, for: date)!
        dateComponents.day = range.count

        return Date() > calendar.date(from: dateComponents)!
    }
    
    /**
     Initialise the WalletCard object with a coder
     
     - parameter decoder: the decoder object
     
     - returns: a WalletCard object or nil
     */
    public required init?(coder decoder: NSCoder) {
        
        let id = decoder.decodeObject(forKey: "id") as? UUID
        let cardNumberLastFour = decoder.decodeObject(forKey: "cardNumberLastFour") as? String
        let expiryDate = decoder.decodeObject(forKey: "expiryDate") as? String
        let cardToken = decoder.decodeObject(forKey: "cardToken") as? String
        let cardType = decoder.decodeInt64(forKey: "cardType")
        let assignedName = decoder.decodeObject(forKey: "assignedName") as? String
        let dateCreated = decoder.decodeObject(forKey: "dateCreated") as? Date
        let dateUpdated = decoder.decodeObject(forKey: "dateUpdated") as? Date
        let defaultPaymentMethod = decoder.decodeObject(forKey: "defaultPaymentMethod") as? Bool
        let paymentToken = decoder.decodeObject(forKey: "paymentToken") as? PaymentToken
        let cardDetails = decoder.decodeObject(forKey: "cardDetails") as? CardDetails
        
        self.id = id!
        self.cardNumberLastFour = cardNumberLastFour!
        self.expiryDate = expiryDate!
        self.cardToken = cardToken!
        self.cardType = CardLogoType(rawValue:Int64(cardType))
        self.assignedName = assignedName!
        self.dateCreated = dateCreated!
        self.dateUpdated = dateUpdated!
        self.defaultPaymentMethod = defaultPaymentMethod ?? false
        self.paymentToken = paymentToken!
        self.cardDetails = cardDetails!
        
        super.init()
    }
    
    
    /**
     Encode the receiver WalletCard object
     
     - parameter aCoder: the Coder
     */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.cardNumberLastFour, forKey: "cardNumberLastFour")
        aCoder.encode(self.expiryDate, forKey: "expiryDate")
        aCoder.encode(self.cardToken, forKey: "cardToken")
        if let cardType = self.cardType {
            aCoder.encode(cardType.rawValue, forKey: "cardType")
        } else {
            aCoder.encode(0, forKey: "cardType")
        }
        aCoder.encode(self.assignedName, forKey: "assignedName")
        aCoder.encode(self.dateCreated, forKey: "dateCreated")
        aCoder.encode(self.dateUpdated, forKey: "dateUpdated")
        aCoder.encode(self.defaultPaymentMethod, forKey: "defaultPaymentMethod")
        aCoder.encode(self.paymentToken, forKey: "paymentToken")
        aCoder.encode(self.cardDetails, forKey: "cardDetails")
    }
}

extension WalletCard {
    func withDefaultCard() -> WalletCard {
        return WalletCard(id: self.id, cardNumberLastFour: self.cardNumberLastFour, expiryDate: self.expiryDate, cardToken: self.cardToken, cardType: self.cardType!, assignedName: self.assignedName, dateCreated: self.dateCreated, dateUpdated: Date(), defaultPaymentMethod: true, paymentToken: self.paymentToken!, cardDetails: self.cardDetails!)
    }
    
    func withNonDefaultCard() -> WalletCard {
        return WalletCard(id: self.id, cardNumberLastFour: self.cardNumberLastFour, expiryDate: self.expiryDate, cardToken: self.cardToken, cardType: self.cardType!, assignedName: self.assignedName, dateCreated: self.dateCreated, dateUpdated: Date(), defaultPaymentMethod: false, paymentToken: self.paymentToken!, cardDetails: self.cardDetails!)
    }
    
    func withAssignedCardName(assignedName: String?) -> WalletCard {
        return WalletCard(id: self.id, cardNumberLastFour: self.cardNumberLastFour, expiryDate: self.expiryDate, cardToken: self.cardToken, cardType: self.cardType!, assignedName: assignedName, dateCreated: self.dateCreated, dateUpdated: Date(), defaultPaymentMethod: self.defaultPaymentMethod, paymentToken: self.paymentToken!, cardDetails: self.cardDetails!)
    }
}
