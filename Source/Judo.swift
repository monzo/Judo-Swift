//
//  Judo.swift
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

public struct Judo {
    
    static public let supportedNetworks: [CardNetwork] = [.Visa(.Debit), .MasterCard(.Debit), .MasterCard(.Credit), .AMEX]
    
    
    /// the endpoint for REST API calls to the Judo API
    static private (set) var endpoint = "https://gw1.judopay.com/"
    
    
    /// set the app to sandboxed mode
    static public var sandboxed: Bool = false {
        didSet {
            if sandboxed {
                endpoint = "https://gw1.judopay-sandbox.com/"
            }
        }
    }
    
    
    /**
    a mandatory function that sets the token and secret for making payments with Judo
    
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
    a function to check wether a token and secret has been set
    
    - Returns: a Boolean indicating wether the parameters have been set
    */
    static public func didSetTokenAndSecret() -> Bool {
        if let _ = Session.authorizationHeader {
            return true
        }
        return false
    }
    
    
    /**
    starting point and a reactive method to create a payment that is sent to a certain judo ID
    
    - Parameter judoID:    the recipient - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount:    the amount of the Payment
    - Parameter reference: the reference
    - Parameter card:      the card
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not luhn valid
    
    - Returns: a Payment Object
    */
    static public func payment(judoID: String, amount: Amount, reference: Reference) throws -> Payment {
        return try Payment(judoID: judoID, amount: amount, reference: reference)
    }
    
    
    /**
    starting point and a reactive method to create a preAuth that is sent to a certain judo ID
    
    - Parameter judoID:    the recipient - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount:    the amount of the PreAuth
    - Parameter reference: the reference
    - Parameter card:      the card
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not luhn valid
    
    - Returns: a PreAuth Object
    */
    static public func preAuth(judoID: String, amount: Amount, reference: Reference) throws -> PreAuth {
        return try PreAuth(judoID: judoID, amount: amount, reference: reference)
    }

    
    /**
    starting point and a reactive method to create a RegisterCard that is sent to a certain judo ID
    
    - Parameter judoID:    the recipient - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount:    the amount of the RegisterCard
    - Parameter reference: the reference
    - Parameter card:      the card
    
    - Throws: JudoIDInvalidError judoID does not match the given length or is not luhn valid
    
    - Returns: a RegisterCard Object
    */
    static public func registerCard(judoID: String, amount: Amount, reference: Reference) throws -> RegisterCard {
        return try RegisterCard(judoID: judoID, amount: amount, reference: reference)
    }

    
    /**
    creates a Receipt object which can be used to query for the receipt of a given id
    
    the receipt id has to be luhn valid, an Error will be thrown if the receipt id does not pass the luhn check
    
    If you want to use the receipt function - you need to enable that in the Judo Dashboard - Your Apps - Permissions for the given App
    
    - Parameter receiptID: the receipt id as a String
    
    - Throws: LuhnValidationError if the receiptID does not match
    
    - Returns: a Receipt Object for reactive usage
    */
    static public func receipt(receiptID: String? = nil) throws -> Receipt {
        return try Receipt(receiptID: receiptID)
    }

    
    /**
    Creates a Collection object which can be used to collect a previously pre-authenticated transaction
    
    - Parameter receiptID:        the receipt of the previously authorized transaction
    - Parameter amount:           the amount to be transacted
    - Parameter paymentReference: the payment reference string
    
    - Throws: LuhnValidationError judoID does not match the given length or is not luhn valid
    
    - Returns: a Collection object for reactive usage
    */
    static public func collection(receiptID: String, amount: Amount, paymentReference: String) throws -> Collection {
        return try Collection(receiptID: receiptID, amount: amount, paymentReference: paymentReference)
    }
    
    
    /**
    Creates a Refund object which can be used to refund a previous transaction
    
    - Parameter receiptID:        the receipt of the previous transaction
    - Parameter amount:           the amount to be refunded (will check if funds are available in your account)
    - Parameter paymentReference: the payment reference string
    
    - Throws: LuhnValidationError judoID does not match the given length or is not luhn valid
    
    - Returns: a Collection object for reactive usage
    */
    static public func refund(receiptID: String, amount: Amount, paymentReference: String) throws -> Refund {
        return try Refund(receiptID: receiptID, amount: amount, paymentReference: paymentReference)
    }
    
}
