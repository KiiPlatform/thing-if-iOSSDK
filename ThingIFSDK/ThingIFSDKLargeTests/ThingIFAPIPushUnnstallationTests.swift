//
//  ThingIFAPIPushUnnstallationTests.swift
//  ThingIFSDK
//
//  Created by syahRiza on 2017/04/05.
//  Copyright © 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIPushUninstallationTests: OnboardedTestsBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }



    func testUninstallPushError() {

        let expectation = self.expectation(description: "testUninstallPushError")
        onboardedApi.uninstallPush { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
        
    }
    
}
