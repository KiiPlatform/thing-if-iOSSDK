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
    override class func defaultTestSuite() -> XCTestSuite { //TODO: This is temporary to mark crashed test, remove this later

        let testSuite = XCTestSuite(name: NSStringFromClass(self))

        return testSuite
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
            XCTAssertNil(error, "execution timeout")
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
            XCTAssertNil(error, "execution timeout")
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
            XCTAssertNil(error, "execution timeout")
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
            XCTAssertNil(error, "execution timeout")
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
            XCTAssertNil(error, "execution timeout")
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
            XCTAssertNil(error, "execution timeout")
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

    func testOverwriteSavedInstanceWithOnboard() throws {
        let tag = "tag1"
        let setting = TestSetting()
        let app1 = KiiApp("app001", appKey: "appkey001", site: Site.jp)
        let app2 = KiiApp("app002", appKey: "appkey002", site: Site.us)
        let owner1 = Owner(
          TypedID(.user, id: "user001"),
          accessToken: "token001")
        let owner2 = Owner(
          TypedID(.user, id: "user002"),
          accessToken: "token002")

        let api1 = ThingIFAPI(app1, owner:owner1, tag: tag)
        var expectation = self.expectation(
          description: "testOverwriteSavedInstanceWithOnboard")
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
            XCTAssertNil(error, "execution timeout")
        }

        let api2 = ThingIFAPI(app2, owner:owner2, tag: tag)

        expectation = self.expectation(
          description: "testOverwriteSavedInstanceWithOnboard")
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
            XCTAssertNil(error, "execution timeout")
        }

        XCTAssertEqual(api2, try ThingIFAPI.loadWithStoredInstance(tag))
    }

    func testOverwriteSavedInstanceWithOnboard222() throws {
        let setting = TestSetting()
        let api1 = ThingIFAPI(
          setting.app,
          owner:setting.owner,
          tag: "tag1")

        let expectation = self.expectation(
          description: "testOverwriteSavedInstanceWithOnboard")
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
            XCTAssertNil(error, "execution timeout")
        }

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance("tag2")) {
            error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: "tag2"),
              error as? ThingIFError)
        }
    }

    func testInvalidSavedInstance() throws {

        let persistance = UserDefaults.standard
        let baseKey = "ThingIFAPI_INSTANCE"
        let versionKey = "ThingIFAPI_VERSION"
        let sdkVersion = SDKVersion.sharedInstance.versionString
        //clear
        persistance.removeObject(forKey: baseKey)
        persistance.synchronize()
        sleep(1)

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: nil),
              error as! ThingIFError)
        }

        //set invalid object to base key
        persistance.set(1, forKey: baseKey)
        persistance.synchronize()

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: nil),
              error as! ThingIFError)
        }

        //set empty dict to base key
        persistance.set([ : ] as [String : Any], forKey: baseKey)
        persistance.synchronize()

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.apiNotStored(tag: nil),
              error as! ThingIFError)
        }

        //set invalid object type to the persistance
        persistance.set(
          [baseKey : "a", versionKey : sdkVersion],
          forKey: baseKey)
        persistance.synchronize()

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.invalidStoredApi,
              error as! ThingIFError)
        }

        //set invalid object to the persistance
        persistance.set(
          [
            baseKey : NSKeyedArchiver.archivedData(withRootObject: "a"),
            versionKey : sdkVersion
          ],
          forKey: baseKey)
        persistance.synchronize()

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.invalidStoredApi,
              error as! ThingIFError)
        }
    }

    func testLoadFromStoredInstanceNoSDKVersion() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceNoSDKVersion")
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner

        let api = ThingIFAPI(app, owner:owner)

        try setMockResponse4Onboard(
          "access-token-00000001",
          thingID: "th.00000001",
          setting: setting)
        api.onboardWith(
          vendorThingID: "vendor-0001",
          thingPassword: "password1",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        let baseKey = "ThingIFAPI_INSTANCE"
        let versionKey = "ThingIFAPI_VERSION"
        if var dict = UserDefaults.standard.dictionary(forKey: baseKey) {
            dict[versionKey] = nil
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
              ThingIFError.apiUnloadable(
                tag: nil,
                storedVersion: nil,
                minimumVersion: "1.0.0"),
              error as? ThingIFError)
        }
    }

    func testLoadFromStoredInstanceLowerSDKVersion() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceLowerSDKVersion")
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        let tagName = "testLoadFromStoredInstanceLowerSDKVersion"

        let api = ThingIFAPI(app, owner:owner, tag:tagName)

        try setMockResponse4Onboard(
          "access-token-00000001",
          thingID: "th.00000001",
          setting: setting)
        api.onboardWith(
          vendorThingID: "vendor-0001",
          thingPassword: "password1",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        let baseKey = "ThingIFAPI_INSTANCE"
        let versionKey = "ThingIFAPI_VERSION" + "_\(tagName)"
        if var dict = UserDefaults.standard.dictionary(forKey: baseKey) {
            dict[versionKey] = "0.0.0"
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }

        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tagName)) {
            error in
            XCTAssertEqual(
              ThingIFError.apiUnloadable(
                tag: tagName,
                storedVersion: "0.0.0",
                minimumVersion: "1.0.0"),
              error as? ThingIFError)
        }
    }

    func testLoadFromStoredInstanceUpperSDKVersion() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceUpperSDKVersion")
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner

        let api = ThingIFAPI(app, owner:owner)

        try setMockResponse4Onboard(
          "access-token-00000001",
          thingID: "th.00000001",
          setting: setting)
        api.onboardWith(
          vendorThingID: "vendor-0001",
          thingPassword: "password1",
          options: OnboardWithVendorThingIDOptions("smart-light")) {
            (target, error) -> Void in
            XCTAssertNotNil(target)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        let baseKey = "ThingIFAPI_INSTANCE"
        let versionKey = "ThingIFAPI_VERSION"
        if var dict = UserDefaults.standard.dictionary(forKey: baseKey) {
            dict[versionKey] = "1000.0.0"
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }

        XCTAssertEqual(api, try ThingIFAPI.loadWithStoredInstance())
    }

    func testCopyWithTarget() throws {
        let api: ThingIFAPI! = TestSetting().api
        let newTarget = StandaloneThing(
          "newID",
          vendorThingID: "vendor-thing-id-001",
          accessToken: "token-00001")
        let newIotapi = api.copyWithTarget(newTarget)

        XCTAssertNotEqual(
          api.target as? StandaloneThing,
          newIotapi.target as? StandaloneThing)
        XCTAssertEqual(newTarget, newIotapi.target as! StandaloneThing)

        XCTAssertEqual(api.baseURL, newIotapi.baseURL)
        XCTAssertEqual(api.appID, newIotapi.appID)
        XCTAssertEqual(api.appKey, newIotapi.appKey)
        XCTAssertEqual(api.app, newIotapi.app)
        XCTAssertEqual(api.owner, newIotapi.owner)
        XCTAssertEqual(api.installationID, newIotapi.installationID)
        XCTAssertEqual(api.tag, newIotapi.tag)

        let loadedAPI = try ThingIFAPI.loadWithStoredInstance()
        XCTAssertEqual(newIotapi, loadedAPI)

        ThingIFAPI.removeAllStoredInstances()
    }
}
