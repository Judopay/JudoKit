//
//  Model.swift
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


/// Constants that describe the formatting pattern of given Card Networks
let VISAPattern         = "XXXX XXXX XXXX XXXX"
let AMEXPattern         = "XXXX XXXXXX XXXXX"
let CUPPattern          = "XXXXXX XXXXXXXXXXXXX"
let DinersClubPattern   = "XXXX XXXXXX XXXX"


// These should be computed once and then referenced - O(n)
let maestroPrefixes: [String]      = Array([([Int](56...69)).map({ String($0) }), ["50"]].joined())
let dinersClubPrefixes: [String]   = Array([([Int](300...305)).map({ String($0) }), ["36", "38", "39", "309"]].joined())
let instaPaymentPrefixes: [String] = ([Int](637...639)).map({ String($0) })
let JCBPrefixes: [String]          = ([Int](3528...3589)).map({ String($0) })

// Expression was too complex to be executed in one line 😩😭💥
let masterCardPrefixes: [String]   = {
    let m1: [String] = Array(([Int](2221...2720)).map({ String($0) }))
    let m2: [String] = Array(([Int](51...55)).map({ String($0) }))
    return Array([m1, m2].joined())
}()
let discoverPrefixes: [String]     = {
    let d1: [String] = Array(([Int](644...649)).map({ String($0) }))
    let d2: [String] = Array(([Int](622126...622925)).map({ String($0) }))
    return Array([d1, d2, ["65", "6011"]].joined())
}()


/**
 **Card**
 
 Card objects store all the necessary card information for making transactions
*/
public struct Card {
    
    /// The minimum card length constant
    public static let minimumLength = 12
    /// The maximum card length constant
    public static let maximumLength = 19
    
    internal let _number: String
    
    /// The card number should be submitted without any whitespace or non-numeric characters
    public var number: String {
        get {
            return "****"
        }
        set { }
    }
    /// The expiry date should be submitted as MM/YY
    public let expiryDate: String
    
    internal let _securityCode: String
    
    /// CV2 from the credit card, also known as the card verification value (CVV) or security code. It's the 3 or 4 digit number on the back of your credit card
    public var securityCode: String {
        get {
            return "***"
        }
        set { }
    }
    /// The registered add  ress for the card
    public let address: Address?
    /// The start date if the card is a Maestro
    public let startDate: String?
    /// The issue number if the card is a Maestro
    public let issueNumber: String?
    
    
    /**
     Designated initializer for the Card struct
     
     - parameter number:      The card number (long number)
     - parameter expiryDate:  The expiry date of the card
     - parameter cv2:         The security code number of the card
     - parameter address:     The address of the card holder where the account is registered (AVS)
     - parameter startDate:   In case of transacting with maestro cards, the start date (optional)
     - parameter issueNumber: In case of transacting with maestro cards, the issue number (optional)
     
     - returns: a Card object
     */
    public init(number: String, expiryDate: String, securityCode: String, address: Address? = nil, startDate: String? = nil, issueNumber: String? = nil) {
        self._number = number
        self.expiryDate = expiryDate
        self._securityCode = securityCode
        self.address = address
        self.startDate = startDate
        self.issueNumber = issueNumber
    }
    
    /**
     **Card.Configuration**
     
     Card Configuration consists of a Card Network and a given length
    */
    public struct Configuration {
        /// The network of the configuration
        public let cardNetwork: CardNetwork
        /// The length of the card for this configuration
        public let cardLength: Int
        
