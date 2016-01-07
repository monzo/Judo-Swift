//
//  Payment.swift
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
When you want to process a payment transaction you create a Payment object and start adding the necessary Information. This Transaction supports two types of Payments. You can process payments using a full set of card details, or by referencing a previously processed transaction.

- Card Payment
    - For payments where you have the full card details including the card number.
- Token Payment
    - For processing payments using a saved card (requires the Card token and Consumer token values).

`Transaction` contains all the necessary implementation of Payments and PreAuths since these are very closely related

### Card Payment

```swift
    Judo.payment(correctJudoID, amount: amount, reference: references)
        .card(card)
        .location(location)
        .contact(mobileNumber, emailAddress)
        .completion({ (data, error) -> () in
            if let _ = error {
                // failure
            } else {
                // success
            }
        })
```

### Token Payment

```swift token payment
    Judo.payment(correctJudoID, amount: amount, reference: references)
        .paymentToken(payToken)
        .location(location)
        .contact(mobileNumber, emailAddress)
        .completion({ (data, error) -> () in
            if let _ = error {
                // failure
            } else {
                // success
            }
        })
```

learn more [here](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/>)

*/
public class Payment: Transaction, TransactionPath {
    
    /// path variable for this class
    public static var path: String { get { return "transactions/payments" } }
    
    
    /**
    If you need to check a payment before actually processing it you use the validate call, we'll perform our internal checks on the payment without sending it to consumer's bank. We check the merchant identified by the judo ID can accept the payment, the card can be accepted and the card number passes the LUHN test.
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive Self
    */
    public func validate(block: ((Response?, JudoError?) -> ())) throws -> Self {
        if (self.card != nil && self.payToken != nil) {
            throw JudoError(.CardAndTokenError)
        } else if self.card == nil && self.payToken == nil {
            throw JudoError(.CardOrTokenMissingError)
        }
        
        guard let parameters = Session.transactionParameters(self.judoID, amount: self.amount, reference: self.reference, card: self.card, token: self.payToken, pkPayment: self.pkPayment, location: self.location, email: self.emailAddress, mobile: self.mobileNumber, deviceSignal: self.deviceSignal) as? JSONDictionary else {
            throw JudoError(.ParameterError)
        }
        
        Session.POST(self.dynamicType.path + "/validate", parameters: parameters) { (dict, error) -> Void in
            block(dict, error)
        }

        return self
    }

}
