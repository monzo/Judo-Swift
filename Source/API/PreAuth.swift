//
//  PreAuth.swift
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
When you want to process a pre Authentication you create a PreAuth object and start adding the necessary Information. This Transaction supports two types of PreAuths. You can process preauths using a full set of card details, or by referencing a previously processed transaction.

- Card PreAuth
    - For preauths where you have the full card details including the card number.
- Token Pre Auth
    - For processing payments using a saved card (requires the Card token and Consumer token values).

[`Transaction`](Transaction) contains all the necessary implementation of Payments and PreAuths since these are very closely related

### Card PreAuth

```swift
    Judo.preauth(correctJudoID, amount: amount, reference: references)
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

### Token PreAuth

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
public class PreAuth: Transaction, TransactionPath {
    
    /// path variable for preauth class
    public static var path: String { get { return "transactions/preauths" } }

}
