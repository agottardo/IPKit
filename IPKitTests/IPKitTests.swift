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
    
    func testGoogleFetch() {
        let expect = expectation(description: "it should fetch Google DNS IP correctly")
        IPAPI.shared.fetch(forIP: "8.8.8.8") { (response, error) in
            if error != nil {
                XCTFail("Network/parsing failure")
            }
            XCTAssert(response != nil, "Response should not be nil")
            XCTAssert(response?.ip != nil, "The IP should not be nil")
            XCTAssert((response?.ip?.count)! >= 7, "The IP should contain at least seven characters.")
            XCTAssert(response?.location != nil, "The location should not be nil")
            XCTAssertEqual(response?.location?.country, "US", "Country should be US")
            XCTAssertEqual(response?.location?.city, "Mountain View", "City should be Mountain View")
            XCTAssertTrue(response?.location?.isInEuropeanUnion == false, "California should not be in the 🇪🇺")
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
    
    func testInvalidIPs() {
        
        let badIPs  = ["-1.255.255.255", "256.256.256.256", "a.b.c.d", "....", "0.a", "1.1.1", "...", ".....", "", "1234.168.0.1", ".1.1.1", "0.0..0", "1a2.168.0.1", "a.168.0.1"]
        let goodIPs = ["192.168.0.1", "0.0.0.0", "255.255.255.255", "1.1.1.1", "2.234.154.24"]
        
        for ip in badIPs {
            let expect = expectation(description: "it should not work with IP:" + ip)
            IPAPI.shared.fetch(forIP: ip) { (response, error) in
                if response == nil && error != nil {
                    expect.fulfill()
                }
            }
        }
        
        for ip in goodIPs {
            let expect = expectation(description: "it should work with IP: " + ip)
            IPAPI.shared.fetch(forIP: ip) { (response, error) in
                if response != nil && error == nil {
                    expect.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: IPAPI.shared.timeout) { error in
            if error != nil {
                XCTFail("It didn't fulfill.")
            }
        }
        
    }

}
