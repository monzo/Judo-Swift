//
//  ListTests.swift
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

import XCTest
@testable import Judo

class ListTests: XCTestCase {
    
    let judo = Judo(token: token, secret: secret)
    
    override func setUp() {
        super.setUp()
        judo.sandboxed = true
    }
    
    override func tearDown() {
        super.tearDown()
        judo.sandboxed = false
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
        // Given
        let pagination = Pagination(pageSize: 14, offset: 44, sort: Sort.Descending)
        
        let expectation = self.expectationWithDescription("list all payments for given pagination")
        
        // When
        Payment.list(pagination) { (response, error) -> () in
            // Then
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