        /**
         Designated initializer for a card configuration
         
         - parameter cardNetwork: the card network (eg. Visa, MasterCard or AMEX)
         - parameter cardLength:  the length of the card number (eg. 16 or 19 for Maestro cards)
         
         - returns: a Card.Configuration object
         */
        public init(_ cardNetwork: CardNetwork, _ cardLength: Int) {
            self.cardLength = cardLength
            self.cardNetwork = cardNetwork
        }
        
        
        /**
        Helper method to get a pattern string for a certain configuration
        
        - Returns: a given String with the correct pattern
        */
        public func patternString() -> String? {
            switch self.cardNetwork {
            case .visa, .masterCard, .dankort, .jcb, .instaPayment, .discover:
                return VISAPattern
            case .amex:
                return AMEXPattern
            case .chinaUnionPay, .interPayment, .maestro:
                if self.cardLength == 16 {
                    return VISAPattern
                } else if self.cardLength == 19 {
                    return CUPPattern
                }
                break
            case .dinersClub:
                if self.cardLength == 16 {
                    return VISAPattern
                } else if self.cardLength == 14 {
                    return DinersClubPattern
                }
            default:
                return VISAPattern
            }
            return nil
        }
        
        
        /**
        Helper method to get a placeholder string for a certain configuration
        
        - Returns: a given String as a placeholder
        */
        public func placeholderString() -> String? {
            return self.patternString()?.replacingOccurrences(of: "X", with: "0")
        }
    }
    
}

// MARK: - Card Protocol extensions

extension Card: CustomStringConvertible {
    public var description: String {
        return "number: \(self.number), expiryDate: \(self.expiryDate), securityCode: \(self.securityCode), address: \(String(describing: self.address)), startDate: \(String(describing: self.startDate)), issueNumber: \(String(describing: self.issueNumber))"
    }
}

// MARK: - Card.Configurations Protocol extensions
extension Card.Configuration: Comparable { }


/**
 Equals function for two Card.Configuration objects
 
 - parameter x: left hand side Card.Configuration
 - parameter y: right hand side Card.Configuration
 
 - returns: boolean indicating whether the two objects are equal
 */
public func ==(x: Card.Configuration, y: Card.Configuration) -> Bool {
    return x.cardLength == y.cardLength && x.cardNetwork == y.cardNetwork
}


/**
 Lower function for two Card.Configuration objects
 
 - parameter x: left hand side Card.Configuration
 - parameter y: right hand side Card.Configuration
 
 - returns: boolean indicating whether the lhs objects cardLength is lower than the right hand sides cardLength
 */
public func <(x: Card.Configuration, y: Card.Configuration) -> Bool {
    return x.cardLength < y.cardLength
}


/**
 Lower or equal function for two Card.Configuration objects
 
 - parameter x: left hand side Card.Configuration
 - parameter y: right hand side Card.Configuration
 
 - returns: boolean indicating whether the lhs objects cardLength is lower than or equals the right hand sides cardLength
 */
public func <=(x: Card.Configuration, y: Card.Configuration) -> Bool {
    return x.cardLength <= y.cardLength
}


/**
 Greater function for two Card.Configuration objects
 
 - parameter x: left hand side Card.Configuration
 - parameter y: right hand side Card.Configuration
 
 - returns: boolean indicating whether the lhs objects cardLength is greater than the right hand sides cardLength
 */
public func >(x: Card.Configuration, y: Card.Configuration) -> Bool {
    return x.cardLength > y.cardLength
}


/**
 Greater or equal function for two Card.Configuration objects
 
 - parameter x: left hand side Card.Configuration
 - parameter y: right hand side Card.Configuration
 
 - returns: boolean indicating whether the lhs objects cardLength is greater than or equals the right hand sides cardLength
 */
public func >=(x: Card.Configuration, y: Card.Configuration) -> Bool {
    return x.cardLength >= y.cardLength
}

// MARK - Additional card helpers

/**
The CardType enum is a value type for CardNetwork to further identify card types

- Debit:   Debit Card type
- Credit:  Credit Card type
- Unknown: Unknown Card type
*/
public enum CardType: Int {
    /// Debit Card type
    case debit
    /// Credit Card type
    case credit
    /// Unknown Card type
    case unknown
}


/**
The CardNetwork enum depicts the Card Network type of a given Card object

- Visa:             Visa Card Network
- MasterCard:       MasterCard Network
- AMEX:             American Express Card Network
- DinersClub:       Diners Club Network
- Maestro:          Maestro Card Network
- ChinaUnionPay:    China UnionPay Network
- Discover:         Discover Network
- InterPayment:     InterPayment Network
- InstaPayment:     InstaPayment Network
- JCB:              JCB Network
- Dankort:          Dankort Network
- UATP:             UATP Network
- Unknown:          Unknown
*/
public enum CardNetwork: Int64 {
    
