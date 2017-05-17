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

struct WalletCard {
    let id: UUID
    let cardNumberLastFour: String
    let expiryDate: String
    let cardToken: String
    let cardType: CardLogoType?
    let assignedName: String?
    let dateCreated: Date
    let dateUpdated: Date?
    let defaultPaymentMethod: Bool
    
    fileprivate init(id: UUID, cardNumberLastFour: String, expiryDate: String, cardToken: String, cardType: CardLogoType, assignedName: String?, dateCreated: Date, dateUpdated: Date?, defaultPaymentMethod: Bool) {
        self.id = id
        self.cardNumberLastFour = cardNumberLastFour
        self.expiryDate = expiryDate
        self.cardToken = cardToken
        self.cardType = cardType
        self.assignedName = assignedName
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.defaultPaymentMethod = defaultPaymentMethod
    }
    
    init(cardNumberLastFour: String, expiryDate: String, cardToken: String, cardType: CardLogoType, assignedName: String?, defaultPaymentMethod: Bool) {
        self.init(id: UUID(), cardNumberLastFour: cardNumberLastFour, expiryDate: expiryDate, cardToken: cardToken, cardType: cardType, assignedName: assignedName, dateCreated: Date(), dateUpdated: nil, defaultPaymentMethod: defaultPaymentMethod)
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
}

extension WalletCard {
    func withDefaultCard() -> WalletCard {
        return WalletCard(id: self.id, cardNumberLastFour: self.cardNumberLastFour, expiryDate: self.expiryDate, cardToken: self.cardToken, cardType: self.cardType!, assignedName: self.assignedName, dateCreated: self.dateCreated, dateUpdated: Date(), defaultPaymentMethod: true)
    }
    
    func withNonDefaultCard() -> WalletCard {
        return WalletCard(id: self.id, cardNumberLastFour: self.cardNumberLastFour, expiryDate: self.expiryDate, cardToken: self.cardToken, cardType: self.cardType!, assignedName: self.assignedName, dateCreated: self.dateCreated, dateUpdated: Date(), defaultPaymentMethod: false)
    }
    
    func withAssignedCardName(assignedName: String?) -> WalletCard {
        return WalletCard(id: self.id, cardNumberLastFour: self.cardNumberLastFour, expiryDate: self.expiryDate, cardToken: self.cardToken, cardType: self.cardType!, assignedName: assignedName, dateCreated: self.dateCreated, dateUpdated: Date(), defaultPaymentMethod: self.defaultPaymentMethod)
    }
}
