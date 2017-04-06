//
//  ThingIFAPIVendorThingIDTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIVendorThingIDTests: NotOnboardedYetTestsBase
{
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {
        let vendorThingID1 = "vid-" + String(Date().timeIntervalSince1970)
        let vendorThingID2 = "vid-" + String(Date().timeIntervalSince1970 + 1000)
        let password1 = "password-1"
        let password2 = "password-2"

        self.executeAsynchronous { expectation in
            let vendorThingIdOptions = OnboardWithVendorThingIDOptions(
                self.DEFAULT_THING_TYPE,
                firmwareVersion: self.DEFAULT_FIRMWAREVERSION,
                position: .standalone)
            self.api?.onboardWith(
                vendorThingID: vendorThingID1,
                thingPassword: password1,
                options: vendorThingIdOptions) { target, error in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(.thing, target!.typedID.type)
                    XCTAssertNotEqual(target!.accessToken, nil)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.getVendorThingID { id, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual(vendorThingID1, id)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.update(
                vendorThingID: vendorThingID2,
                password: password2) { error in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.getVendorThingID { id, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual(vendorThingID2, id)
            }
        }
    }
}
