//
//  JudoTests.swift
//  JudoTests
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

let token = "3x2dQPx5HiyD1zir"
let secret = "17aad220942556910e6c461bfb79b2c2d294a3de3c35c2f5484ba4d5dddadb93"

let strippedJudoID = "100963875"

class JudoTests: XCTestCase {
    
    let judo = Judo(token: token, secret: secret)
    
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
        judo.sandboxed = false
        XCTAssertEqual(Session.endpoint, "https://gw1.judopay.com/")
        judo.sandboxed = true
        XCTAssertEqual(Session.endpoint, "https://gw1.judopay-sandbox.com/")
    }
    
    
    
    func testSetTokenAndSecret() {
        // Given
//        XCTAssertFalse(Judo.didSetTokenAndSecret()) can not be checked since this test might be triggered after other tests have run
        
        // When
        judo.setToken(token, secret: secret)
        
        // Then
        XCTAssertTrue(judo.didSetTokenAndSecret())
    }

}
