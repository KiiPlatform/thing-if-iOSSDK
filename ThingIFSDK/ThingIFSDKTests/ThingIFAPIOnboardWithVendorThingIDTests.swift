//
//  ThingIFAPIOnboardWithVendorThingIDTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/07.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIOnboardWithVendorThingIDTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testOnboardWithVendorThingIDSuccess() {
        let expectation = self.expectation(
          description: "onboardWithVendorThingID")
        let setting = TestSetting()
        let api = setting.api
        let owner = setting.owner

        let thingProperties = ["key1":"value1", "key2":"value2"]
        let thingType = "LED"
        let vendorThingID = "th.abcd-efgh"
        let thingPassword = "dummyPassword"

        do {
            // mock response
            sharedMockSession.mockResponse = (
              try JSONSerialization.data(
                withJSONObject: [
                  "accessToken": setting.owner.accessToken,
                  "thingID": setting.target.typedID.id],
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string: "https://\(setting.app.hostName)")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
              nil)
        } catch {
            XCTFail("json must be serializable")
            return
        }
        // mock request
        sharedMockSession.requestVerifier = {
            (request) in
            XCTAssertEqual(
              request.url?.absoluteString,
              "\(setting.app.baseURL)/thing-if/apps/50a62843/onboardings")
            XCTAssertEqual(request.httpMethod, "POST")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(owner.accessToken)",
                "Content-Type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify request body
            let requestBody: [String : Any]
            do {
                requestBody = try JSONSerialization.jsonObject(
                  with: request.httpBody!,
                  options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : Any]
            } catch {
                XCTFail("request body must be deserializable.")
                return
            }

            self.assertEqualsDictionary(
              [
                "vendorThingID": vendorThingID,
                "thingPassword": thingPassword,
                "owner": owner.typedID.toString(),
                "thingType": thingType,
                "thingProperties": thingProperties
              ],
              requestBody)
        }
        iotSession = MockSession.self

        api.onboardWith(
          vendorThingID: vendorThingID,
          thingPassword: thingPassword,
          options: OnboardWithVendorThingIDOptions(
            thingType,
            thingProperties: thingProperties)) {
            (target, error) -> Void in
            if error == nil{
                XCTAssertEqual(
                  target!.typedID.toString(),
                  setting.target.typedID.toString())
                XCTAssertEqual(
                  target!.typedID.toString(),
                  setting.target.typedID.toString())
                XCTAssertEqual(
                  target!.accessToken,
                  setting.owner.accessToken)
            } else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        do {
            let storedAPI =
              try ThingIFAPI.loadWithStoredInstance(setting.api.tag)
            XCTAssertEqual(setting.api, storedAPI)
        } catch {
            XCTFail("fail to load API")
        }
    }

    func testOnboardWithVendorThingIDAndImplementTag() {

        let expectation = self.expectation(
          description: "onboardWithVendorThingID")
        let setting = TestSetting()
        let owner = setting.owner
        let app = setting.app

        let thingType = "LED"
        let vendorThingID = "th.abcd-efgh"
        let thingPassword = "dummyPassword"
        let thingProperties = ["key1":"value1", "key2":"value2"]

        let api = ThingIFAPI(app, owner:owner, tag:"target1")

        // mock response
        do {
            sharedMockSession.mockResponse = (
              try JSONSerialization.data(
                withJSONObject: [
                  "accessToken": setting.owner.accessToken,
                  "thingID": setting.target.typedID.id],
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string: "https://\(setting.app.hostName)")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
              nil)
        } catch {
            XCTFail("json must be serializable")
            return
        }

        sharedMockSession.requestVerifier = {
            (request) in
            XCTAssertEqual(
              request.url?.absoluteString,
              "\(setting.app.baseURL)/thing-if/apps/50a62843/onboardings")
            XCTAssertEqual(request.httpMethod, "POST")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(owner.accessToken)",
                "Content-Type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify request body
            let requestBody: [String : Any]
            do {
                requestBody = try JSONSerialization.jsonObject(
                  with: request.httpBody!,
                  options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : Any]
            } catch {
                XCTFail("request body must be deserializable.")
                return
            }

            self.assertEqualsDictionary(
              [
                "vendorThingID": vendorThingID,
                "thingPassword": thingPassword,
                "owner": owner.typedID.toString(),
                "thingType":thingType,
                "thingProperties": thingProperties
              ],
              requestBody)
        }
        iotSession = MockSession.self

        // verify request
        api.onboardWith(
          vendorThingID:vendorThingID,
          thingPassword: thingPassword,
          options: OnboardWithVendorThingIDOptions(
            thingType,
            thingProperties: thingProperties)) {
            ( target, error) -> Void in
            if error == nil{
                XCTAssertEqual(
                  target!.typedID.toString(),
                  setting.target.typedID.toString())
                XCTAssertEqual(
                  target!.typedID.toString(),
                  setting.target.typedID.toString())
                XCTAssertEqual(
                  target!.accessToken,
                  setting.owner.accessToken)
            }else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        do {
            let storedAPI =
              try ThingIFAPI.loadWithStoredInstance(api.tag)
            XCTAssertEqual(api, storedAPI)
        } catch {
            XCTFail("fail to load API")
        }
    }

}
