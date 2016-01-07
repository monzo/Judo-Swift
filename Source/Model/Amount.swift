//
//  JudoErrors.swift
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
*  the Amount object stores information regarding the amount and currency for a transaction
*/
public class Amount: NSObject {
    /// The currency ISO Code - GBP is default
    public var currency: Currency = .GBP
    /// The amount to process, to two decimal places
    public var amount: NSDecimalNumber
    
    public init(decimalNumber: NSDecimalNumber, currency: Currency) {
        self.currency = currency
        self.amount = decimalNumber
    }
    
    public init(amountString: String, currency: Currency) {
        self.amount = NSDecimalNumber(string: amountString)
        self.currency = currency
    }
    
}

@objc public class Currency: NSObject {
    public let rawValue: String
    
    public init(_ fromRaw: String) {
        self.rawValue = fromRaw
    }
    
    public static let AUD = Currency("AUD")
    public static let CAD = Currency("CAD")
    public static let CHF = Currency("CHF")
    public static let CZK = Currency("CZK")
    public static let DKK = Currency("DKK")
    public static let EUR = Currency("EUR")
    public static let GBP = Currency("GBP")
    public static let HKD = Currency("HKD")
    public static let HUF = Currency("HUF")
    public static let JPY = Currency("JPY")
    public static let NOK = Currency("NOK")
    public static let NZD = Currency("NZD")
    public static let PLN = Currency("PLN")
    public static let SEK = Currency("SEK")
    public static let USD = Currency("USD")
    public static let ZAR = Currency("ZAR")
    public static let XOR = Currency("Unsupported Currency")
    
}

