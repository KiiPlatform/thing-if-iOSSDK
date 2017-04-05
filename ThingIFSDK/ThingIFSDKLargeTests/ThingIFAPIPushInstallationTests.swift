//
//  ThingIFAPIPushInstallationTests.swift
//  ThingIFSDK
//
//  Created by syahRiza on 2017/04/04.
//  Copyright © 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIPushInstallationTests: OnboardedTestsBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInstallPushNoDevelopmentFlagSuccess() {

        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        let expectation = self.expectation(description: "testInstallPushNoDevelopmentFlagSuccess")

        onboardedApi.installPush(dummyDevice) { (installationID, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(installationID)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

    }

    func testInstallPushDevelopmentSuccess() {

        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        let expectation = self.expectation(description: "testInstallPushDevelopmentSuccess")

        onboardedApi.installPush(dummyDevice, development: true) { (installationID, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(installationID)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
        
    }
    
}
