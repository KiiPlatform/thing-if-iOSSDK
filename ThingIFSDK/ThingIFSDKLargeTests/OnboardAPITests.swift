//
//  OnboardAPITests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardAPITests: NotOnboardedYetTestsBase {

    override func setUp() {
        super.setUp()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testOnboardWithVendorThingIDAndThingIDSuccess() {
        let vendorThingID = "vid-" + String(Date().timeIntervalSince1970)
        let vendorThingIdOptions = OnboardWithVendorThingIDOptions(
          DEFAULT_THING_TYPE,
          firmwareVersion: DEFAULT_FIRMWAREVERSION,
          position: .standalone)
        self.executeAsynchronous { expectation in
            self.api?.onboardWith(
              vendorThingID: vendorThingID,
              thingPassword: "password",
              options: vendorThingIdOptions) {
                target, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual(.thing, target!.typedID.type)
                XCTAssertNotEqual(target!.accessToken, nil)
            }
        }

        let api = ThingIFAPI(
          self.app!,
          owner: Owner(
            TypedID(
              .user,
              id: self.userInfo["userID"]! as! String),
            accessToken: self.userInfo["_accessToken"]! as! String))
        let thingIdOptions = OnboardWithThingIDOptions(.standalone)
        self.executeAsynchronous { expectation in
            api.onboardWith(
              thingID: self.api!.target!.typedID.id,
              thingPassword: "password",
              options: thingIdOptions) {
                target, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual(.thing, target!.typedID.type)
                XCTAssertEqual(self.api!.target!.typedID.id, target!.typedID.id)
                XCTAssertNotEqual(target!.accessToken, nil)
            }
        }
    }

    func testOnboardEndnodeWithGatewaySuccess() throws {
        // Register gateway.
        let gatewayVendorThingID =
          "gvid-" + String(Date().timeIntervalSince1970)
        self.executeAsynchronous { expectation in
            self.api!.onboardWith(
              vendorThingID: gatewayVendorThingID,
              thingPassword: "password",
              options: OnboardWithVendorThingIDOptions(
                self.DEFAULT_THING_TYPE,
                firmwareVersion: self.DEFAULT_FIRMWAREVERSION,
                position: .gateway)) {
                target, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual(TypedID.Types.thing, target?.typedID.type)
                XCTAssertNotNil(target?.accessToken)
            }
        }

        let endnodeVendorThingID =
          "vid-" + String(Date().timeIntervalSince1970)
        let pendingEndnode =
          try PendingEndNode(["vendorThingID" : endnodeVendorThingID])
        self.executeAsynchronous { expectation in
            self.api!.onboard(
              pendingEndnode,
              endnodePassword: "password") {
                target, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual(TypedID.Types.thing, target?.typedID.type)
                XCTAssertNotNil(target?.accessToken)
            }
        }
    }

}
