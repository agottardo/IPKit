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
    
    var response : IPResponse?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        IPAPI.shared.fetch { (response, error) in
            self.response = response
            if error != nil {
                XCTFail("Network/parsing failure")
            }
        }
        sleep(UInt32(IPAPI.shared.timeout))
    }
    
    func testValueExists() {
        XCTAssert(response != nil, "Response should not be nil")
    }
    
    func testIPFormat() {
        XCTAssert(response?.ip != nil, "The IP should not be nil")
        XCTAssert((response?.ip?.count)! >= 7, "The IP should contain at least seven characters.")
    }
    
    func testLocationNotNil() {
        XCTAssert(response?.location != nil, "The location should not be nil")
    }
    
    func testDefaultTimeout() {
        XCTAssert(IPAPI.shared.timeout == 10)
    }
    
    func testSetTimeout() {
        IPAPI.shared.setTimeout(seconds: 2)
        XCTAssert(IPAPI.shared.timeout == 2)
    }

}
