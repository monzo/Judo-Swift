//
//  Transaction.swift
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
import CoreLocation

protocol TransactionPath {
    static var path: String {get}
}

/// Superclass Helper for Payments and PreAuths
public class Transaction {

    private (set) var judoID: String
    
    private (set) var reference: Reference
    private (set) var amount: Amount

    private (set) var card: Card?
    private (set) var payToken: PaymentToken?

    private (set) var location: CLLocationCoordinate2D?
    
    private (set) var mobileNumber: String?
    private (set) var emailAddress: String?
    

    /**
    starting point and a reactive method to create a payment or preAuth
    
    - Parameter judoID: the number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount: The amount to process
    - Parameter reference: the reference
    
    - Throws JudoIDInvalidError: judoID does not match the given length or is not luhn valid
    */
    init(judoID: String, amount: Amount, reference: Reference) throws {
        self.judoID = judoID
        self.amount = amount
        self.reference = reference
        
        // judoid validation
        let strippedJudoID = Session.stripJudoID(judoID)
        
        if !Session.isLuhnValid(strippedJudoID) {
            throw JudoError.LuhnValidationError
        }
        
        if kJudoIDLenght ~= strippedJudoID.characters.count  {
            self.judoID = strippedJudoID
        } else {
            throw JudoError.JudoIDInvalidError
        }
    }
    
    
    /**
    If making a card payment, add the details here
    
    - Parameter card: a card object containing the information from which to make a payment
    
    - Returns: reactive self
    */
    public func card(card: Card) -> Self {
        self.card = card
        return self
    }

    
    /**
    if a card payment or a card registration has been previously made, add the token to make a repeat payment
    
    - Parameter token: a token-string from a previous payment or registration
    
    - Returns: reactive self
    */
    public func paymentToken(token: PaymentToken) -> Self {
        self.payToken = token
        return self
    }
    
    
    // TODO: investigate as to how and why location is important (fraud protection?)
    /**
    reactive method to set location information of the user, this method is optional
    
    - Parameter location: a CLLocationCoordinate2D which represents the current location of the user
    
    - Returns: reactive self
    */
    public func location(location: CLLocationCoordinate2D) -> Self {
        self.location = location
        return self
    }
    
    
    /**
    reactive method to set contact information of the user such as mobile number and email address, this method is optional
    
    - Parameter mobileNumber: a mobile number String
    - Parameter emailAddress: an email address String
    
    - Returns: reactive self
    */
    public func contact(mobileNumber : String?, _ emailAddress : String?) -> Self {
        self.mobileNumber = mobileNumber
        self.emailAddress = emailAddress
        return self
    }
    
    
    /**
    completion caller - this method will automatically trigger a Session Call to the Judo REST API and execute the request based on the information that were set in the previous methods
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive self
    
    - Throws: ParameterError one or more of the given parameters were in the incorrect format or nil
    */
    public func completion(block: (Response?, NSError?) -> ()) throws -> Self {
        
        if (self.card != nil && self.payToken != nil) {
            throw JudoError.CardAndTokenError
        } else if self.card == nil && self.payToken == nil {
            throw JudoError.CardOrTokenMissingError
        }
        
        guard let parameters = Session.transactionParameters(self.judoID, amount: self.amount, reference: self.reference, card: self.card, token: self.payToken, location: self.location, email: self.emailAddress, mobile: self.mobileNumber) as? JSONDictionary else {
            throw JudoError.ParameterError
        }
        
        Session.POST((self.dynamicType as! TransactionPath.Type).path, parameters: parameters) { (dictionary, error) -> () in
            block(dictionary, error)
        }
        
        return self
    }
    
    
    /**
    This method will return a list of transactions, filtered to just show the payment or preAuth transactions. The method will show the first 10 items in a Time Descending order
    
    See [List all transactions](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/#transactions>) for more information.
    
    - Parameter block: a completion block that is called when the request finishes
    */
    public static func list(block: (Response?, NSError?) -> ()) {
        self.list(nil, block: block)
    }
    
    
    /**
    This method will return a list of transactions, filtered to just show the payment or preAuth transactions.
    
    See [List all transactions](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/#transactions>) for more information.
    
    - Parameter pagination: The offset, number of items and order in which to return the items
    - Parameter block: a completion block that is called when the request finishes
    */
    public static func list(pagination: Pagination?, block: (Response?, NSError?) -> ()) {
        var path = (self as! TransactionPath.Type).path
        if let pag = pagination {
            path += "?pageSize=\(pag.pageSize)&offset=\(pag.offset)&sort=\(pag.sort.rawValue)"
        }
        Session.GET(path, parameters: nil) { (dictionary, error) -> () in
            block(dictionary, error)
        }
    }

}
