//
//  Payment.swift
//  Judo
//
//  Copyright (c) 2015 Alternative Payments Ltd
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
import Judo


let defaultCardConfigurations = [Card.Configuration(.Visa(.Unknown), 16),
                                Card.Configuration(.MasterCard(.Unknown), 16),
                                Card.Configuration(.AMEX, 15)]


public extension String {
    
    /// string by stripping whitespaces
    public var stripped: String {
        get {
            return self.stringByReplacingOccurrencesOfString(" ", withString: "")
        }
        set {
            // do nothing
        }
    }
    
    
    /**
    returns a string that matches the format of the number on the card itself based on the spacing pattern
    
    - Parameter configurations: the valid configurations to check for when
    
    - Returns: a formatted String that matches the credit card format
    
    - Throws CardLengthMismatchError: if amount of characters is longer than the maximum character number
    - Throws InvalidCardNumber: if the card number is invalid
    */
    func cardPresentationString(configurations: [Card.Configuration]?) throws -> String {
        
        // TODO: check for prefixes in the given configurations
        
        var config = defaultCardConfigurations
        
        if let configurations = configurations {
            config = configurations
        }
        
        let strippedSelf = self.stripped

        // do not continue if the string is empty or out of range
        if strippedSelf.characters.count == 0 {
            return ""
        } else if strippedSelf.characters.count > Card.maximumLength {
            throw JudoError.CardLengthMismatchError
        } else if !strippedSelf.isNumeric() {
            throw JudoError.InvalidEntry
        }
        
        // make sure to only check validity for the necessary networks
        let cardNetwork = strippedSelf.cardNetwork(constrainedToConfigurations: config)
        
        // only try to format if a specific card number has been recognized
        if cardNetwork == .Unknown {
            return strippedSelf
        }
        
        // special secret ingredient
        // 1. filter out networks that dont match the entered card numbers
        // 2. map all remaining strings while removing all optional values
        // 3. check if the current string has already passed any valid Card number lengths
        let patterns = config.filter({ $0.cardNetwork == cardNetwork }).flatMap({ $0.patternString() }).filter({ $0.stripped.characters.count > strippedSelf.characters.count })
        
        if patterns.count == 0 {
            // if no patterns are left - the entered number is invalid
            throw JudoError.InvalidCardNumber
        }
        
        print("patterns: \(patterns)")
        // retrieve the shortest pattern that is left and start moving the characters across
        let patternString = patterns.sort({ $0.characters.count < $1.characters.count })[0]
        print("pattern: \(patternString)")
        
        var patternIndex = patternString.startIndex
        
        var retString = ""
        
        for element in strippedSelf.characters {
            if patternString.characters[patternIndex] == "X" {
                patternIndex = patternIndex.advancedBy(1)
                retString = retString + String(element)
            } else {
                patternIndex = patternIndex.advancedBy(2)
                retString = retString + " \(element)"
            }
        }
        
        return retString
    }
    
    
    /**
    see https://en.wikipedia.org/wiki/Bank_card_number
    This method will not do any validation - just a check for numbers from at least 1 character and return an assumption about what the card might be
    
    - Parameter configurations: only return valid responses for the given configurations
    
    - Returns: CardNetwork object
    */
    func cardNetwork(constrainedToConfigurations configurations: [Card.Configuration]) -> CardNetwork? {
        let constrainedNetworks = configurations.map { $0.cardNetwork }
        return CardNetwork.networkForString(self.stripped, constrainedToNetworks: constrainedNetworks)
    }
    
    
    /**
    see https://en.wikipedia.org/wiki/Bank_card_number
    This method will not do any validation - just a check for numbers from at least 1 character and return an assumption about what the card might be
    
    - Returns: CardNetwork object
    */
    func cardNetwork() -> CardNetwork {
        return CardNetwork.networkForString(self.stripped)
    }
    
    
    /**
    check if the string is representing a valid credit card number
    
    - Returns: true if the string is a valid credit card number
    */
    func isCardNumberValid() -> Bool {
        
        let network = self.cardNetwork()
        let strippedSelf = self.stripped
        
        if strippedSelf.isLuhnValid() {
            let strippedSelfCount = strippedSelf.characters.count
            
            switch network {
            case .UATP, .AMEX:
                return strippedSelfCount == 15
            case .Visa(.Debit), .Visa(.Credit), .Visa(.Unknown):
                return strippedSelfCount == 13 || strippedSelfCount == 16
            case .MasterCard(.Debit), .MasterCard(.Credit), .MasterCard(.Unknown), .Dankort, .JCB, .InstaPayment, .Discover:
                return strippedSelfCount == 16
            case .Maestro:
                return (12...19).contains(strippedSelfCount)
            case .DinersClub:
                return strippedSelfCount == 14
            case .ChinaUnionPay, .InterPayment:
                return (16...19).contains(strippedSelfCount)
            case .Unknown:
                return false
            }
        }
        return false

    }
    
    
    func isLuhnValid() -> Bool {
        guard self.isNumeric() else {
            return false
        }
        let reversedInts = self.characters.reverse().map { Int(String($0)) }
        return reversedInts.enumerate().reduce(0) { (sum, val) in
            let odd = val.index % 2 == 1
            return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
            } % 10 == 0
    }
    
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    
}
