//
//  Model.swift
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


/// Constants that describe the formatting pattern of given Card Networks
let VISAPattern         = "XXXX XXXX XXXX XXXX"
let AMEXPattern         = "XXXX XXXXXX XXXXX"
let CUPPattern          = "XXXXXX XXXXXXXXXXXXX"
let DinersClubPattern   = "XXXX XXXXXX XXXX"


// these should be computed once and then referenced - O(n)
let masterCardPrefixes          = ([Int](2221...2720)).map({ String($0) }) + ([Int](51...55)).map { String($0) }
let maestroPrefixes             = ([Int](56...69)).map({ String($0) }) + ["50"]
let dinersClubPrefixes          = ([Int](300...305)).map({ String($0) }) + ["36", "38", "39", "309"]
let instaPaymentPrefixes        = ([Int](637...639)).map({ String($0) })
let JCBPrefixes                 = ([Int](3528...3589)).map({ String($0) })

// expression was too complex to be executed in one line 😩😭💥
let discoverPrefixes: [String]  = {
    let discover = ([Int](644...649)).map({ String($0) }) + ([Int](622126...622925)).map({ String($0) })
    return discover + ["65", "6011"]
    }()


/**
*  the Card object stores all the necessary card information to make a transaction
*/
public class Card: NSObject {
    
    /// the minimum card length constant
    public static let minimumLength = 12
    /// the maximum card length constant
    public static let maximumLength = 19
    
    /// The card number should be submitted without any whitespace or non-numeric characters
    public let number: String
    /// The expiry date should be submitted as MM/YY
    public let expiryDate: String
    /// CV2 from the credit card, also known as the card verification value (CVV) or security code. It's the 3 or 4 digit number on the back of your credit card
    public let cv2: String
    /// The registered address for the card
    public let address: Address?
    /// The start date if the card is a Maestro
    public let startDate: String?
    /// The issue number if the card is a Maestro
    public let issueNumber: String?
    
    
    /**
     designated initialiser for the Card struct
     
     - parameter number:      the card number (long number)
     - parameter expiryDate:  the expiry date of the card
     - parameter cv2:         the security code number of the card
     - parameter address:     the address of the card holder where the account is registered (AVS)
     - parameter startDate:   in case of transacting with maestro cards, the start date (optional)
     - parameter issueNumber: in case of transacting with maestro cards, the issue number (optional)
     
     - returns: a Card object
     */
    public init(number: String, expiryDate: String, cv2: String, address: Address?, startDate: String? = nil, issueNumber: String? = nil) {
        self.number = number
        self.expiryDate = expiryDate
        self.cv2 = cv2
        self.address = address
        self.startDate = startDate
        self.issueNumber = issueNumber
    }
    
    /**
    *  Card Configuration consists of a Card Network and a given length
    */
    public class Configuration: NSObject {
        /// the network of the configuration
        public let cardNetwork: CardNetwork
        /// the length of the card for this configuration
        public let cardLength: Int
        
