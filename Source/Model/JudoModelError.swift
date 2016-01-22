//
//  JudoModelError.swift
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

/// Judo Model Error object
public class JudoModelError: NSObject {
    /// the error code of the model error
    public var code: JudoModelErrorCode?
    /// the field name of the error
    public var fieldName: String?
    /// the message of the error
    public var message: String?
    /// the detail of the error
    public var detail: String?
    /// raw value of the information passed
    public var rawValue: JSONDictionary?
    
    
    /**
     designated initializer with an object received from the Judo API
     
     - parameter dict: a key value storage containing model error information
     
     - returns: a JudoModelError object
     */
    public init(dict: JSONDictionary) {
        self.code = JudoModelErrorCode(rawValue: dict["code"] as! Int)
        self.fieldName = dict["fieldName"] as? String
        self.message = dict["message"] as? String
        self.detail = dict["detail"] as? String
        self.rawValue = dict
        super.init()
    }
    
}
