//
//  Session+Tests.swift
//  Judo
//
//  Created by Hamon Riazy on 25/09/15.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import Foundation
@testable import Judo

public extension Session {
    
    public static func judoRequest(url: String) -> NSMutableURLRequest {
        
        let path = url.stringByReplacingOccurrencesOfString(Judo.endpoint, withString: "")
        
        var fileName: String?
        
        switch path {
        case "transactions/payments":
            fileName = "200-payment"
            break
        case "transactions/preauths":
            fileName = "200-preauth-valid"
            break
        case "transactions/registercard":
            fileName = "200-preauth-blocked-card"
            break
        case "/transactions/collections":
            fileName = "200-preauth-blocked-card"
            break
        case "/transactions/refunds":
            fileName = "200-preauth-blocked-card"
            break
        case "/transactions":
            fileName = "200-preauth-blocked-card"
            break
        default: // most likely a certain receiptID for query or 3DS
            fileName = "200-preauth-blocked-card"
            break
        }
        
        return NSMutableURLRequest(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!))
    }
    
}