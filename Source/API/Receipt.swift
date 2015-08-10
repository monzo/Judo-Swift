//
//  Receipt.swift
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
You can get a copy of the receipt for an individual transaction by creating a Receipt Object and calling `.completion(() -> ())` including the receipt id for the transaction in the path.
Alternatively you can receive a list of all the Transactions. By default it will return 10 transactions. These results are returned in time descending order by default, so it will return the latest 10 transactions.

### receipt by ID
```swift
    Judo.receipt(receiptID).completion({ (dict, error) -> () in
        if let _ = error {
            // error
        } else {
            // success
        }
    })
```

### all receipts
```swift
    Judo.receipt(nil).completion({ (dict, error) -> () in
        if let _ = error {
            // error
        } else {
            // success
        }
    })
```
*/
public class Receipt: NSObject {
    
    /// the receipt ID - nil for a list of all receipts
    private (set) var receiptID: String?
    
    /**
    initialization for a Receipt Object
    
    If you want to use the receipt function - you need to enable that in the Judo Dashboard
    
    - Parameter receiptID: the receipt id as a String - if nil, completion function will return a list of all transactions
    
    - Returns: a Receipt Object for reactive usage
    
    - Throws: LuhnValidationError if the receiptID does not match
    */
    init(receiptID: String? = nil) throws {
        // luhn check the receipt id
        self.receiptID = receiptID
        super.init()
        if let recID = receiptID where !Session.isLuhnValid(recID) {
            throw JudoError.LuhnValidationError
        }
    }
    

    /**
    completion caller - this method will automatically trigger a Session Call to the Judo REST API and execute the request based on the information that were set in the previous methods
    
    - Parameter block: a completion block that is called when the request finishes
    
    - Returns: reactive self
    */
    public func completion(block: ((Response?, NSError?) -> ())) -> Self {
        var path = "transactions"

        if let rec = self.receiptID {
            path += "/\(rec)"
        }
        
        Session.GET(path, parameters: nil) { (dictionary, error) -> () in
            block(dictionary, error)
        }
        return self
    }

    
    /**
    This method will return a list of receipts
    
    See [List all transactions](<https://www.judopay.com/docs/v4_1/restful-api/api-reference/#transactions>) for more information.
    
    - Parameter pagination: The offset, number of items and order in which to return the items
    - Parameter block: a completion block that is called when the request finishes
    */
    public static func list(pagination: Pagination, block: (Response?, NSError?) -> ()) {
        let path = "transactions?pageSize=\(pagination.pageSize)&offset=\(pagination.offset)&sort=\(pagination.sort.rawValue)"
        Session.GET(path, parameters: nil) { (dictionary, error) -> () in
            block(dictionary, error)
        }
    }
    
}
