//
//  JudoErrors.swift
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

public enum Currency {
    case AUD, CAD, CHF, CZK, DKK, EUR, GBP, HKD, HUF, JPY, NOK, NZD, PLN, SEK, USD, ZAR, XOR
    
    public init?(code: String) {
        switch code {
        case "AUD":
            self = .AUD
        case "CAD":
            self = .CAD
        case "CHF":
            self = .CHF
        case "CZK":
            self = .CZK
        case "DKK":
            self = .DKK
        case "EUR":
            self = .EUR
        case "GBP":
            self = .GBP
        case "HKD":
            self = .HKD
        case "HUF":
            self = .HUF
        case "JPY":
            self = .JPY
        case "NOK":
            self = .NOK
        case "NZD":
            self = .NZD
        case "PLN":
            self = .PLN
        case "SEK":
            self = .SEK
        case "USD":
            self = .USD
        case "ZAR":
            self = .ZAR
        default:
            return nil
        }
    }
    
    public func title() -> String {
        switch self {
        case AUD:
            return "Australian Dollar"
        case CAD:
            return "Canadian Dollar"
        case CHF:
            return "Swiss Franc"
        case CZK:
            return "Czech Republic Krona"
        case DKK:
            return "Danish Krone"
        case EUR:
            return "Euro"
        case GBP:
            return "Pound sterling"
        case HKD:
            return "Hong Kong Dollar"
        case HUF:
            return "Hungarian Forint"
        case JPY:
            return "Japanese Yen"
        case NOK:
            return "Norwegian Krone"
        case NZD:
            return "New Zealand Dollar"
        case PLN:
            return "Polish Xloty"
        case SEK:
            return "Swedish Krona"
        case USD:
            return "United States Dollar"
        case ZAR:
            return "South African Rand"
        case XOR:
            return "Unsupported Currency"
        }
    }
    
    public func description() -> String {
        switch self {
        case AUD:
            return "AUD"
        case CAD:
            return "CAD"
        case CHF:
            return "CHF"
        case CZK:
            return "CZK"
        case DKK:
            return "DKK"
        case EUR:
            return "EUR"
        case GBP:
            return "GBP"
        case HKD:
            return "HKD"
        case HUF:
            return "HUF"
        case JPY:
            return "JPY"
        case NOK:
            return "NOK"
        case NZD:
            return "NZD"
        case PLN:
            return "PLN"
        case SEK:
            return "SEK"
        case USD:
            return "USD"
        case ZAR:
            return "ZAR"
        case XOR:
            return "Unsupported Currency"
        }
    }

}