    /// Unknown
    case unknown = 0
    /// Visa Card Network
    case visa = 1
    /// MasterCard Network
    case masterCard = 2
    /// Visa Electron Network
    case visaElectron = 3
    /// Switch Network
    case `switch` = 4
    /// Solo Network
    case solo = 5
    /// Laser Network
    case laser = 6
    /// China UnionPay Network
    case chinaUnionPay = 7
    /// American Express Card Network
    case amex = 8
    /// JCB Network
    case jcb = 9
    /// Maestro Card Network
    case maestro = 10
    /// Visa Debit Card Network
    case visaDebit = 11
    /// MasterCard Network
    case masterCardDebit = 12
    /// Visa Purchasing Network
    case visaPurchasing = 13
    /// Discover Network
    case discover = 14
    /// Carnet Network
    case carnet = 15
    /// Carte Bancaire Network
    case carteBancaire = 16
    /// Diners Club Network
    case dinersClub = 17
    /// Elo Network
    case elo = 18
    /// Farmers Card Network
    case farmersCard = 19
    /// Soriana Network
    case soriana = 20
    /// Private Label Card Network
    case privateLabelCard = 21
    /// Q Card Network
    case qCard = 22
    /// Style Network
    case style = 23
    /// True Rewards Network
    case trueRewards = 24
    /// UATP Network
    case uatp = 25
    /// Bank Card Network
    case bankCard = 26
    /// Banamex Costco Network
    case banamex_Costco = 27
    /// InterPayment Network
    case interPayment = 28
    /// InstaPayment Network
    case instaPayment = 29
    /// Dankort Network
    case dankort = 30
    
    
    /**
     The string value of the receiver
     
     - returns: a string describing the receiver
     */
    public func stringValue() -> String {
        switch self {
        case .unknown:
            return "Unknown"
        case .visa, .visaDebit, .visaElectron, .visaPurchasing:
            return "Visa"
        case .masterCard, .masterCardDebit:
            return "MasterCard"
        case .switch:
            return "Switch"
        case .solo:
            return "Solo"
        case .laser:
            return "Laser"
        case .chinaUnionPay:
            return "China UnionPay"
        case .amex:
            return "AMEX"
        case .jcb:
            return "JCB"
        case .maestro:
            return "Maestro"
        case .discover:
            return "Discover"
        case .carnet:
            return "Carnet"
        case .carteBancaire:
            return "CarteBancaire"
        case .dinersClub:
            return "Diners Club"
        case .elo:
            return "Elo"
        case .farmersCard:
            return "FarmersCard"
        case .soriana:
            return "Soriana"
        case .privateLabelCard:
            return "PrivateLabelCard"
        case .qCard:
            return "QCard"
        case .style:
            return "Style"
        case .trueRewards:
            return "TrueRewards"
        case .uatp:
            return "UATP"
        case .bankCard:
            return "BankCard"
        case .banamex_Costco:
            return "BanamexCostco"
        case .interPayment:
            return "InterPayment"
        case .instaPayment:
            return "InstaPayment"
        case .dankort:
            return "Dankort"
        }
    }
    
    
    /**
    The prefixes determine which card network a number belongs to, this method provides an array with one or many prefixes for a given type
    
    - Returns: an Array containing all the possible prefixes for a type
    */
    public func prefixes() -> [String] {
        switch self {
        case .visa, .visaDebit, .visaElectron, .visaPurchasing:
            return ["4"]
        case .masterCard, .masterCardDebit:
            return masterCardPrefixes
        case .amex:
            return ["34", "37"]
        case .dinersClub:
            return dinersClubPrefixes
        case .maestro:
            return maestroPrefixes
        case .chinaUnionPay:
            return ["62"]
        case .discover:
            return discoverPrefixes
        case .interPayment:
            return ["636"]
        case .instaPayment:
            return instaPaymentPrefixes
        case .jcb:
            return JCBPrefixes
        case .dankort:
            return ["5019"]
        case .uatp:
            return ["1"]
        default:
            return []
        }
    }
    
    
    /**
     The card network type for a given card number string and constrained to a set of networks
     
     - parameter string:   the card number as a string
     - parameter networks: the networks allowed for detection
     
     - returns: a CardNetwork if the prefix matches a given set of CardNetworks or CardNetwork.Unknown
     */
    public static func networkForString(_ string: String, constrainedToNetworks networks: [CardNetwork]) -> CardNetwork {
        let result = networks.filter({ $0.prefixes().filter({ string.hasPrefix($0) }).count > 0 })
        //Case when maestro and china union pay are returned by the filter
        if result.count == 2 {
            return result[1]
        }
        if result.count == 1 {
            return result[0]
        }
        return CardNetwork.unknown
    }
    
    
    /**
     The card network type for a given card number
     
     - parameter string: the card number as a string
     
     - returns: a CardNetwork if the prefix matches any CardNetwork prefix
     */
    public static func networkForString(_ string: String) -> CardNetwork {
        let allNetworks: [CardNetwork] = [.visa, .masterCard, .amex, .dinersClub, .maestro, .chinaUnionPay, .discover, .interPayment, .instaPayment, .jcb, .dankort, .uatp]
        return self.networkForString(string, constrainedToNetworks: allNetworks)
    }
    

