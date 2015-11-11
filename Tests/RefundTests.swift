//
//  RefundTests.swift
//  Judo
//
//  Created by Hamon Riazy on 17/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
@testable import Judo

class RefundTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Judo.setToken(token, secret: secret)
        
        Session.isTesting = true
        Judo.sandboxed = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        Session.isTesting = false
        Judo.sandboxed = false
    }
    
    func testRefund() {
        // Given
        let receiptID = "1497684"
        let amount = Amount(decimalNumber: 30, currency: "GBP")
        let payRef = "payment123asd"
        
        let expectation = self.expectationWithDescription("refund expectation")

        // When
        do {
            let refund = try Judo.refund(receiptID, amount: amount, paymentReference: payRef).completion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                } else {
                    expectation.fulfill()
                }
            })

            // Then
            XCTAssertNotNil(refund)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}
