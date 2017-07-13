//
//  String+Card.swift
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

public extension String {
    
    
    /**
    Returns a string that matches the format of the number on the card itself based on the spacing pattern
    
    - Parameter configurations: The valid configurations to check for when
    
    - Returns: A formatted String that matches the credit card format
    
    - Throws CardLengthMismatchError: If amount of characters is longer than the maximum character number
    - Throws InvalidCardNumber: If the card number is invalid
    */
    func cardPresentationString(_ configurations: [Card.Configuration]) throws -> String {
        
        let strippedSelf = self.strippedWhitespaces
        
        // Do not continue if the string is empty or out of range
        if strippedSelf.characters.count == 0 {
            return ""
        } else if strippedSelf.characters.count > Card.maximumLength {
            throw JudoError(.cardLengthMismatchError)
        } else if !strippedSelf.isNumeric() {
            throw JudoError(.invalidEntry)
        }
        
        // Make sure to only check validity for the necessary networks
        let cardNetwork = strippedSelf.cardNetwork()
        
        // Only try to format if a specific card number has been recognized
        if cardNetwork == .unknown {
            return strippedSelf
        }
        
        // Special secret ingredient
        // 1. Filter out networks that don't match the entered card numbers
        // 2. Map all remaining strings while removing all optional values
        // 3. Check if the current string has already passed any valid card number lengths
        let patterns = configurations.filter({ $0.cardNetwork == cardNetwork }).flatMap({ $0.patternString() })
        
        let cardLengthMatchedPatterns = patterns.filter({ $0.strippedWhitespaces.characters.count >= strippedSelf.characters.count })
        
        if cardLengthMatchedPatterns.count == 0 {
            // If no patterns are left - the entered number is invalid
            var message = "We don't accept "
            if cardLengthMatchedPatterns.count != patterns.count {
                message += "\(strippedSelf.characters.count)-digit \(cardNetwork.stringValue()) cards"
            } else {
                message += "\(cardNetwork.stringValue()), please use other cards"
            }
            throw JudoError(.invalidCardNetwork, message)
        }
        
        // Retrieve the shortest pattern that is left and start moving the characters across
        let patternString = patterns.sorted(by: <)[0]
        
        var patternIndex = patternString.startIndex
        
        var retString = ""
        
        for element in strippedSelf.characters {
            if patternString.characters[patternIndex] == "X" {
                patternIndex = patternString.index(patternIndex, offsetBy: 1)
                retString = retString + String(element)
            } else {
                patternIndex = patternString.index(patternIndex, offsetBy: 2)
                retString = retString + " \(element)"
            }
        }
        
        return retString
    }
    
    
    /**
    See https://en.wikipedia.org/wiki/Bank_card_number
    This method will not do any validation - just a check for numbers from at least 1 character and return an assumption about what the card might be.
    
    - Parameter configurations: Only return valid responses for the given configurations
    
    - Returns: CardNetwork object
    */
    func cardNetwork(constrainedToConfigurations configurations: [Card.Configuration]) -> CardNetwork? {
        let constrainedNetworks = configurations.map { $0.cardNetwork }
        return CardNetwork.networkForString(self.strippedWhitespaces, constrainedToNetworks: constrainedNetworks)
    }
    
    
    /**
    See https://en.wikipedia.org/wiki/Bank_card_number
    This method will not do any validation - just a check for numbers from at least 1 character and return an assumption about what the card might be.
    
    - Returns: CardNetwork object
    */
    func cardNetwork() -> CardNetwork {
        return CardNetwork.networkForString(self.strippedWhitespaces)
    }
    
    
    /**
    Check if the string is representing a valid credit card number
    
    - Returns: True if the string is a valid credit card number
    */
    func isCardNumberValid() -> Bool {
        
        let network = self.cardNetwork()
        let strippedSelf = self.strippedWhitespaces
        
        if strippedSelf.range(of: ".") != nil {
            return false
        }
        
        if strippedSelf.isLuhnValid() {
            let strippedSelfCount = strippedSelf.characters.count
            
            switch network {
            case .uatp, .amex:
                return strippedSelfCount == 15
            case .visa:
                return strippedSelfCount == 13 || strippedSelfCount == 16
            case .masterCard, .dankort, .jcb, .instaPayment, .discover, .masterCardDebit:
                return strippedSelfCount == 16
            case .maestro:
                return (12...19).contains(strippedSelfCount)
            case .dinersClub:
                return strippedSelfCount == 14
            case .chinaUnionPay, .interPayment:
                return (16...19).contains(strippedSelfCount)
            default:
                return false
            }
        }
        return false

    }
    
}
