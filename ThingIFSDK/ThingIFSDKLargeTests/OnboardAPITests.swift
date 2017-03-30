//
//  OnboardAPITests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardAPITests: LargeTestBase {

    internal var app: KiiApp?
    internal var api: ThingIFAPI?

    override func setUp() {
        super.setUp()

        let setting = self.setting
        self.userInfo = createPseudoUser(
          setting.appID,
          appKey: setting.appKey,
          hostName: setting.hostName)
        let userInfo: Dictionary<String, AnyObject> = self.userInfo!
        let owner = Owner(
          TypedID(
            .user,
            id: userInfo["userID"]! as! String),
          accessToken: userInfo["_accessToken"]! as! String)
        let app = KiiApp(
          setting.appID,
          appKey: setting.appKey,
          hostName: setting.hostName)
        let api = ThingIFAPI(
          app,
          owner: owner,
          tag: setting.tag)

        self.app = app
        self.api = api
    }

    override func tearDown() {
        let setting = self.setting
        let userInfo = self.userInfo!

        deletePseudoUser(
          setting.appID,
          appKey: setting.appKey,
          userID: userInfo["userID"] as! String,
          accessToken: userInfo["_accessToken"] as! String,
          hostName: setting.hostName)

        super.tearDown()
    }

    func testOnboardWithVendorThingIDAndThingIDSuccess() {
        var expectation = self.expectation(description: "testOnboardWithVendorThingIDAndThingIDSuccess")
        let vendorThingID = "vid-" + String(NSDate.init().timeIntervalSince1970)
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
              id: self.userInfo!["userID"]! as! String),
            accessToken: self.userInfo!["_accessToken"]! as! String))
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
          "gvid-" + String(NSDate.init().timeIntervalSince1970)
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
          "vid-" + String(NSDate.init().timeIntervalSince1970)
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
