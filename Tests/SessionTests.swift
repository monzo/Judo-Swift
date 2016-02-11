//
//  SessionTests.swift
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
import CoreLocation
@testable import Judo

class SessionTests: XCTestCase {
    
    let judo = try! Judo(token: token, secret: secret)
    
    override func setUp() {
        super.setUp()
        
        Session.isTesting = true
        judo.sandboxed = true
    }
    
    override func tearDown() {
        Session.isTesting = false
        judo.sandboxed = false
        
        super.tearDown()
    }
    
    func testPOST() {
        // Given
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(amountString: "30", currency: .GBP)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        let path = "transactions/payments"
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)

        guard let parameters = Session.transactionParameters(strippedJudoID, amount: amount, reference: references, card: card, token: nil, pkPayment: nil, location: location, email: emailAddress, mobile: mobileNumber, deviceSignal: nil) as? [String : AnyObject] else {
            XCTFail()
            return
        }
        
        // When
        let expectation = self.expectationWithDescription("payment expectation")
        
        Session.POST(path, parameters: parameters) { (receipt, error) -> () in
            expectation.fulfill()
        }
        
        // Then
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }
    
    func testLuhnCheck() {
        let validLuhnNumber = "100963875"
        XCTAssertTrue(validLuhnNumber.isLuhnValid())
        let invalidLuhnNumber = "100963874"
        XCTAssertFalse(invalidLuhnNumber.isLuhnValid())

    }
    
}
