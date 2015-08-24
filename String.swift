//
//  String.swift
//  Judo
//
//  Created by Hamon Riazy on 24/08/15.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import Foundation

public extension String {
    
    /**
    helper method to check wether the string begins with another given string
    
    - Parameter str: prefix string to compare
    
    - Returns: boolean indicating wether the prefix matches or not
    */
    public func beginsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }

    
}