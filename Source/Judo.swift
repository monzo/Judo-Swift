//
//  Judo.swift
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
 *  Entry point of interaction with the judo Swift SDK
 */
public class Judo {
    
    /// The endpoint for REST API calls to the judo API
    static private (set) var endpoint = "https://gw1.judopay.com/"
    
    
    /// Set the app to sandboxed mode
    static public var sandboxed: Bool = false {
        didSet {
            if sandboxed {
                endpoint = "https://gw1.judopay-sandbox.com/"
            } else {
                endpoint = "https://gw1.judopay.com/"
            }
        }
    }
    
    
    /// Boolean that will restrict access from jailbroken devices
    static public var allowJailbrokenDevices: Bool = true
    
    
    /**
    A mandatory function that sets the token and secret for making payments with judo
    
    - Parameter token:  a string object representing the token
    - Parameter secret: a string object representing the secret
    */
    static public func setToken(token: String, secret: String) {
        let plainString = token + ":" + secret
        let plainData = plainString.dataUsingEncoding(NSISOLatin1StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        Session.authorizationHeader = "Basic " + base64String
    }
    
    
    /**
    A function to check whether a token and secret has been set
    
    - Returns: a Boolean indicating whether the parameters have been set
    */
    static public func didSetTokenAndSecret() -> Bool {
        return Session.authorizationHeader != nil
    }
    
    
    /**
     A method that checks if the device it is currently running on is jailbroken or not
     
     - returns: true if device is jailbroken
     */
    static public func isJailbroken() -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath("/private/var/lib/apt/")
    }
    
    
    /**
     Starting point and a reactive method to create a transaction that is sent to a certain judo ID
     
     - Parameter transactionType: The type of the transaction (payment, pre-auth or registercard)
     - Parameter judoID:          The recipient - has to be between 6 and 10 characters and luhn-valid
     - Parameter amount:          The amount of the Payment
     - Parameter reference:       The reference
     
     - Throws: JudoIDInvalidError    judoID does not match the given length or is not luhn valid
     - Throws: InvalidOperationError if you call this method with .Refund as a transactionType
     
     - Returns: a Payment Object
     */
    static public func transaction(transactionType: TransactionType, judoID: String, amount: Amount, reference: Reference) throws -> Transaction {
        switch transactionType {
        case .Payment:
            return try Judo.payment(judoID, amount: amount, reference: reference)
        case .PreAuth, .RegisterCard:
            return try Judo.preAuth(judoID, amount: amount, reference: reference)
        case .Refund:
            throw JudoError(.InvalidOperationError)
        }
    }
    
    
    /**
    Starting point and a reactive method to create a payment that is sent to a certain judo ID
    
    - Parameter judoID:    The recipient - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount:    The amount of the Payment
    - Parameter reference: The reference
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not luhn valid
    
    - Returns: a Payment Object
    */
    static public func payment(judoID: String, amount: Amount, reference: Reference) throws -> Payment {
        return try Payment(judoID: judoID, amount: amount, reference: reference)
    }
    
    
    /**
    Starting point and a reactive method to create a pre-auth that is sent to a certain judo ID
    
    - Parameter judoID:    The recipient - has to be between 6 and 10 characters and LUHN valid
    - Parameter amount:    The amount of the pre-auth
    - Parameter reference: The reference
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not LUHN valid
    
    - Returns: pre-auth Object
    */
    static public func preAuth(judoID: String, amount: Amount, reference: Reference) throws -> PreAuth {
        return try PreAuth(judoID: judoID, amount: amount, reference: reference)
    }
    
    
    /**
    Starting point and a reactive method to create a RegisterCard that is sent to a certain judo ID
    
    - Parameter judoID:    The recipient - has to be between 6 and 10 characters and LUHN valid
    - Parameter amount:    The amount of the RegisterCard
    - Parameter reference: The reference
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not LUHN valid
    
    - Returns: a RegisterCard Object
    */
    static public func registerCard(judoID: String, amount: Amount, reference: Reference) throws -> RegisterCard {
        return try RegisterCard(judoID: judoID, amount: amount, reference: reference)
    }
    
    
    /**
    Creates a Receipt object which can be used to query for the receipt of a given ID.
    
    The receipt ID has to be LUHN valid, an error will be thrown if the receipt ID does not pass the LUHN check.
    
    If you want to use the receipt function - you need to enable that in the judo Dashboard - Your Apps - Permissions for the given App
    
    - Parameter receiptID: The receipt ID as a String
    
    - Throws: LuhnValidationError if the receiptID does not match
    
    - Returns: a Receipt Object for reactive usage
    */
    static public func receipt(receiptID: String? = nil) throws -> Receipt {
        return try Receipt(receiptID: receiptID)
    }
    
    
    /**
    Creates a Collection object which can be used to collect a previously pre-authorized transaction
    
    - Parameter receiptID:        The receipt of the previously authorized transaction
    - Parameter amount:           The amount to be transacted
    - Parameter paymentReference: The payment reference string
    
    - Throws: LuhnValidationError judoID does not match the given length or is not LUHN valid
    
    - Returns: a Collection object for reactive usage
    */
    static public func collection(receiptID: String, amount: Amount, paymentReference: String) throws -> Collection {
        return try Collection(receiptID: receiptID, amount: amount, paymentReference: paymentReference)
    }
    
    
    /**
    Creates a Refund object which can be used to refund a previous transaction
    
    - Parameter receiptID:        The receipt of the previous transaction
    - Parameter amount:           The amount to be refunded (will check if funds are available in your account)
    - Parameter paymentReference: The payment reference string
    
    - Throws: LuhnValidationError judoID does not match the given length or is not LUHN valid
    
    - Returns: a Refund object for reactive usage
    */
    static public func refund(receiptID: String, amount: Amount, paymentReference: String) throws -> Refund {
        return try Refund(receiptID: receiptID, amount: amount, paymentReference: paymentReference)
    }
    
    
    /**
     Creates a VoidTransaction object which can be used to void a previous preAuth
     
     - Parameter receiptID:        The receipt of the previous transaction
     - Parameter amount:           The amount to be refunded (will check if funds are available in your account)
     - Parameter paymentReference: The payment reference string
     
     - Throws: LuhnValidationError judoID does not match the given length or is not LUHN valid
     
     - Returns: a Void object for reactive usage
     */
    static public func voidTransaction(receiptID: String, amount: Amount, paymentReference: String) throws -> VoidTransaction {
        return try VoidTransaction(receiptID: receiptID, amount: amount, paymentReference: paymentReference)
    }
    
}
