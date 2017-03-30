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
        var expectation = self.expectation(description: "testOnboardWithVendorThingIDAndThingIDSuccess")
        let vendorThingID = "vid-" + String(Date().timeIntervalSince1970)
        let vendorThingIdOptions = OnboardWithVendorThingIDOptions(
          DEMO_THING_TYPE,
          position: .standalone)
        self.api?.onboardWith(
          vendorThingID: vendorThingID,
          thingPassword: "password",
          options: vendorThingIdOptions) {
            target, error in
            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(.thing, target!.typedID.type)
            XCTAssertNotEqual(target!.accessToken, nil)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        expectation = self.expectation(description: "testOnboardWithVendorThingIDAndThingIDSuccess")
        let api = ThingIFAPI(
          self.app!,
          owner: Owner(
            TypedID(
              .user,
              id: self.userInfo["userID"]! as! String),
            accessToken: self.userInfo["_accessToken"]! as! String))
        let thingIdOptions = OnboardWithThingIDOptions(.standalone)
        api.onboardWith(
          thingID: self.api!.target!.typedID.id,
          thingPassword: "password",
          options: thingIdOptions) {
            target, error in
            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(.thing, target!.typedID.type)
            XCTAssertEqual(self.api!.target!.typedID.id, target!.typedID.id)
            XCTAssertNotEqual(target!.accessToken, nil)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testOnboardEndnodeWithGatewaySuccess() throws {
        var expectation = self.expectation(
          description: "testOnboardEndnodeWithGatewaySuccess")
        // Register gateway.
        let gatewayVendorThingID =
          "gvid-" + String(Date().timeIntervalSince1970)
        self.api!.onboardWith(
          vendorThingID: gatewayVendorThingID,
          thingPassword: "password",
          options: OnboardWithVendorThingIDOptions(
            DEMO_THING_TYPE,
            position: .gateway)) {
            target, error in
            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(TypedID.Types.thing, target?.typedID.type)
            XCTAssertNotNil(target?.accessToken)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        expectation = self.expectation(
          description: "testOnboardEndnodeWithGatewaySuccess")
        let endnodeVendorThingID =
          "vid-" + String(Date().timeIntervalSince1970)
        let pendingEndnode =
          try PendingEndNode(["vendorThingID" : endnodeVendorThingID])
        self.api!.onboard(
          pendingEndnode,
          endnodePassword: "password") {
            target, error in
            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(TypedID.Types.thing, target?.typedID.type)
            XCTAssertNotNil(target?.accessToken)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

}
