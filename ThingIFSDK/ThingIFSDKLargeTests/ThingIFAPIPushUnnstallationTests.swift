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

        self.executeAsynchronous { expectation in
            self.onboardedApi.uninstallPush { error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
            }
        }

    }

    func testUninstallPushWithInstallationIDSuccess()  {
        let dummyDevice = NSUUID().uuidString.data(using: .ascii)!

        var installationID : String?

        self.executeAsynchronous { expectation in
            self.onboardedApi.installPush(dummyDevice) {
                retInstallationID, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(retInstallationID)
                installationID = retInstallationID
            }
        }

        self.executeAsynchronous { expectation in
            self.onboardedApi.uninstallPush(installationID) { error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
            }
        }

    }

    func testUninstallPushError() {

        self.executeAsynchronous { expectation in
            self.onboardedApi.uninstallPush { error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNotNil(error)
            }
        }

    }
}
