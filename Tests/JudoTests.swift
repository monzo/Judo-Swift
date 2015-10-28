//
//  JudoTests.swift
//  JudoTests
//
//  Created by Hamon Riazy on 17/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest
@testable import Judo

let token = "<#YOUR TOKEN#>"
let secret = "<#YOUR SECRET#>"

let strippedJudoID = "100000009"

class JudoTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testJudoErrorDomain() {
        let errorDomain = JudoErrorDomain
        XCTAssertNotNil(errorDomain)
    }
    
    
    
    func testJudoSandboxMode() {
        Judo.sandboxed = false
        XCTAssertEqual(Judo.endpoint, "https://gw1.judopay.com/")
        Judo.sandboxed = true
        XCTAssertEqual(Judo.endpoint, "https://gw1.judopay-sandbox.com/")
    }
    
    
    
    func testSetTokenAndSecret() {
        // Given
//        XCTAssertFalse(Judo.didSetTokenAndSecret()) can not be checked since this test might be triggered after other tests have run
        
        // When
        Judo.setToken(token, secret: secret)
        
        // Then
        XCTAssertTrue(Judo.didSetTokenAndSecret())
    }

}
