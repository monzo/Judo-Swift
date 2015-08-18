//
//  Response.swift
//  Judo
//
//  Created by Hamon Riazy on 03/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import Foundation


/**
*  Response object that stores an array of items and includes pagination information if available
*/
public struct Response {
    /// the current pagination response
    public let pagination: Pagination?
    /// The array that contains the transaction response objects
    private (set) var items = Array<TransactionData>()
    
    
    /**
    Initialize a Response object with pagination if available
    
    - Parameter pagination: the pagination information for the response
    
    - Returns: a Response object
    */
    init(_ pagination: Pagination?) {
        self.pagination = pagination
    }
    
    
    /**
    add an element on to the items
    
    - Parameter element: the element to add to the items Array
    */
    public mutating func append(element: TransactionData) {
        self.items.append(element)
    }
    
    
    /**
    calculate the next page from available data
    
    :returns: a newly calculated Pagination object based on the Response object
    */
    public func nextPage() -> Pagination? {
        guard let page = self.pagination else { return nil }
        
        return Pagination(pageSize: page.pageSize, offset: page.offset + page.pageSize, sort: page.sort)
    }
}


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
    public let netAmount: Amount?
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
        
        guard let judoID = dict["judoId"] as? NSNumber else { throw JudoError.ResponseParseError }
        
        guard let merchantName = dict["merchantName"] as? String else { throw JudoError.ResponseParseError }
        
        guard let appearsOnStatementAs = dict["appearsOnStatementAs"] as? String else { throw JudoError.ResponseParseError }
        
        guard let currency = dict["currency"] as? String else { throw JudoError.ResponseParseError }
        
        var refunds = Amount(NSDecimalNumber(string: dict["refunds"] as? String))
        refunds.currency = currency
        
        var originalAmount = Amount(NSDecimalNumber(string: dict["originalAmount"] as? String))
        originalAmount.currency = currency
        
        var netAmount = Amount(NSDecimalNumber(string: dict["netAmount"] as? String))
        netAmount.currency = currency
        
        guard let amountString = dict["amount"] as? String else { throw JudoError.ResponseParseError }
        
        let amount = Amount(NSDecimalNumber(string: amountString), currency)
        
        guard let cardDetailsDict = dict["cardDetails"] as? JSONDictionary else { throw JudoError.ResponseParseError }
        let cardDetails = CardDetails.fromDictionary(cardDetailsDict)
        
        guard let consumerDict = dict["consumer"] as? JSONDictionary else { throw JudoError.ResponseParseError }
        let consumer = Consumer.fromDictionary(consumerDict)
        
        return TransactionData(receiptID: receiptID, yourPaymentReference: yourPaymentReference, type: type, createdAt: createdAt, result: result, message: message, judoID: String(judoID.integerValue), merchantName: merchantName, appearsOnStatementAs: appearsOnStatementAs, refunds: refunds, originalAmount: originalAmount, netAmount: netAmount, amount: amount, cardDetails: cardDetails, consumer: consumer)
    }
}


/**
Type of Transaction

- Payment: a Payment Transaction
- Refund:  a Refund Transaction
*/
public enum TransactionType: String {
    case Payment="Payment", PreAuth="PreAuth", Refund="Refund"
}


/**
Result of a Transaction

- Success:  successful transaction
- Declined: declined transaction
*/
public enum TransactionResult: String {
    case Success="Success", Declined="Declined"
}

// MARK: Helper


/// formatter for ISO8601 Dates that are returned from the webservice
let ISO8601DateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPOSIXLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"
    return dateFormatter
    }()

