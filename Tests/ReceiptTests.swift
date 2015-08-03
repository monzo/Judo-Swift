//
//  ReceiptTests.swift
//  Judo
//
//  Created by Hamon Riazy on 29/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
@testable import Judo

class ReceiptTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Judo.setToken(token, secret: secret)
        
        Judo.sandboxed = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJudoTransactionReceipt() {
        // Given
        let receiptID = "1491273"
        
        let expectation = self.expectationWithDescription("receipt fetch expectation")
        
        do {
            try Judo.receipt(receiptID).completion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                } else {
                    expectation.fulfill()
                }
            })
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    func testJudoTransactionAllReceipts() {
        // Given
        let expectation = self.expectationWithDescription("all receipts fetch expectation")
        
        do {
            try Judo.receipt(nil).completion({ (dict, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                } else {
                    expectation.fulfill()
                }
            })
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    func testJudoTransactionReceiptWithPagination() {
        // Given
        let page = Pagination(pageSize: 4, offset: 8, sort: Sort.Ascending)
        let expectation = self.expectationWithDescription("all receipts fetch expectation")
        
        Receipt.list(page) { (dict, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            } else {
                XCTAssertEqual(dict!.items.count, 5)
                XCTAssertEqual(dict!.pagination!.offset, 8)
                expectation.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
    }
    
}