        /**
         designated initialiser for a card configuration
         
         - parameter cardNetwork: the card network (eg. Visa, MasterCard or AMEX)
         - parameter cardLength:  the length of the card number (eg. 16 or 19 for Maestro cards)
         
         - returns: a Card.Configuration object
         */
        public init(_ cardNetwork: CardNetwork, _ cardLength: Int) {
            self.cardLength = cardLength
            self.cardNetwork = cardNetwork
        }
        
        
        /**
        helper method to get a pattern string for a certain configuration
        
        - Returns: a given String with the correct pattern
        */
        public func patternString() -> String? {
            switch self.cardNetwork {
            case .Visa, .MasterCard, .Dankort, .JCB, .InstaPayment, .Discover:
                return VISAPattern
            case .AMEX:
                return AMEXPattern
            case .ChinaUnionPay, .InterPayment, .Maestro:
                if self.cardLength == 16 {
                    return VISAPattern
                } else if self.cardLength == 19 {
                    return CUPPattern
                }
                break
            case .DinersClub:
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
        helper method to get a placeholder string for a certain configuration
        
        - Returns: a given String as a placeholder
        */
        public func placeholderString() -> String? {
            return self.patternString()?.stringByReplacingOccurrencesOfString("X", withString: "0")
        }
    }
}




/**
the CardType enum is a value type for CardNetwork to further identify card types

- Debit:   Debit Card type
- Credit:  Credit Card type
- Unknown: Unknown Card type
*/
@objc public enum CardType: Int {
    /// Debit Card type
    case Debit
    /// Credit Card type
    case Credit
    /// Unknown Card type
    case Unknown
}


/**
the CardNetwork enum depicts the Card Network type of a given Card object

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
@objc public enum CardNetwork: Int {
    /// Visa Card Network
    case Visa
    /// MasterCard Network
    case MasterCard
    /// American Express Card Network
    case AMEX
    /// Diners Club Network
    case DinersClub
    /// Maestro Card Network
    case Maestro
    /// China UnionPay Network
    case ChinaUnionPay
    /// Discover Network
    case Discover
    /// InterPayment Network
    case InterPayment
    /// InstaPayment Network
    case InstaPayment
    /// JCB Network
    case JCB
    /// Dankort Network
    case Dankort
    /// UATP Network
    case UATP
    /// Unknown
    case Unknown
    
    /**
     the string value of the receiver
     
     - returns: a string describing the receiver
     */
    public func stringValue() -> String {
        switch self {
        case .Visa:
            return "Visa"
        case .MasterCard:
            return "MasterCard"
        case .AMEX:
            return "AMEX"
        case .DinersClub:
            return "Diners Club"
        case .Maestro:
            return "Maestro"
        case .ChinaUnionPay:
            return "China UnionPay"
        case .Discover:
            return "Discover"
        case .InterPayment:
            return "InterPayment"
        case .InstaPayment:
            return "InstaPayment"
        case .JCB:
            return "JCB"
        case .Dankort:
            return "Dankort"
        case .UATP:
            return "UATP"
        case .Unknown:
            return "Unknown"
        }
    }
    
    
    /**
    the prefixes determine which card network a number belongs to, this method provides an array with one or many prefixes for a given type
    
    - Returns: an Array containing all the possible prefixes for a type
    */
    public func prefixes() -> [String] {
        switch self {
        case .Visa:
            return ["4"]
        case .MasterCard:
            return masterCardPrefixes
        case .AMEX:
            return ["34", "37"]
        case .DinersClub:
            return dinersClubPrefixes
        case .Maestro:
            return maestroPrefixes
        case .ChinaUnionPay:
            return ["62"]
        case .Discover:
            return discoverPrefixes
        case .InterPayment:
            return ["636"]
        case .InstaPayment:
            return instaPaymentPrefixes
        case .JCB:
            return JCBPrefixes
        case .Dankort:
            return ["5019"]
        case .UATP:
            return ["1"]
        case .Unknown:
            return []
        }
    }
    
    
    /**
     the card network type for a given card number string and constrained to a set of networks
     
     - parameter string:   the card number as a string
     - parameter networks: the networks allowed for detection
     
     - returns: a CardNetwork if the prefix matches a given set of CardNetworks or CardNetwork.Unknown
     */
    public static func networkForString(string: String, constrainedToNetworks networks: [CardNetwork]) -> CardNetwork {
        let result = networks.filter({ $0.prefixes().filter({ string.beginsWith($0) }).count > 0 })
        if result.count == 1 {
            return result[0]
        }
        return CardNetwork.Unknown
    }
    
    
    /**
     the card network type for a given card number
     
     - parameter string: the card number as a string
     
     - returns: a CardNetwork if the prefix matches any CardNetwork prefix
     */
    public static func networkForString(string: String) -> CardNetwork {
        let allNetworks: [CardNetwork] = [.Visa, .MasterCard, .AMEX, .DinersClub, .Maestro, .ChinaUnionPay, .Discover, .InterPayment, .InstaPayment, .JCB, .Dankort, .UATP]
        return self.networkForString(string, constrainedToNetworks: allNetworks)
    }
    

    /**
    security code name for a certain card
    
    - Returns: a String for the title of a certain security code
    */
    public func securityCodeTitle() -> String {
        switch self {
        case .Visa:
            return "CVV2"
        case .MasterCard:
            return "CVC2"
        case .AMEX:
            return "CIDV"
        case .ChinaUnionPay:
            return "CVN2"
        case .Discover:
            return "CID"
        case .JCB:
            return "CAV2"
        case .Unknown:
            return "CVV"
        default:
            return "CVV"
        }
    }
    
    
    /**
    security code length for a card type
    
    - Returns: an Int with the code length
    */
    public func securityCodeLength() -> Int {
        switch self {
        case .AMEX:
            return 4
        default:
            return 3
        }
    }
    
}


/**
*  the CardDetails object stores information that is returned from a successful payment or preAuth
*/
public class CardDetails: NSObject {
    /// The last four digits of the card used for this transaction.
    public let cardLastFour: String?
    /// Expiry date of the card used for this transaction formatted as a two digit month and year i.e. MM/YY.
    public let endDate: String?
    /// Can be used to charge future payments against this card.
    public let cardToken: String?
    /// the card network
    public let cardNetwork: CardNetwork?
    
    
    /**
     designated initialiser for Card Details
     
     - parameter dict: all parameters as a dictionary
     
     - returns: a CardDetails object
     */
    public init(_ dict: JSONDictionary?) {
        self.cardLastFour = dict?["cardLastfour"] as? String
        self.endDate = dict?["endDate"] as? String
        self.cardToken = dict?["cardToken"] as? String
        self.cardNetwork = nil // TODO: parse dict["cardType"] into CardNetwork
    }
}


extension String {
    
    /**
    helper method to check wether the string begins with another given string
    
    - Parameter str: prefix string to compare
    
    - Returns: boolean indicating wether the prefix matches or not
    */
    func beginsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }
    
}

