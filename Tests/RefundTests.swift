//
//  RefundTests.swift
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

class RefundTests: XCTestCase {
    
    let judo = Judo(token: token, secret: secret)
    
    override func setUp() {
        super.setUp()
        judo.sandboxed = true
    }
    
    override func tearDown() {
        judo.sandboxed = false
        super.tearDown()
    }
    
    func testRefund() {
        // Given
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let card = Card(number: "4976000000003436", expiryDate: "12/20", cv2: "452")
        let amount = Amount(amountString: "30", currency: .GBP)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        do {
            let makePayment = try judo.payment(strippedJudoID, amount: amount, reference: references).card(card).contact(mobileNumber, emailAddress).completion({ (data, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                    expectation.fulfill()
                    return
                }
                
                guard let receiptId = data?.first?.receiptID else {
                    XCTFail("receipt ID was not available in response")
                    expectation.fulfill()
                    return
                }
                
                do {
                    let refund = try self.judo.refund(receiptId, amount: amount).completion({ (dict, error) -> () in
                        if let error = error {
                            XCTFail("api call failed with error: \(error)")
                        }
                        expectation.fulfill()
                    })
                    
                    // Then
                    XCTAssertNotNil(refund)
                } catch {
                    XCTFail("exception thrown: \(error)")
                }
            })
            // Then
            XCTAssertNotNil(makePayment)
            XCTAssertEqual(makePayment.judoID, strippedJudoID)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}
