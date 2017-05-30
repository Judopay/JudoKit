//
//  JudoErrors.swift
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
 **Amount**
 
 Amount object stores information about an amount and the corresponding currency for a transaction
*/
public struct Amount: ExpressibleByStringLiteral {
    /// The currency ISO Code - GBP is default
    public var currency: Currency = .GBP
    /// The amount to process, to two decimal places
    public var amount: NSDecimalNumber
    
    
    /**
     Initializer for amount
     
     - parameter decimalNumber: a decimal number with the value of an amount to transact
     - parameter currency:      the currency of the amount to transact
     
     - returns: an Amount object
     */
    public init(decimalNumber: NSDecimalNumber, currency: Currency) {
        self.currency = currency
        self.amount = decimalNumber
    }
    
    
    /**
     Initializer for Amount
     
     - parameter amountString: a string with the value of an amount to transact
     - parameter currency:     the currency of the amount to transact
     
     - returns: an Amount object
     */
    public init(amountString: String, currency: Currency) {
        self.amount = NSDecimalNumber(string: amountString)
        self.currency = currency
    }
    
    
    /**
     possible patterns for initializing with a string literal
     
     - 12 GBP
     - 12GBP
     
     - parameter value: a string value holding a currency and an amount
     
     - returns: an Amount object
     */
    init(amount value: String) {
        self.amount = NSDecimalNumber(string: value.substring(to: value.characters.index(value.endIndex, offsetBy: -3)))
        self.currency = Currency(value.substring(from: value.characters.index(value.endIndex, offsetBy: -3)))
    }
    
    public init(stringLiteral value: String) {
        self.amount = NSDecimalNumber(string: value.substring(to: value.characters.index(value.endIndex, offsetBy: -3)))
        self.currency = Currency(value.substring(from: value.characters.index(value.endIndex, offsetBy: -3)))
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.amount = NSDecimalNumber(string: value.substring(to: value.characters.index(value.endIndex, offsetBy: -3)))
        self.currency = Currency(value.substring(from: value.characters.index(value.endIndex, offsetBy: -3)))
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.amount = NSDecimalNumber(string: value.substring(to: value.characters.index(value.endIndex, offsetBy: -3)))
        self.currency = Currency(value.substring(from: value.characters.index(value.endIndex, offsetBy: -3)))
    }
    
}


/// Collection of static identifiers for all supported currencies
public struct Currency {
    /// Raw value of the currency as a String
    public let rawValue: String
    
    /**
     Designated initializer
     
     - parameter fromRaw: raw string value of the currency based on ISO standards
     
     - returns: a Currency object
     */
    public init(_ fromRaw: String) {
        self.rawValue = fromRaw
    }
    
    /// Australian Dollars
    public static let AUD = Currency("AUD")
    /// United Arab Emirates Dirham
    public static let AED = Currency("AED")
    /// Brazilian Real
    public static let BRL = Currency("BRL")
    /// Canadian Dollars
    public static let CAD = Currency("CAD")
    /// Swiss Franks
    public static let CHF = Currency("CHF")
    /// Czech Republic Koruna
    public static let CZK = Currency("CZK")
    /// Danish Krone
    public static let DKK = Currency("DKK")
    /// Euro
    public static let EUR = Currency("EUR")
    /// British Pound
    public static let GBP = Currency("GBP")
    /// Hong Kong Dollar
    public static let HKD = Currency("HKD")
    /// Hungarian Forint
    public static let HUF = Currency("HUF")
    /// Japanese Yen
    public static let JPY = Currency("JPY")
    /// Norwegian Krone
    public static let NOK = Currency("NOK")
    /// New Zealand Dollar
    public static let NZD = Currency("NZD")
    /// Polish Zloty
    public static let PLN = Currency("PLN")
    /// Qatari Rial
    public static let QAR = Currency("QAR")
    /// Saudi Riyal
    public static let SAR = Currency("SAR")
    /// Swedish Krone
    public static let SEK = Currency("SEK")
    /// Singapore dollar
    public static let SGD = Currency("SGD")
    /// United States Dollar
    public static let USD = Currency("USD")
    /// South African Rand
    public static let ZAR = Currency("ZAR")
    /// Unsupported Currency
    public static let XOR = Currency("Unsupported Currency")
}

