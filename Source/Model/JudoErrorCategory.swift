//
//  JudoErrorCategory.swift
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
 Mirror of the judo API Error category

 - Unknown:          Unknown Error Cateogry
 - RequestError:     Request Error Category
 - ModelError:       Model Error Category
 - ConfigError:      Config Error Category
 - ProcessingError:  Processing Error Category
 - ExceptionError:   Exception Error Category
 */
@objc public enum JudoErrorCategory: Int {
    /// Unknown
    case Unknown = 0
    /// RequestError
    case RequestError = 1
    /// ModelError
    case ModelError = 2
    /// ConfigError
    case ConfigError = 3
    /// ProcessingError
    case ProcessingError = 4
    /// ExceptionError
    case ExceptionError = 5
    
    
    /**
     String value of the receiving error cateogory
     
     - returns: a String representation of the receiver
     */
    public func stringValue() -> String {
        switch self {
        case Unknown:
            return "Unknown"
        case RequestError:
            return "RequestError"
        case ModelError:
            return "ModelError"
        case ConfigError:
            return "ConfigError"
        case ProcessingError:
            return "ProcessingError"
        case ExceptionError:
            return "ExceptionError"
        }
    }
}