    /**
    Security code name for a certain card
    
    - Returns: a String for the title of a certain security code
    */
    public func securityCodeTitle() -> String {
        switch self {
        case .visa:
            return "CVV2"
        case .masterCard:
            return "CVC2"
        case .amex:
            return "CID"
        case .chinaUnionPay:
            return "CVN2"
        case .discover:
            return "CID"
        case .jcb:
            return "CAV2"
        case .unknown:
            return "CVV"
        default:
            return "CVV"
        }
    }
    
    
    /**
    Security code length for a card type
    
    - Returns: an Int with the code length
    */
    public func securityCodeLength() -> Int {
        switch self {
        case .amex:
            return 4
        default:
            return 3
        }
    }
    
}


// MARK - CardDetails

/**
 **CardDetails**
 
 The CardDetails object stores information that is returned from a successful payment or pre-auth
 
 This class also implements the `NSCoding` protocol to enable serialization for persistency
*/
open class CardDetails: NSObject, NSCoding {
    /// The last four digits of the card used for this transaction
    open var cardLastFour: String?
    /// Expiry date of the card used for this transaction formatted as a two digit month and year i.e. MM/YY
    open let endDate: String?
    /// Can be used to charge future payments against this card
    open let cardToken: String?
    
    fileprivate var _cardNetwork: CardNetwork?
    /// The computed card network
    open var cardNetwork: CardNetwork? {
        get {
            if let computedCardNetwork = self._cardNumber?.cardNetwork() , self._cardNetwork == .unknown && self._cardNumber != nil {
                self._cardNetwork = computedCardNetwork
            }
            return self._cardNetwork
        }
        set {
            self._cardNetwork = newValue
        }
    }
    
    internal let _cardNumber: String?
    
    /// The card number if available
    open var cardNumber: String? {
        get {
            return self.formattedLastFour()
        }
        set {}
    }
    
    open var isCardNumberValid: Bool {
        get {
            return self._cardNumber?.isCardNumberValid() ?? false
        }
        set { }
    }
    
