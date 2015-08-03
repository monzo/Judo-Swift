//
//  ListTests.swift
//  Judo
//
//  Created by Hamon Riazy on 03/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
@testable import Judo

class ListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Judo.setToken(token, secret: secret)
        
        Judo.sandboxed = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJudoListPayments() {
        let expectation = self.expectationWithDescription("list all payments expectation")
        
        Payment.list({ (dict, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            } else {
                expectation.fulfill()
            }
        })
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
    }
    
    func testJudoPaginatedListPayments() {
        // GIVEN
        let pagination = Pagination(pageSize: 14, offset: 44, sort: Sort.Descending)
        
        let expectation = self.expectationWithDescription("list all payments for given pagination")
        
        // WHEN
        Payment.list(pagination) { (response, error) -> () in
            // THEN
            if let _ = error {
                XCTFail()
            } else {
                XCTAssertEqual(response!.items.count, 15)
                XCTAssertEqual(response!.pagination!.offset, 44)
                expectation.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
    }
    
}
