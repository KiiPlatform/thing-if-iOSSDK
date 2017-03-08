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

    func testOnboardWithVendorThingIDSuccess() throws {
        let expectation = self.expectation(
          description: "onboardWithVendorThingID")
        let setting = TestSetting()
        let api = setting.api
        let owner = setting.owner

        let thingProperties = ["key1":"value1", "key2":"value2"]
        let thingType = "LED"
        let vendorThingID = "th.abcd-efgh"
        let thingPassword = "dummyPassword"

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
        // mock request
        sharedMockSession.requestVerifier = makeRequestVerifier() {
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
            self.assertEqualsDictionary(
              [
                "vendorThingID": vendorThingID,
                "thingPassword": thingPassword,
                "owner": owner.typedID.toString(),
                "thingType": thingType,
                "thingProperties": thingProperties
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? [String : Any]
            )
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

        XCTAssertEqual(
          setting.api,
          try ThingIFAPI.loadWithStoredInstance(setting.api.tag))
    }

    func testOnboardWithVendorThingIDAndImplementTag() throws {

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

        sharedMockSession.requestVerifier = makeRequestVerifier {
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
            self.assertEqualsDictionary(
              [
                "vendorThingID": vendorThingID,
                "thingPassword": thingPassword,
                "owner": owner.typedID.toString(),
                "thingType":thingType,
                "thingProperties": thingProperties
              ],
              try JSONSerialization.jsonObject(
                  with: request.httpBody!,
                  options: JSONSerialization.ReadingOptions.allowFragments)
                as? [String : Any])
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
            if error == nil {
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

        XCTAssertEqual(api, try ThingIFAPI.loadWithStoredInstance(api.tag))
    }

    func testOnboardWithVendorThingIDAndOptionsSuccess() throws
    {
        let expectation = self.expectation(
          description: "testOnboardWithVendorThingIDAndOptionsSuccess")
        let setting = TestSetting()

        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let firmwareVersion = "dummyVersion"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            setting.thingType,
            firmwareVersion:  firmwareVersion,
            thingProperties: thingProperties,
            position: .standalone)

        // mock response
        let thingID = "dummyThingID"
        let accessToken = "dummyAccessToken"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["thingID": thingID, "accessToken": accessToken],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier {
            (request) in

            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify request body
            self.assertEqualsDictionary(
              [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "firmwareVersion": firmwareVersion,
                "thingProperties": thingProperties,
                "layoutPosition": "STANDALONE"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? [String : Any])
        }
        iotSession = MockSession.self

        setting.api.onboardWith(
          vendorThingID: vendorThingID,
          thingPassword: password,
          options: options) {
            (target:Target?, error:ThingIFError?) -> Void in

            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(target!.typedID.id, thingID)
            XCTAssertEqual(target!.accessToken, accessToken)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions403Error() throws
    {
        let expectation = self.expectation(
          description: "testOnboardWithVendorThingIDAndOptions403Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            setting.thingType,
            thingProperties: thingProperties,
            position: .gateway)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {
            (request) in

            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            self.assertEqualsDictionary(
              [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "GATEWAY"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? [String : Any])
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboardWith(
            vendorThingID: vendorThingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(403, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions404Error() throws
    {
        let expectation = self.expectation(
          description: "testOnboardWithVendorThingIDAndOptions404Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            setting.thingType,
            thingProperties: thingProperties,
            position: .endnode)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {
            (request) in

            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            self.assertEqualsDictionary(
              [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "ENDNODE"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? [String : Any])
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboardWith(
            vendorThingID: vendorThingID,
            thingPassword: password,
            options: options) { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions500Error()
    {
        let expectation = self.expectation(
          description: "testOnboardWithVendorThingIDAndOptions500Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            setting.thingType,
            thingProperties: thingProperties,
            position: .standalone)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {
            (request) in

            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            self.assertEqualsDictionary(
              [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "STANDALONE"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? [String : Any])
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboardWith(
            vendorThingID: vendorThingID,
            thingPassword: password,
            options: options) { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(500, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

}
