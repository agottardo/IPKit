//
//  IPKitTests.swift
//  IPKitTests
//
//  Created by Andrea Gottardo on 2018-12-18.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import XCTest
@testable import IPKit

class IPKitTests: XCTestCase {
    
    func testDefaultTimeout() {
        XCTAssert(IPAPI.shared.timeout == 10, "The default timeout should be 10 seconds.")
    }
    
    func testSetTimeout() {
        IPAPI.shared.setTimeout(seconds: 5)
        XCTAssert(IPAPI.shared.timeout == 5, "The timeout should be set to 5 seconds after calling setTimeout()")
    }
    
    func testSimpleFetch() {
        let expect = expectation(description: "it should fetch the current IP")
        IPAPI.shared.fetch { (response, error) in
            if error != nil {
                XCTFail("Network/parsing failure")
            }
            XCTAssert(response != nil, "Response should not be nil")
            XCTAssert(response?.ip != nil, "The IP should not be nil")
            XCTAssert((response?.ip?.count)! >= 7, "The IP should contain at least seven characters.")
            XCTAssert(response?.location != nil, "The location should not be nil")
            if response != nil && error == nil {
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: IPAPI.shared.timeout) { error in
            if error != nil {
                XCTFail("It didn't fulfill.")
            }
            
        }
        

    }

}
