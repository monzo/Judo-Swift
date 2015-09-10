//
//  Model.swift
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
*  the Address object stores information around the address that is related to a card
*/
public struct Address {
    public let line1, line2, line3, town, postCode, country: String?
    
    public init(line1: String? = nil, line2: String? = nil, line3: String? = nil, town: String? = nil, postCode: String? = nil, country: String? = nil) {
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.town = town
        self.postCode = postCode
        self.country = country
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        let dict = NSMutableDictionary()
        if let line1 = self.line1 {
            dict.setValue(line1, forKey: "line1")
        }
        if let line2 = self.line2 {
            dict.setValue(line2, forKey: "line2")
        }
        if let line3 = self.line3 {
            dict.setValue(line3, forKey: "line3")
        }
        if let town = self.town {
            dict.setValue(town, forKey: "town")
        }
        if let postCode = self.postCode {
            dict.setValue(postCode, forKey: "postCode")
        }
        if let country = self.country {
            dict.setValue(country, forKey: "billingCountry")
        }
        return dict.copy() as! NSDictionary
    }
}