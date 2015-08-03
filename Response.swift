//
//  Response.swift
//  Judo
//
//  Created by Hamon Riazy on 03/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import Foundation


public typealias Response = Array<TransactionData>


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
        
        var refunds: Amount? = nil
        if let refundsString = dict["refunds"] as? String {
            refunds = Amount(Double(refundsString))
        }
        
        var originalAmount: Amount? = nil
        if let originalAmountString = dict["originalAmount"] as? String {
            originalAmount = Amount(Double(originalAmountString))
        }
        
        var netAmount: Amount? = nil
        if let netAmountString = dict["netAmount"] as? String {
            netAmount = Amount(Double(netAmountString))
        }
        
        guard let amountString = dict["amount"] as? String else { throw JudoError.ResponseParseError }
        guard let amount = Amount(Double(amountString)) else { throw JudoError.ResponseParseError }
        
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

