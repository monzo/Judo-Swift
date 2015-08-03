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


internal let kJudoIDLenght = (6...10)


public typealias JSONDictionary = [String : AnyObject]


/// The Session struct is a wrapper for the REST API calls
internal struct Session {
    
    
    /// token and secret are saved in the authorizationHeader for authentication of REST API calls
    static var authorizationHeader: String?
    
    
    /**
    POST Helper Method for accessing the Judo REST API
    
    - Parameter path:       the path
    - Parameter parameters: information that is set in the HTTP Body
    - Parameter completion: completion callblack block with the results
    */
    static func POST(path: String, parameters: JSONDictionary, completion: (TransactionData?, NSError?) -> Void) {
        
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
            completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.SerializationError.rawValue, userInfo: nil))
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
    static func GET(path: String, parameters: JSONDictionary?, completion: ((TransactionData?, NSError?) -> ())) {
        
        // create request
        let request = self.judoRequest(Judo.endpoint + path)
        
        request.HTTPMethod = "GET"
        
        if let params = parameters {
            let requestBody: NSData?
            do {
                requestBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            } catch  {
                print("body serialization failed")
                completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.SerializationError.rawValue, userInfo: nil))
                return
            }
            request.HTTPBody = requestBody
        }
        
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
    static func judoRequest(url: String) -> NSMutableURLRequest {
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
    
    
    
    static func task(request: NSURLRequest, completion: (TransactionData?, NSError?) -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, resp, err) -> Void in
            
            // error handling
            if data == nil, let error = err {
                completion(nil, error)
                return // BAIL
            }
            
            guard let upData = data else {
                completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.RequestError.rawValue, userInfo: nil))
                return // BAIL
            }
            
            let json: JSONDictionary?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(upData, options: NSJSONReadingOptions.AllowFragments) as? JSONDictionary
            } catch {
                print(error)
                completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.SerializationError.rawValue, userInfo: nil))
                return // BAIL
            }
            
            guard let upJSON = json else {
                completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.SerializationError.rawValue, userInfo: nil))
                return
            }
            
            if let errorMessage = upJSON["errorMessage"] as? String {
                print(errorMessage)
                let errorCode = upJSON["errorType"] as? Int ?? JudoError.Unknown.rawValue
                completion(nil, NSError(domain: JudoErrorDomain, code: errorCode, userInfo: upJSON["modelErrors"] as? JSONDictionary))
                return // BAIL
            }
            
            let result: TransactionData?
            do {
                result = try TransactionData.fromDictionary(upJSON)
            } catch {
                print(error)
                completion(nil, NSError(domain: JudoErrorDomain, code: JudoError.ResponseParseError.rawValue, userInfo: nil))
                return // BAIL
            }
            
            completion(result, nil)
            
        })

    }
    
    
    
    static func transactionParameters(judoID: String?, amount: Amount?, reference: Reference?, card: Card?, token: PaymentToken?, location: CLLocationCoordinate2D?, email: String?, mobile: String?) -> NSDictionary? {
        let parametersDict = NSMutableDictionary()
        if let ref = reference {
            parametersDict["yourConsumerReference"] = ref.yourConsuerReference
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
        } else if let token = token {
            parametersDict["consumerToken"] = token.consumerToken
            parametersDict["cardToken"] = token.cardToken
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
        
        return parametersDict
    }
    
    
    
    static func progressionParameters(receiptId: String, amount: Amount, paymentReference: String) -> JSONDictionary {
        return ["receiptId":receiptId, "amount": amount.amount, "yourPaymentReference": paymentReference]
    }
    
    
    
    static func stripJudoID(judoIDString: String) -> String {
        if isNumeric(judoIDString) {
            return judoIDString
        } else {
            return "".join(judoIDString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
        }
    }
    
    
    
    static func isNumeric(a: String) -> Bool {
        return Double(a) != nil
    }
    
    
    
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
    
    
    // MARK: Testing
    // trying to implement a swizzle for more robust testing
    static func test_POST(path: String, parameters: JSONDictionary, completion: (JSONDictionary?, NSError?) -> Void) {
        switch path {
        case "transactions/payments":
            let jsonFilePath = NSBundle.mainBundle().pathForResource("200-payment", ofType: "json")
            do {
                let jsonData = try NSData(contentsOfFile: jsonFilePath!, options: .DataReadingMappedIfSafe)
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
                completion(jsonResult as? JSONDictionary, nil)
            } catch {
                completion(nil, nil)
            }
            break
        case "transactions/preauths":
            let jsonFilePath = NSBundle.mainBundle().pathForResource("200-preAuth", ofType: "json")
            do {
                let jsonData = try NSData(contentsOfFile: jsonFilePath!, options: .DataReadingMappedIfSafe)
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
                completion(jsonResult as? JSONDictionary, nil)
            } catch {
                completion(nil, nil)
            }
            break
        default:
            completion(nil, nil)
            break
        }
    }

}
