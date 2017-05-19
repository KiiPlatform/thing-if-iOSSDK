//
//  ThingIFAPIUpdateThingTypeTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class ThingIFAPIUpdateThingTypeTests: NotOnboardedYetTestsBase
{
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {
        let vendorThingID = "vid-" + String(Date().timeIntervalSince1970)
        let password = "password-1"

        self.executeAsynchronous { expectation in
            let vendorThingIdOptions = OnboardWithVendorThingIDOptions(
                position: .standalone)
            self.api?.onboardWith(
                vendorThingID: vendorThingID,
                thingPassword: password,
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
            self.api.getThingType { thingType, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(thingType)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.update(thingType: self.DEFAULT_THING_TYPE) { error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
            }
        }

        self.executeAsynchronous { expectation in
            self.api.getThingType { thingType, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual(self.DEFAULT_THING_TYPE, thingType)
            }
        }
    }
}
