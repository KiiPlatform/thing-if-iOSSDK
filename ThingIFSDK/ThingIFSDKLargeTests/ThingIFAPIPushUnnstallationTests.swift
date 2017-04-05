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

    func testUninstallPushSuccess()  {
        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        let expectation = self.expectation(description: "install before uninstall")

        onboardedApi.installPush(dummyDevice) { (installationID, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(installationID)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let expectation2 = self.expectation(description: "testUninstallPushSuccess")
        onboardedApi.uninstallPush { (error) in
            XCTAssertNil(error)
            expectation2.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

    }

    func testUninstallPushWithInstallationIDSuccess()  {
        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        let expectation = self.expectation(description: "install before uninstall")
        var installationID : String?

        onboardedApi.installPush(dummyDevice) { (retInstallationID, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(retInstallationID)
            installationID = retInstallationID
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let expectation2 = self.expectation(description: "testUninstallPushSuccess")
        onboardedApi.uninstallPush(installationID) { (error) in
            XCTAssertNil(error)
            expectation2.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
        
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
