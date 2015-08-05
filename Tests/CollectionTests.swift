//
//  CollectionTests.swift
//  Judo
//
//  Created by Hamon Riazy on 17/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
@testable import Judo

class CollectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        Judo.setToken(token, secret: secret)
        
        Judo.sandboxed = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCollection() {
        // Given
        let receiptID = "1497684"
        let amount = Amount(30)
        let payRef = "payment123asd"
        
        let expectation = self.expectationWithDescription("collection expectation")

        // When
        do {
            let collection = try Judo.collection(receiptID, amount: amount, paymentReference: payRef).completion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill();
            })
            
            // Then
            XCTAssertNotNil(collection)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}
