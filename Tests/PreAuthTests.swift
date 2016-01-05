//
//  PreAuthTests.swift
//  Judo
//
//  Created by Hamon Riazy on 17/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Judo

class PreAuthTests: XCTestCase {
    
    
    
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
    
    
    
    func testPreAuth() {
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let amount = Amount(amountString: "30", currency: .GBP)
        do {
            let preauth = try Judo.preAuth(strippedJudoID, amount: amount, reference: references)
            XCTAssertNotNil(preauth)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
    }
    
    
    
    func testJudoMakeValidPreAuth() {
        // Given
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(amountString: "30", currency: .GBP)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        do {
            let makePreAuth = try Judo.preAuth(strippedJudoID, amount: amount, reference: references).card(card).location(location).contact(mobileNumber, emailAddress).completion({ (data, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                }
                expectation.fulfill()
            })
            // Then
            XCTAssertNotNil(makePreAuth)
            XCTAssertEqual(makePreAuth.judoID, strippedJudoID)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    
    func testJudoMakeValidTokenPreAuth() {
        // Given
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let address = Address(line1: "242 Acklam Road", line2: "Westbourne Park", line3: nil, town: "London", postCode: "W10 5JJ")
        let card = Card(number: "4976000000003436", expiryDate: "12/15", cv2: "452", address: address)
        let amount = Amount(amountString: "30", currency: .GBP)
        let emailAddress = "hans@email.com"
        let mobileNumber = "07100000000"
        
        let location = CLLocationCoordinate2D(latitude: 0, longitude: 65)
        
        let expectation = self.expectationWithDescription("payment expectation")
        
        // When
        do {
            let makePreAuth = try Judo.preAuth(strippedJudoID, amount: amount, reference: references).card(card).location(location).contact(mobileNumber, emailAddress).completion({ (data, error) -> () in
                if let error = error {
                    XCTFail("api call failed with error: \(error)")
                } else {
                    guard let uData = data else {
                        XCTFail()
                        return // BAIL
                    }
                    let payToken = PaymentToken(consumerToken: uData.items.first!.consumer.consumerToken, cardToken: uData.items.first!.cardDetails.cardToken!)
                    do {
                        try Judo.preAuth(strippedJudoID, amount: amount, reference: references).paymentToken(payToken).completion({ (data, error) -> () in
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
            XCTAssertNotNil(makePreAuth)
            XCTAssertEqual(makePreAuth.judoID, strippedJudoID)
        } catch {
            XCTFail("exception thrown: \(error)")
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    
    func testJudoMakeInvalidJudoIDPreAuth() throws {
        // Given
        // allowed length for judoID is 6 to 10 chars
        let tooShortJudoID = "33412" // 5 chars not allowed
        let tooLongJudoID = "33224433441" // 11 chars not allowed
        let luhnInvalidJudoID = "33224433"
        var parameterError = false
        guard let references = Reference(consumerRef: "consumer0053252") else { return }
        let amount = Amount(amountString: "30", currency: .GBP)
        
        // When too short
        do {
            try Judo.preAuth(tooShortJudoID, amount: amount, reference: references) // this should fail
        } catch let error as JudoError {
            // Then
            switch error.code {
            case .JudoIDInvalidError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
        
        parameterError = false
        // When too long
        do {
            try Judo.preAuth(tooLongJudoID, amount: amount, reference: references) // this should fail
        } catch let error as JudoError {
            switch error.code {
            case .JudoIDInvalidError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
        
        parameterError = false
        // When
        do {
            try Judo.preAuth(luhnInvalidJudoID, amount: amount, reference: references) // this should fail
        } catch let error as JudoError {
            switch error.code {
            case .JudoIDInvalidError:
                parameterError = true
            default:
                XCTFail("exception thrown: \(error)")
            }
        }
        XCTAssertTrue(parameterError)
    }
    
    
    
    func testJudoMakeInvalidReferencesPreAuth() {
        // Given
        guard let references = Reference(consumerRef: "") else { return }
        let amount = Amount(amountString: "30", currency: .GBP)
        
        // When
        do {
            try Judo.preAuth(strippedJudoID, amount: amount, reference: references)
        } catch {
            XCTFail("exception thrown: \(error)")
        }

    }
    
    
    
    func testJudoListPreAuths() {
        let expectation = self.expectationWithDescription("list all preauths expectation")
        
        PreAuth.list({ (dict, error) -> () in
            if let error = error {
                XCTFail("api call failed with error: \(error)")
            } else {
                expectation.fulfill()
            }
        })
        
        self.waitForExpectationsWithTimeout(30.0, handler: nil)
    }
    
}
