//
//  Card.swift
//  JudoKit
//
//  Created by Hamon Riazy on 13/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import Foundation
import Judo

public struct Card {
    
    
    /**
    see https://en.wikipedia.org/wiki/Bank_card_number
    This method will not do any validation - just a check for numbers from at least 1 character and return an assumption about what the card might be
    
    - Parameter cardNumber: the cardnumber to check for
    
    - Returns: CardNetwork object
    */
    static func cardNetwork(cardNumber: String) -> CardNetwork {
        
        // need at least one characters to make an assumption about the network
        if cardNumber.characters.count < 1 {
            return .Unknown
        }

        // Visa
        if cardNumber.characters.first == "4" {
            return .Visa(.Unknown)
        }
        
        // UATP
        if cardNumber.characters.first == "1" {
            return .UATP
        }
        
        
        // need at least two characters to make any additional assumptions if it does not start with a 4 (VISA) or 1 (UATP)
        if cardNumber.characters.count < 2 {
            return .Unknown
        }
        
        // prepare
        let firstTwo = cardNumber.substringToIndex(advance(cardNumber.startIndex, 2))
        
        // AMEX begins with 34 & 37
        let amexCardPrefixRange = ["34", "37"]
        if amexCardPrefixRange.contains(firstTwo) {
            return .AMEX
        }
        
        // some Diners Club with 36, 38 and 39
        let dinersTwoPrefixRange = ["36", "38", "39"]
        if dinersTwoPrefixRange.contains(firstTwo) {
            return .DinersClub
        }
        
        // China UnionPay starts with 62
        if firstTwo == "62" {
            return .ChinaUnionPay
        }
        
        // MasterCard begins with 51 - 55
        let masterCardPrefixRange = (51...55).map { String($0) }
        if masterCardPrefixRange.contains(firstTwo) {
            return .MasterCard(.Unknown)
        }
        
        // Discover prefix with two characters
        if firstTwo == "65" {
            return .Discover
        }
        
        // Maestro has 50, 56-69
        let maestroCardPrefixRange = [56...69].map { String($0) }
        if maestroCardPrefixRange.contains(firstTwo) {
            return .Maestro
        }
        
        // need at least three characters to make any additional assumptions if it didnt match any of the previous checks
        if cardNumber.characters.count < 3 {
            return .Unknown
        }

        // prepare
        let firstThree = cardNumber.substringToIndex(advance(cardNumber.startIndex, 3))
        
        // other Diners Club 300-305 / 309
        var dinersPrefixRange = (300...305).map { String($0) }
        dinersPrefixRange.append("309")
        if dinersPrefixRange.contains(firstThree) {
            return .DinersClub
        }
        
        
        // Discover 644-649
        let discoverPrefixRange = (644...649).map { String($0) }
        if discoverPrefixRange.contains(firstThree) {
            return .Discover
        }
        
        
        // need at least four characters to make any additional assumptions if it didnt match any of the previous checks
        if cardNumber.characters.count < 4 {
            return .Unknown
        }
        
        // prepare
        let firstFour = cardNumber.substringToIndex(advance(cardNumber.startIndex, 4))
        
        // Discover 6011
        if firstFour == "6011" {
            return .Discover
        }
        
        // Discover 622126-622925
        
        // none of the patterns did match
        return .Unknown
    }
    
    static func isCardNumberValid(cardNumber: String) -> Bool {
        return true
    }
    
}
