//
//  ThingIFAPIPersistenceTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/10.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIPersistenceTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testSavedInstanceWithInit() throws {
        let persistance = UserDefaults.standard
        let baseKey = "ThingIFAPI_INSTANCE"
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner

        //clear
        persistance.removeObject(forKey: baseKey)
        persistance.synchronize()
        sleep(1)

        // ThingIFAPI is not saved when ThingIFAPI is instantiation.
        let api = ThingIFAPI(app, owner:owner)
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance())
        api.saveInstance()
        sleep(1)

        XCTAssertEqual(api, try ThingIFAPI.loadWithStoredInstance())
    }

    func testRemoveAllStoredInstances() throws {
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner

        let api1 = ThingIFAPI(app, owner:owner)
        let api2 = ThingIFAPI(app, owner:owner, tag:tags[0])
        let api3 = ThingIFAPI(app, owner:owner, tag:tags[1])

        var expectation = self.expectation(
          description: "testSavedInstanceWithOnboard")

        try setMockResponse4Onboard(
          "access-token-00000001",
          thingID: "th.00000001",
          setting: setting)

        api1.onboardWith(
          vendorThingID: "vendor-0001",
          thingPassword: "password1",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(
          description: "testSavedInstanceWithOnboard")
        try setMockResponse4Onboard(
          "access-token-00000002",
          thingID: "th.00000002",
          setting: setting)
        api2.onboardWith(
          vendorThingID: "vendor-0002",
          thingPassword: "password2",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(
          description: "testSavedInstanceWithOnboard")
        try setMockResponse4Onboard(
          "access-token-00000003",
          thingID: "th.00000003",
          setting: setting)
        api3.onboardWith(
          vendorThingID: "vendor-0002",
          thingPassword: "password2",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        ThingIFAPI.removeAllStoredInstances()

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: nil),
              error as? ThingIFError)
        }
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[0])) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: "tag1"),
              error as? ThingIFError)
        }
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[1])) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: "tag2"),
              error as? ThingIFError)
        }
    }

    func testSavedInstanceWithOnboard() throws {
        let tags = ["tag1", "tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner

        let api1 = ThingIFAPI(app, owner:owner)
        let api2 = ThingIFAPI(app, owner:owner, tag:tags[0])
        let api3 = ThingIFAPI(app, owner:owner, tag:tags[1])

        var expectation = self.expectation(
          description: "testSavedInstanceWithOnboard")
        try setMockResponse4Onboard(
          "access-token-00000001",
          thingID: "th.00000001",
          setting: setting)
        api1.onboardWith(
          vendorThingID: "vendor-0001",
          thingPassword: "password1",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(
          description: "testSavedInstanceWithOnboard")
        try setMockResponse4Onboard(
          "access-token-00000002",
          thingID: "th.00000002",
          setting: setting)
        api2.onboardWith(
          vendorThingID: "vendor-0002",
          thingPassword: "password2",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(
          description: "testSavedInstanceWithOnboard")
        try setMockResponse4Onboard(
          "access-token-00000003",
          thingID: "th.00000003",
          setting: setting)
        api3.onboardWith(
          vendorThingID: "vendor-0002",
          thingPassword: "password2",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        XCTAssertEqual(api1, try ThingIFAPI.loadWithStoredInstance())
        XCTAssertEqual(api2, try ThingIFAPI.loadWithStoredInstance(tags[0]))
        XCTAssertEqual(api3, try ThingIFAPI.loadWithStoredInstance(tags[1]))

        ThingIFAPI.removeStoredInstances(nil)
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: nil),
              error as? ThingIFError)
        }
        ThingIFAPI.removeStoredInstances(tags[0])
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[0])) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: tags[0]),
              error as? ThingIFError)
        }
        ThingIFAPI.removeStoredInstances(tags[1])
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[1])) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: tags[1]),
              error as? ThingIFError)
        }
    }

}
