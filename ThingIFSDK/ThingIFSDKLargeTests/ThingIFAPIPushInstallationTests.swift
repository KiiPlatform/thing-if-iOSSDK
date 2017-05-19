//
//  ThingIFAPIPushInstallationTests.swift
//  ThingIFSDK
//
//  Created by syahRiza on 2017/04/04.
//  Copyright © 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class ThingIFAPIPushInstallationTests: OnboardedTestsBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInstallPushNoDevelopmentFlagSuccess() {

        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        self.executeAsynchronous { expectation in
            self.onboardedApi.installPush(dummyDevice) {
                installationID, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(installationID)
            }
        }
    }

    func testInstallPushDevelopmentSuccess() {

        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        self.executeAsynchronous { expectation in
            self.onboardedApi.installPush(dummyDevice, development: true) {
                installationID, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(installationID)
            }
        }
    }

}
