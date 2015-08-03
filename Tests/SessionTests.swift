//
//  SessionTests.swift
//  Judo
//
//  Created by Hamon Riazy on 21/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Judo

class SessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPOST() {
        // Given
        let references = Reference(yourConsuerReference: "consumer0053252", yourPaymentReference: "payment123asd", yourPaymentMetaData: nil)
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(30)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        let path = "transactions/payments"
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)

        guard let parameters = Session.transactionParameters(strippedJudoID, amount: amount, reference: references, card: card, token: nil, location: location, email: emailAddress, mobile: mobileNumber) as? [String : AnyObject] else {
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
        XCTAssertTrue(Session.isLuhnValid(validLuhnNumber))
        let invalidLuhnNumber = "100963874"
        XCTAssertFalse(Session.isLuhnValid(invalidLuhnNumber))

    }
    
}
