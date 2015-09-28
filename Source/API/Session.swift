//
//  Session.swift
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
import PassKit

internal let kJudoIDLenght = (6...10)


public typealias JSONDictionary = [String : AnyObject]


/// The Session struct is a wrapper for the REST API calls
public class Session {
    
    
    /// token and secret are saved in the authorizationHeader for authentication of REST API calls
    static var authorizationHeader: String?
    
    /// static variable that defines wether local json files should be used instead of the actual REST API
    internal static var isTesting = false
    
    
    /**
    POST Helper Method for accessing the Judo REST API
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    public static func POST(path: String, parameters: JSONDictionary, completion: (Response?, NSError?) -> Void) {
        
        // create request
        let request = self.judoRequest(Judo.endpoint + path)
        
        // request method
        request.HTTPMethod = "POST"
        
        // safely create request body for the request
        let requestBody: NSData?
        
        do {
            requestBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("body serialization failed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(nil, JudoError.SerializationError as NSError)
            })
            return // BAIL
        }
        
        request.HTTPBody = requestBody
        
        // create a data task
        let task = self.task(request, completion: completion)
        
        // initiate the request
        task.resume()
    }
    
    
    /**
    GET Helper Method for accessing the Judo REST API
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    static func GET(path: String, parameters: JSONDictionary?, completion: ((Response?, NSError?) -> ())) {
        
        // create request
        let request = self.judoRequest(Judo.endpoint + path)
        
        request.HTTPMethod = "GET"
        
        if let params = parameters {
            let requestBody: NSData?
            do {
                requestBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            } catch  {
                print("body serialization failed")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError.SerializationError as NSError)
                })
                return
            }
            request.HTTPBody = requestBody
        }
        
        let task = self.task(request, completion: completion)
        
        // initiate the request
        task.resume()
    }
    
    
    /**
    PUT Helper Method for accessing the Judo REST API - PUT should only be accessed for 3DS transactions to fulfill the transaction
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    static func PUT(path: String, parameters: JSONDictionary, completion: ((Response?, NSError?) -> ())) {
        // create request
        let request = self.judoRequest(Judo.endpoint + path)
        
        // request method
        request.HTTPMethod = "PUT"
        
        // safely create request body for the request
        let requestBody: NSData?
        
        do {
            requestBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("body serialization failed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(nil, JudoError.SerializationError as NSError)
            })
            return // BAIL
        }
        
        request.HTTPBody = requestBody
        
        // create a data task
        let task = self.task(request, completion: completion)
        
        // initiate the request
        task.resume()
    }
    
    // MARK: Helpers
    
    
    /**
    Helper Method to create a JSON HTTP request with authentication
    
    - Parameter url: the url for the request
    
    - Returns: a JSON HTTP request with authorization set
    */
    public static func judoRequest(url: String) -> NSMutableURLRequest {
        if self.isTesting {
            return self.test_judoRequest(url)
        }
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        // json configuration header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("5.0.0", forHTTPHeaderField: "API-Version")

        // check if token and secret have been set
        guard let authHeader = self.authorizationHeader else {
            print("token and secret not set")
            assertionFailure("token and secret not set")
            return request
        }
        
        // set auth header
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    /**
    Helper Method to create a JSON HTTP request to a local file depending on the endpoint
    
    - Parameter url: the url for the request
    
    - Returns: a JSON HTTP request to a local file for testing purposes
    */
    private static func test_judoRequest(url: String) -> NSMutableURLRequest {
        let path = url.stringByReplacingOccurrencesOfString(Judo.endpoint, withString: "")
        
        var fileName: String?
        
        switch path {
        case "transactions/payments":
            fileName = "200-payment"
        case "transactions/payments/validate":
            fileName = "200-payment-validation"
        case "transactions/preauths":
            fileName = "200-preauth-valid"
        case "transactions/registercard":
            fileName = "200-payment"
        case "/transactions/collections":
            fileName = "200-payment"
        case "/transactions/refunds":
            fileName = "200-payment"
        case "/transactions":
            fileName = "200-payment"
        default: // most likely a certain receiptID for query or 3DS
            fileName = "200-payment"
        }
        
        let filePath = NSBundle(forClass: self).pathForResource(fileName, ofType: "json")!
        
        return NSMutableURLRequest(URL: NSURL(fileURLWithPath: filePath))
    }
    
    
    /**
    Helper Method to create a JSON HTTP request with authentication
    
    - Parameter request: the request that is accessed
    - Parameter completion: a block that gets called when the call finishes, it carries two objects that indicate wether the call was a success or a failure
    
    - Returns: a NSURLSessionDataTask that can be used to manipulate the call
    */
    public static func task(request: NSURLRequest, completion: (Response?, NSError?) -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, resp, err) -> Void in
            
            // error handling
            if data == nil, let error = err {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, error)
                })
                return // BAIL
            }
            
            // unwrap response data
            guard let upData = data else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError.RequestError as NSError)
                })
                return // BAIL
            }
            
            // serialize JSON Dict
            let json: JSONDictionary?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(upData, options: NSJSONReadingOptions.AllowFragments) as? JSONDictionary
            } catch {
                print(error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError.SerializationError as NSError)
                })
                return // BAIL
            }
            
            // unwrap optional dictionary
            guard let upJSON = json else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError.SerializationError as NSError)
                })
                return
            }
            
            // did an error occur
            if let errorMessage = upJSON["errorMessage"] as? String {
                print(errorMessage)
                let errorCode = upJSON["errorType"] as? Int ?? JudoError.Unknown.rawValue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, NSError(domain: JudoErrorDomain, code: errorCode, userInfo: upJSON["modelErrors"] as? JSONDictionary))
                })
                return // BAIL
            }
            
            // check if 3DS was requested
            if upJSON["acsUrl"] != nil && upJSON["paReq"] != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.ThreeDSAuthRequest.rawValue, userInfo: upJSON))
                })
                return // BAIL
            }
            
            // create pagination object
            var paginationResponse: Pagination?
            
            if let offset = upJSON["offset"] as? NSNumber, let pageSize = upJSON["pageSize"] as? NSNumber, let sort = upJSON["sort"] as? String {
                paginationResponse = Pagination(pageSize: pageSize.integerValue, offset: offset.integerValue, sort: Sort(rawValue: sort)!)
            }
            
            var result = Response(paginationResponse)

            do {
                if let results = upJSON["results"] as? Array<JSONDictionary> {
                    for item in results {
                        let transaction = try TransactionData(item)
                        result.append(transaction)
                    }
                } else {
                    let transaction = try TransactionData(upJSON)
                    result.append(transaction)
                }
            } catch {
                print(error)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(nil, JudoError.ResponseParseError as NSError)
                })
                return // BAIL
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(result, nil)
            })
            
        })
        
    }
    
    
    /**
    Helper method to create all the parameters necessary for a Transaction
    
    - Parameter a: the given String to check wether it is decimal
    
    - Returns: true if the given string just contains decimal characters
    */
    static func transactionParameters(judoID: String?, amount: Amount?, reference: Reference?, card: Card?, token: PaymentToken?, pkPayment: PKPayment?, location: CLLocationCoordinate2D?, email: String?, mobile: String?, deviceSignal: JSONDictionary?) -> NSDictionary? {
        let parametersDict = NSMutableDictionary()
        if let ref = reference {
            parametersDict["yourConsumerReference"] = ref.yourConsumerReference
            parametersDict["yourPaymentReference"] = ref.yourPaymentReference
            if let metaData = ref.yourPaymentMetaData {
                parametersDict["yourPaymentMetaData"] = metaData
            }
        } else {
            return nil
        }
        
        if let jid = judoID {
            parametersDict["judoId"] = jid
        } else {
            return nil
        }
        
        if let amount = amount {
            parametersDict["amount"] = amount.amount
            parametersDict["currency"] = amount.currency
        } else {
            return nil
        }
        
        if let card = card {
            parametersDict["cardNumber"] = card.number
            parametersDict["expiryDate"] = card.expiryDate
            parametersDict["cv2"] = card.cv2
            if let cardAddressDict = card.address?.dictionaryRepresentation() {
                parametersDict["cardAddress"] = cardAddressDict
            }
            if let startDate = card.startDate {
                parametersDict["startDate"] = startDate
            }
            if let issueNumber = card.issueNumber {
                parametersDict["issueNumber"] = issueNumber
            }
        } else if let token = token {
            parametersDict["consumerToken"] = token.consumerToken
            parametersDict["cardToken"] = token.cardToken
        } else if let pkPayment = pkPayment {
            var tokenDict = JSONDictionary()
            if #available(iOS 9.0, *) {
                tokenDict["paymentInstrumentName"] = pkPayment.token.paymentMethod.displayName
            } else {
                tokenDict["paymentInstrumentName"] = pkPayment.token.paymentInstrumentName
            }
            if #available(iOS 9.0, *) {
                tokenDict["paymentNetwork"] = pkPayment.token.paymentMethod.network
            } else {
                tokenDict["paymentNetwork"] = pkPayment.token.paymentNetwork
            }
            do {
                tokenDict["paymentData"] = try NSJSONSerialization.JSONObjectWithData(pkPayment.token.paymentData, options: NSJSONReadingOptions.MutableLeaves) as? JSONDictionary
            } catch {
                return nil
            }
            
            parametersDict["pkPayment"] = ["token":tokenDict]
        } else {
            return nil
        }
        
        if let loc = location {
            parametersDict["consumerLocation"] = ["latitude":NSNumber(double: loc.latitude), "longitude":NSNumber(double: loc.longitude)]
        }
        
        if let mobile = mobile {
            parametersDict["mobileNumber"] = mobile
        }
        
        if let email = email {
            parametersDict["emailAddress"] = email
        }
        
        if let devSignal = deviceSignal {
            parametersDict["clientDetails"] = devSignal
        }
        
        return parametersDict
    }
    
    
    
    static func progressionParameters(receiptId: String, amount: Amount, paymentReference: String) -> JSONDictionary {
        return ["receiptId":receiptId, "amount": amount.amount, "yourPaymentReference": paymentReference]
    }
    
    
    /**
    Helper method to strip the given string of anything non-numeric - in this case a judoID sometimes contains dashes or whitespaces that have to be removed before initiating calls to the server
    
    - Parameter judoIDString: the given String to strip if necessary
    
    - Returns: a String stripped of all characters if not numeric
    */
    static func stripJudoID(judoIDString: String) -> String {
        if isNumeric(judoIDString) {
            return judoIDString
        } else {
            return judoIDString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        }
    }
    
    
    /** 
    Helper method to indicate wether a string is decimal or not
    
    - Parameter a: the given String to check wether it is decimal
    
    - Returns: true if the given string just contains decimal characters
    */
    static func isNumeric(a: String) -> Bool {
        return Double(a) != nil
    }
    
    
    /**
    Helper Method to check if a number string is luhn valid
    
    - Parameter number: the numeric string
    
    - Returns: true if the given number is luhn-valid
    */
    static func isLuhnValid(number: String) -> Bool {
        guard self.isNumeric(number) else {
            return false
        }
        let reversedInts = number.characters.reverse().map { Int(String($0)) }
        return reversedInts.enumerate().reduce(0) { (sum, val) in
            let odd = val.index % 2 == 1
            return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
        } % 10 == 0
    }
    
}


// MARK: Pagination

public struct Pagination {
    var pageSize: Int = 10
    var offset: Int = 0
    var sort: Sort = .Descending
}


public enum Sort: String {
    case Descending = "time-descending", Ascending = "time-ascending"
}

