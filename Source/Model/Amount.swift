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
public struct Amount {
    /// The currency ISO Code - GBP is default
    public var currency: String = "GBP"
    /// The amount to process, to two decimal places
    public var amount: NSDecimalNumber
    
    public init(_ amount: NSDecimalNumber, _ currency: String) {
        self.currency = currency
        self.amount = amount
    }

    public init(_ amount: NSDecimalNumber, _ currency: String? = "GBP") {
        if let currency = currency {
            self.currency = currency
        }
        self.amount = amount
    }

    public init?(_ amount: NSDecimalNumber?, _ currency: String? = nil) {
        guard let amount = amount else { return nil }
        self.amount = amount
        if let currency = currency {
            self.currency = currency
        }
    }

    public init?(_ amount: String?, _ currency: String) {
        guard let amount = amount where Double(amount) != nil else { return nil }
        self.amount = NSDecimalNumber(string: amount)
        self.currency = currency
    }

    public init?(_ amount: String?) {
        guard let amount = amount where Double(amount) != nil else { return nil }
        self.amount = NSDecimalNumber(string: amount)
    }
    
    public init(_ amount: NSDecimalNumber) {
        self.amount = amount
    }
    
    public init(_ amount: String) {
        self.amount = NSDecimalNumber(string: amount)
    }
    
    public init(_ amount: Int) {
        self.amount = NSDecimalNumber(integer: amount)
    }
    
    public init(_ amount: UInt) {
        self.amount = NSDecimalNumber(unsignedLong: amount)
    }
    
    public init(_ amount: Float) {
        self.amount = NSDecimalNumber(float: amount)
    }
}
