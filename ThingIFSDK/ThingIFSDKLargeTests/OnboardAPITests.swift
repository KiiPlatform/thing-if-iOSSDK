//
//  OnboardAPITests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardTestSetting: NSObject {
    let appID: String
    let appKey: String
    let hostName: String
    let tag: String?

    override init() {
        let path = NSBundle(
            forClass:TestSetting.self).pathForResource(
                "TestSetting",
                ofType:"plist")

        let dict: Dictionary = NSDictionary(
            contentsOfFile: path!) as! Dictionary<String, AnyObject>

        self.appID = dict["appID"] as! String
        self.appKey = dict["appKey"] as! String
        self.hostName = dict["hostName"] as! String
        self.tag = nil
    }
}

class OnboardAPITests: XCTestCase {

    internal let TEST_TIMEOUT = 5.0
    internal let DEMO_THING_TYPE = "LED"
    internal let DEMO_SCHEMA_NAME = "SmartLightDemo"
    internal let DEMO_SCHEMA_VERSION = 1

    internal var app: App?
    internal var api: ThingIFAPI?
    internal var userInfo: Dictionary<String, AnyObject>?
    internal let setting = OnboardTestSetting();

    override func setUp() {
        super.setUp()

        let setting = self.setting
        self.userInfo = createPseudoUser(
            setting.appID,
            appKey: setting.appKey,
            hostName: setting.hostName)
        let userInfo: Dictionary<String, AnyObject> = self.userInfo!
        let owner = Owner(
            typedID: TypedID(
                type: "user",
                id: userInfo["userID"]! as! String),
            accessToken: userInfo["_accessToken"]! as! String)
        let app = AppBuilder(
            appID: setting.appID,
            appKey: setting.appKey,
            hostName: setting.hostName).build()
        let api = ThingIFAPIBuilder(
            app: app,
            owner: owner,
            tag: setting.tag).build()

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

    func createPseudoUser(
        appID: String,
        appKey: String,
        hostName: String) -> Dictionary<String, AnyObject> {
            let request = NSMutableURLRequest(
                URL: NSURL(string: "https://\(hostName)/api/apps/\(appID)/users")!)
            request.HTTPMethod = "POST"
            request.addValue(appID, forHTTPHeaderField: "X-Kii-AppID")
            request.addValue(appKey, forHTTPHeaderField: "X-Kii-AppKey")
            request.addValue(
                "application/vnd.kii.RegistrationAndAuthorizationRequest+json",
                forHTTPHeaderField: "Content-Type")
            request.HTTPBody =
                ("{}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)

            let expectation = self.expectationWithDescription("Create user")

            let session =
            NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            var data: NSData?
            let dataTask = session.dataTaskWithRequest(
                request,
                completionHandler: { (receivedData, response, error) -> Void in
                    data = receivedData
                    expectation.fulfill()
            })
            dataTask.resume()
            self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
                if error != nil {
                    XCTFail("error")
                }
            }

            return try! NSJSONSerialization.JSONObjectWithData(
                data!,
                options:.AllowFragments) as! Dictionary<String, AnyObject>
    }

    func deletePseudoUser(
        appID: String,
        appKey: String,
        userID: String,
        accessToken: String,
        hostName: String) -> Void {
            let request = NSMutableURLRequest(
                URL: NSURL(string: "https://\(hostName)/api/apps/\(appID)/users/\(userID)")!)
            request.HTTPMethod = "DELETE"
            request.addValue(appID, forHTTPHeaderField: "X-Kii-AppID")
            request.addValue(appKey, forHTTPHeaderField: "X-Kii-AppKey")
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            let expectation = self.expectationWithDescription("Delete user")

            let session =
            NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let dataTask = session.dataTaskWithRequest(
                request,
                completionHandler: { (receivedData, response, error) -> Void in
                    XCTAssertEqual(204, (response as! NSHTTPURLResponse).statusCode)
                    expectation.fulfill()
            })
            dataTask.resume()
            self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
                if error != nil {
                    XCTFail("error")
                }
            }
    }

    func testOnboardWithVendorThingIDSuccess() {
        let expectation = self.expectationWithDescription("testOnboardWithVendorThingIDSuccess")
        let vendorThingID = "vid-" + String(NSDate.init().timeIntervalSince1970)
        let options = OnboardWithVendorThingIDOptions(
            thingType: DEMO_THING_TYPE,
            thingProperties: nil,
            position: LayoutPosition.STANDALONE)
        self.api?.onboardWithVendorThingID(
            vendorThingID,
            thingPassword: "password",
            options: options,
            completionHandler: {
                (target, error) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual("thing", target!.typedID.type)
                XCTAssertNotEqual(target!.accessToken, nil)
                expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }
    }

    func testOnboardWithThingIDSuccess() {
        let expectation = self.expectationWithDescription("testOnboardWithThingIDSuccess")
        let thingID = "th.9980daa00022-b539-6e11-bfd5-034b3f22"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.STANDALONE)
        self.api?.onboardWithThingID(
            thingID,
            thingPassword: "password",
            options: options,
            completionHandler: {
                (target, error) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual("thing", target!.typedID.type)
                XCTAssertEqual(thingID, target!.typedID.id)
                XCTAssertNotEqual(target!.accessToken, nil)
                expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }
    }

    func testOnboardEndnodeWithGatewaySuccess() {
        var expectation = self.expectationWithDescription(
                              "testOnboardEndnodeWithGatewaySuccess")
        // Register gateway.
        let gatewayVendorThingID =
            "gvid-" + String(NSDate.init().timeIntervalSince1970)
        self.api!.onboardWithVendorThingID(
            gatewayVendorThingID,
            thingPassword: "password",
            options: OnboardWithVendorThingIDOptions(
                       thingType: DEMO_THING_TYPE,
                       position: LayoutPosition.GATEWAY),
            completionHandler: {
                (target, error) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual("thing", target?.typedID.type)
                XCTAssertNotNil(target?.accessToken)
                expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription(
                          "testOnboardEndnodeWithGatewaySuccess")
        let endnodeVendorThingID =
            "vid-" + String(NSDate.init().timeIntervalSince1970)
        let pendingEndnode = PendingEndNode(
                              json: ["vendorThingID" : endnodeVendorThingID])
        self.api!.onboardEndnodeWithGateway(
            pendingEndnode,
            endnodePassword: "password",
            options: nil,
            completionHandler: {
                (target, error) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(target)
                XCTAssertEqual("thing", target?.typedID.type)
                XCTAssertNotNil(target?.accessToken)
                expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }
    }

}