    /// Description string for print functions
    override open var description: String {
        let formattedLastFour = self.formattedLastFour() ?? "N/A"
        let formattedEndDate = self.formattedEndDate() ?? "N/A"
        let cardNetworkString = self.cardNetwork?.stringValue() ?? "N/A"
        return "cardLastFour: \(formattedLastFour), endDate: \(formattedEndDate), cardNetwork: \(cardNetworkString)"
    }
    
    
    /**
     Convenience initializer that takes in a card number and an expiry date in case a transaction should be made with pre-known information
     
     - parameter cardNumber: a card number as a String
     - parameter endDate:    an enddate in MM/YY format as a String
     
     - returns: a CardDetails object
     */
    public convenience init(cardNumber: String?, expiryMonth: Int?, expiryYear: Int?) {
        var dict = JSONDictionary()
        dict["cardNumber"] = cardNumber as AnyObject?
        
        guard let expiryMonth = expiryMonth, let expiryYear = expiryYear else { self.init(dict); return }
        
        var dateComponents = DateComponents()
        dateComponents.month = expiryMonth
        dateComponents.year = expiryYear
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        if let date = gregorian.date(from: dateComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            let dateString = dateFormatter.string(from: date)
            dict["endDate"] = dateString as AnyObject?
        }
        
        self.init(dict)
    }
    
    
    /**
     Designated initializer for Card Details
     
     - parameter dict: all parameters as a dictionary
     
     - returns: a CardDetails object
     */
    public init(_ dict: JSONDictionary?) {
        self.cardLastFour = dict?["cardLastfour"] as? String
        self.endDate = dict?["endDate"] as? String
        self.cardToken = dict?["cardToken"] as? String
        self._cardNumber = dict?["cardNumber"] as? String
        super.init()
        if let cardType = dict?["cardType"] as? Int {
            self.cardNetwork = CardNetwork(rawValue: Int64(cardType))
        } else {
            self.cardNetwork = .unknown
        }
    }
    
    
    /**
     Initialise the CardDetails object with a coder
     
     - parameter decoder: the decoder object
     
     - returns: a CardDetails object or nil
     */
    public required init?(coder decoder: NSCoder) {
        let cardLastFour = decoder.decodeObject(forKey: "cardLastFour") as? String?
        let endDate = decoder.decodeObject(forKey: "endDate") as? String?
        let cardToken = decoder.decodeObject(forKey: "cardToken") as? String?
        let cardNetwork = decoder.decodeInt64(forKey: "cardNetwork")
        
        self.cardLastFour = cardLastFour ?? nil
        self.endDate = endDate ?? nil
        self.cardToken = cardToken ?? nil
        self._cardNumber = nil
        super.init()
        self.cardNetwork = CardNetwork(rawValue: Int64(cardNetwork))
    }
    
    
    /**
     Encode the receiver CardDetails object
     
     - parameter aCoder: the Coder
     */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cardLastFour, forKey: "cardLastFour")
        aCoder.encode(self.endDate, forKey: "endDate")
        aCoder.encode(self.cardToken, forKey: "cardToken")
        if let cardNetwork = self.cardNetwork {
            aCoder.encode(cardNetwork.rawValue, forKey: "cardNetwork")
        } else {
            aCoder.encode(0, forKey: "cardNetwork")
        }
    }
    
    
    /**
     Get a formatted string with the right whitespacing for a certain card type
     
     - returns: a string with the last four digits with the right format
     */
    open func formattedLastFour() -> String? {
        if self.cardLastFour == nil && self._cardNumber == nil {
            return nil
        } else if let cardNumber = self._cardNumber {
            self.cardLastFour = cardNumber.substring(from: cardNumber.characters.index(cardNumber.endIndex, offsetBy: -4))
        }
        
        guard let cardNetwork = self.cardNetwork else { return "**** \(cardLastFour!)" }
        
        switch cardNetwork {
        case .amex:
            return "**** ****** *\(cardLastFour!)"
        default:
            return "**** **** **** \(cardLastFour!)"
        }
    }
    
    
    /**
     Get a formatted string with the right slash for a date
     
     - returns: a string with the date as shown on the credit card with the right format
     */
    open func formattedEndDate() -> String? {
        guard let ed = self.endDate else { return nil }
        
        if ed.characters.count == 4 {
            // backend returns the end date without a slash so for UI purposes we have to add it
            let prefix = ed.substring(to: ed.characters.index(ed.startIndex, offsetBy: 2))
            let suffix = ed.substring(from: ed.characters.index(ed.endIndex, offsetBy: -2))
            return "\(prefix)/\(suffix)"
        } else {
            return ed
        }
    }
    
}

