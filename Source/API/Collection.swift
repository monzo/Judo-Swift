//
//  Collection.swift
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
A Collection transaction is the counterpart to a PreAuth transaction. While the PreAuth transaction reserves funds on a Consumer's card the collection initiates the transfer of those reserved funds into your judo account.

### collection by ID, amount and reference
```swift
    Judo.collection(receiptID, amount: amount, paymentReference: payRef).completion({ (dict, error) -> () in
        if let error = error {
            // error
        } else {
            // success
        }
    })
```

*/
public class Collection: NSObject {
    
    /// the receipt ID for a collection
    private (set) var receiptID: String
    /// the amount of the collection
    private (set) var amount: Amount
    /// the payment reference String for a collection
    private (set) var paymentReference: String
    
    
    /**
    starting point and a reactive method to create a Collection
    
    - Parameter judoID: the number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount: The amount to process
    - Parameter reference: the reference
    
    - Throws: LuhnValidationError judoID does not match the given length or is not luhn valid
    */
    init(receiptID: String, amount: Amount, paymentReference: String) throws {
        self.receiptID = receiptID
        self.amount = amount
        self.paymentReference = paymentReference
        super.init()
        
        // check if device is jailbroken and sdk was set to restrict access
        if !Judo.allowJailbrokenDevices && Judo.isJailbroken() {
            throw JudoError(.JailbrokenDeviceDisallowedError)
        }
        
        // luhn check the receipt id
        if !receiptID.isLuhnValid() {
            throw JudoError(.LuhnValidationError)
        }
    }
    
    
    /**
    completion caller - this method will automatically trigger a Session Call to the Judo REST API and execute the request based on the information that were set in the previous methods
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive self
    */
    public func completion(block: (Response?, JudoError?) -> ()) -> Self {
        
        let parameters = Session.progressionParameters(self.receiptID, amount: self.amount, paymentReference: self.paymentReference)
        
        Session.POST("/transactions/collections", parameters: parameters) { (dict, error) -> Void in
            block(dict, error)
        }
        
        return self
    }

}
