//
//  Refund.swift
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
Refunding a successful payment is easy, simply identify the original receipt ID for the payment and the amount you wish to refund. When we've received this request, we check to ensure there is a sufficient balance to process the refund and then process the request accordingly. Here is an example to how you can make a Refund with the SDK.

### Refund by ID, amount and reference
```swift
    Judo.refund(receiptID, amount: amount, paymentReference: payRef).completion({ (dict, error) -> () in
        if let error = error {
            // error
        } else {
            // success
        }
    })
```

*/
public class Refund: NSObject {
    
    /// The receipt ID for a refund
    public private (set) var receiptID: String
    /// The amount of the refund
    public private (set) var amount: Amount
    /// The payment reference String for a refund
    public private (set) var paymentReference: String
    
    
    /**
    Starting point and a reactive method to create a Refund
    
    - Parameter judoID: the number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay - has to be between 6 and 10 characters and luhn-valid
    - Parameter amount: The amount to process
    - Parameter reference: the reference
    
    - Throws: LuhnValidationError judoID does not match the given length or is not luhn valid
    */
    init(receiptID: String, amount: Amount, paymentReference: String) throws {
        // Initialize variables
        self.receiptID = receiptID
        self.amount = amount
        self.paymentReference = paymentReference
        super.init()
        
        // Check if device is jailbroken and SDK was set to restrict access
        if !Judo.allowJailbrokenDevices && Judo.isJailbroken() {
            throw JudoError(.JailbrokenDeviceDisallowedError)
        }
        
        // Luhn check the receipt ID
        if !receiptID.isLuhnValid() {
            throw JudoError(.LuhnValidationError)
        }
    }
    
    
    /**
    Completion caller - this method will automatically trigger a Session Call to the judo REST API and execute the request based on the information that were set in the previous methods
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive self
    */
    public func completion(block: JudoCompletionBlock) -> Self {
        
        let parameters = Session.progressionParameters(self.receiptID, amount: self.amount, paymentReference: self.paymentReference)
        
        Session.POST("/transactions/refunds", parameters: parameters) { (dict, error) -> Void in
            block(dict, error)
        }
        
        return self
    }
    
}
