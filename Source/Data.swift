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
        let lastFour = dict["cardLastFour"] as! String
        let endDate = dict["endDate"] as! String
        let cardToken = dict["cardToken"] as! String
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


/**
*  TransactionResult will hold all the information from a transaction response
*/
public struct TransactionData {
    /// our reference for this transaction. Keep track of this as it's needed to process refunds or collections later
    public let receiptID: String
    /// Your original reference for this payment
    public let yourPaymentReference: String
    /// The type of Transaction, either "Payment" or "Refund"
    public let type: TransactionType
    /// date and time of the Transaction including time zone offset
    public let createdAt: NSDate
    /// The result of this transactions, this will either be "Success" or "Declined"
    public let result: TransactionResult
    /// A message detailing the result.
    public let message: String
    /// The number (e.g. "123-456" or "654321") identifying the Merchant to whom payment has been made
    public let judoID: String
    /// The trading name of the Merchant to whom payment has been made
    public let merchantName: String
    /// How the Merchant will appear on the Consumers statement
    public let appearsOnStatementAs: String
    /// If present this will show the total value of refunds made against the original payment
    public let refunds: Amount?
    /// This is the original value of this transaction before refunds
    public let originalAmount: Amount?
    /// This will show the remaining balance of the transaction after refunds. You cannot refund more than the original payment
    public let netAmount: Amount
    /// This is the value of this transaction (if refunds available it is the amount after refunds)
    public let amount: Amount
    /// Information about the card used in this transaction
    public let cardDetails: CardDetails
    /// details of the Consumer for use in repeat payments
    public let consumer: Consumer
    
    
    /**
    create a TransactionData Object from a dictionary
    
    - Parameter dict: the dictionary
    
    - Returns: a TransactionData object
    */
    static func fromDictionary(dict: JSONDictionary) throws -> TransactionData {
        guard let receiptID = dict["receiptId"] as? String else { throw JudoError.ResponseParseError }
        
        guard let yourPaymentReference = dict["yourPaymentReference"] as? String else { throw JudoError.ResponseParseError }
        
        guard let typeString = dict["type"] as? String else { throw JudoError.ResponseParseError }
        guard let type = TransactionType(rawValue: typeString) else { throw JudoError.ResponseParseError }
        
        guard let createdAtString = dict["createdAt"] as? String else { throw JudoError.ResponseParseError }
        guard let createdAt = ISO8601DateFormatter.dateFromString(createdAtString) else { throw JudoError.ResponseParseError }
        
        guard let resultString = dict["result"] as? String else { throw JudoError.ResponseParseError }
        guard let result = TransactionResult(rawValue: resultString) else { throw JudoError.ResponseParseError }
        
        guard let message = dict["message"] as? String else { throw JudoError.ResponseParseError }
        
        guard let judoID = dict["judoID"] as? String else { throw JudoError.ResponseParseError }
        
        guard let merchantName = dict["merchantName"] as? String else { throw JudoError.ResponseParseError }
        
        guard let appearsOnStatementAs = dict["appearsOnStatementAs"] as? String else { throw JudoError.ResponseParseError }
        
        let refundsDouble = dict["refunds"] as? Double
        let refunds = Amount(refundsDouble)

        let originalAmountDouble = dict["originalAmount"] as? Double
        let originalAmount = Amount(originalAmountDouble)
        
        guard let netAmountDouble = dict["netAmount"] as? Double else { throw JudoError.ResponseParseError }
        let netAmount = Amount(netAmountDouble)
        
        guard let amountDouble = dict["amount"] as? Double else { throw JudoError.ResponseParseError }
        let amount = Amount(amountDouble)
        
        guard let cardDetailsDict = dict["cardDetails"] as? JSONDictionary else { throw JudoError.ResponseParseError }
        let cardDetails = CardDetails.fromDictionary(cardDetailsDict)
        
        guard let consumerDict = dict["consumer"] as? JSONDictionary else { throw JudoError.ResponseParseError }
        let consumer = Consumer.fromDictionary(consumerDict)
        
        return TransactionData(receiptID: receiptID, yourPaymentReference: yourPaymentReference, type: type, createdAt: createdAt, result: result, message: message, judoID: judoID, merchantName: merchantName, appearsOnStatementAs: appearsOnStatementAs, refunds: refunds, originalAmount: originalAmount, netAmount: netAmount, amount: amount, cardDetails: cardDetails, consumer: consumer)
    }
}


/**
Type of Transaction

- Payment: a Payment Transaction
- Refund:  a Refund Transaction
*/
public enum TransactionType: String {
    case Payment="Payment", Refund="Refund"
}


/**
Result of a Transaction

- Success:  successful transaction
- Declined: declined transaction
*/
public enum TransactionResult: String {
    case Success="Success", Declined="Declined"
}


// MARK: Pagination

public struct Pagination {
    var pageSize: Int = 10
    var offset: Int = 0
    var sort: Sort = .Descending
}


public enum Sort: String {
    case Descending = "time-descending", Ascending = "time-ascending"
}

