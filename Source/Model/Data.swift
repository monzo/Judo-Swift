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


/**
*  the Amount object stores information regarding the amount and currency for a transaction
*/
public struct Amount {
    /// The currency ISO Code - GBP is default
    public var currency: String = "GBP"
    /// The amount to process, to two decimal places
    public var amount: Double
    
    init(_ amount: Double, _ currency: String) {
        self.currency = currency
        self.amount = amount
    }
    
    init?(_ amount: Double?) {
        guard let amount = amount else { return nil }
        self.amount = amount
    }
    
    init(_ amount: Double) {
        self.amount = amount
    }
    
    init(_ amount: Int) {
        self.amount = Double(amount)
    }
    
    init(_ amount: UInt) {
        self.amount = Double(amount)
    }
    
    init(_ amount: Float) {
        self.amount = Double(amount)
    }
}


/**
*  the Address object stores information around the address that is related to a card
*/
public struct Address {
    public let line1, line2, line3, town, postCode: String?
    
    func dictionaryRepresentation() -> NSDictionary {
        let dict = NSMutableDictionary()
        if let line1 = self.line1 {
            dict.setValue(line1, forKey: "line1")
        }
        if let line2 = self.line2 {
            dict.setValue(line2, forKey: "line2")
        }
        if let line3 = self.line3 {
            dict.setValue(line3, forKey: "line3")
        }
        if let town = self.town {
            dict.setValue(town, forKey: "town")
        }
        if let postCode = self.postCode {
            dict.setValue(postCode, forKey: "postCode")
        }
        return dict.copy() as! NSDictionary
    }
}


/**
*  the Reference object is supposed to simplify storing reference data like consumer or payment references
*/
public struct Reference {
    /// Your reference for this consumer
    public let yourConsuerReference: String
    /// Your reference for this payment
    public let yourPaymentReference: String
    /// An object containing any additional data you wish to tag this payment with. The property name and value are both limited to 50 characters, and the whole object cannot be more than 1024 characters
    public let yourPaymentMetaData: [String : String]?
}


/**
*  the Card object stores all the necessary card information to make a transaction
*/
public struct Card {
    /// The card number should be submitted without any whitespace or non-numeric characters
    public let number: String
    /// The expiry date should be submitted as MM/YY
    public let expiryDate: String
    /// CV2 from the credit card, also known as the card verification value (CVV) or security code. It's the 3 or 4 digit number on the back of your credit card
    public let cv2: String
    /// The registered address for the card
    public let address: Address?
    
}


/**
the CardType enum is a value type for CardNetwork to further identify card types

- Debit:   Debit Card type
- Credit:  Credit Card type
- Unknown: Unknown Card type
*/
public enum CardType {
    case Debit, Credit, Unknown
}


/**
the CardNetwork enum depicts the Card Network type of a given Card object

- Visa:       Visa Card Network
- MasterCard: MasterCard Network
- AMEX:       American Express Card Network
*/
public enum CardNetwork: Equatable {
    case Visa(CardType), MasterCard(CardType), AMEX
}


/**
CardNetwork Equatable function

- Parameter lhs: left hand side of the compare method
- Parameter rhs: right hand side of the compare method

- Returns: Boolean that indicates wether the two objects are equal or not
*/
public func ==(lhs: CardNetwork, rhs: CardNetwork) -> Bool {
    switch lhs {
    case .Visa(.Debit):
        switch rhs {
        case .Visa(.Debit), .Visa(.Unknown):
            return true
        default:
            return false
        }
    case .Visa(.Credit):
        switch rhs {
        case .Visa(.Credit), .Visa(.Unknown):
            return true
        default:
            return false
        }
    case .Visa(.Unknown):
        switch rhs {
        case .Visa(.Credit), .Visa(.Debit), .Visa(.Unknown):
            return true
        default:
            return false
        }
    case .MasterCard(.Debit):
        switch rhs {
        case .MasterCard(.Debit), .MasterCard(.Unknown):
            return true
        default:
            return false
        }
    case .MasterCard(.Credit):
        switch rhs {
        case .MasterCard(.Credit), .MasterCard(.Unknown):
            return true
        default:
            return false
        }
    case .MasterCard(.Unknown):
        switch rhs {
        case .MasterCard(.Credit), .MasterCard(.Debit), .MasterCard(.Unknown):
            return true
        default:
            return false
        }
    case .AMEX:
        switch rhs {
        case .AMEX:
            return true
        default:
            return false
        }
    }
}


// MARK: Response Types

/**
*  a PaymentToken object is necessary to make a token payment or token preAuth
*/
public struct PaymentToken {
    /// Our unique reference for this Consumer. Used in conjunction with the card token in repeat transactions.
    public let consumerToken: String
    /// Can be used to charge future payments against this card.
    public let cardToken: String
}


/**
*  the CardDetails object stores information that is returned from a successful payment or preAuth
*/
public struct CardDetails {
    /// The last four digits of the card used for this transaction.
    public let cardLastFour: String?
    /// Expiry date of the card used for this transaction formatted as a two digit month and year i.e. MM/YY.
    public let endDate: String?
    /// Can be used to charge future payments against this card.
    public let cardToken: String?
    /// the card network
    public let cardNetwork: CardNetwork?
    
    static func fromDictionary(dict: JSONDictionary) -> CardDetails {
        let lastFour = dict["cardLastfour"] as? String
        let endDate = dict["endDate"] as? String
        let cardToken = dict["cardToken"] as? String
        // TODO: parse dict["cardType"] into CardNetwork
        return CardDetails(cardLastFour: lastFour, endDate: endDate, cardToken: cardToken, cardNetwork: nil)
    }
}


/**
*  details of the Consumer for use in repeat payments.
*/
public struct Consumer {
    /// Our unique reference for this Consumer. Used in conjunction with the card token in repeat transactions.
    public let consumerToken: String
    /// Your reference for this Consumer as you sent in your request.
    public let yourConsumerReference: String
    
    static func fromDictionary(dict: JSONDictionary) -> Consumer {
        return Consumer(consumerToken: dict["consumerToken"] as! String, yourConsumerReference: dict["yourConsumerReference"] as! String)
    }
}


/// formatter for ISO8601 Dates that are returned from the webservice
let ISO8601DateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPOSIXLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"
    return dateFormatter
}()



// MARK: Pagination

public struct Pagination {
    var pageSize: Int = 10
    var offset: Int = 0
    var sort: Sort = .Descending
}


public enum Sort: String {
    case Descending = "time-descending", Ascending = "time-ascending"
}

