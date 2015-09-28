//
//  PaymentTests.swift
//  Judo
//
//  Created by Hamon Riazy on 17/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Judo


class PaymentTests: XCTestCase {
    
    
    
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
    
    
    
    func testPayment() {
        let references = Reference(consumerRef: "consumer0053252", paymentRef: "payment123asd")
        let amount = Amount(30)
        do {
            let payment = try Judo.payment(strippedJudoID, amount: amount, reference: references)
            XCTAssertNotNil(payment)
        } catch {
            XCTFail()
        }
    }
    
    

    func testJudoMakeValidPayment() {
        // Given
        let resource = NSBundle(forClass: self.dynamicType).pathForResource("200-payment", ofType: "json")
        print(resource)
        
        let references = Reference(consumerRef: "consumer0053252", paymentRef: "payment123asd")
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(30)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        do {
            let makePayment = try Judo.payment(strippedJudoID, amount: amount, reference: references).card(card).location(location).contact(mobileNumber, emailAddress).completion({ (data, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                } else {
                    expectation.fulfill()
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
    
    
    
    func testJudoMakeValidTokenPayment() {
        // Given
        let references = Reference(consumerRef: "consumer0053252", paymentRef: "payment123asd")
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(30)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        do {
            let makePayment = try Judo.payment(strippedJudoID, amount: amount, reference: references).card(card).location(location).contact(mobileNumber, emailAddress).completion({ (data, error) -> () in
                if let _ = error {
                    XCTFail()
                } else {
                    guard let uData = data else {
                        XCTFail("no data available")
                        return // BAIL
                    }
                    let payToken = PaymentToken(consumerToken: uData.items.first!.consumer.consumerToken, cardToken: uData.items.first!.cardDetails.cardToken!)
                    do {
                        try Judo.payment(strippedJudoID, amount: amount, reference: references).paymentToken(payToken).completion({ (data, error) -> () in
                            if let error = error {
                                XCTFail("api call failed with error: \(error)")
                            } else {
                                expectation.fulfill()
                            }
                        })
                    } catch {
                        XCTFail("exception thrown: \(error)")
                    }
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
    
    
    
    func testJudoMakeInvalidJudoIDPayment() {
        // Given
        // allowed length for judoID is 6 to 10 chars
        let tooShortJudoID = "33412" // 5 chars not allowed
        let tooLongJudoID = "33224433441" // 11 chars not allowed
        let luhnInvalidJudoID = "33224433"
        var parameterError = false
        let references = Reference(consumerRef: "consumer0053252", paymentRef: "payment123asd")
        let amount = Amount(30)

        // When
        do {
            try Judo.payment(tooShortJudoID, amount: amount, reference: references) // this should fail
        } catch {
            // Then
            switch error {
            case JudoError.JudoIDInvalidError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
        
        parameterError = false
        // When
        do {
            try Judo.payment(tooLongJudoID, amount: amount, reference: references) // this should fail
        } catch {
            switch error {
            case JudoError.JudoIDInvalidError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
        
        parameterError = false
        // When
        do {
            try Judo.payment(luhnInvalidJudoID, amount: amount, reference: references) // this should fail
        } catch {
            switch error {
            case JudoError.JudoIDInvalidError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
    }
    
    
    
    func testJudoValidation() {
        // Given
        let references = Reference(consumerRef: "consumer0053252", paymentRef: "payment123asd")
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(30)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        do {
            let makePayment = try Judo.payment(strippedJudoID, amount: amount, reference: references).card(card).location(location).contact(mobileNumber, emailAddress).validate { dict, error in
                if let error = error {
                    XCTAssertEqual(error.code, JudoError.YouAreGoodToGo.rawValue)
                } else {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            }
            // Then
            XCTAssertNotNil(makePayment)
            XCTAssertEqual(makePayment.judoID, strippedJudoID)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
        
    }

}
