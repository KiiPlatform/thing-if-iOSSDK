//
//  ThingIFAPIOnboardWithThingIDTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIOnboardWithThingIDTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testOnboardWithThingIDFail() throws {
        let expectation = self.expectation(description: "onboardWithThingID")
        let setting = TestSetting()
        let api = setting.api
        let owner = setting.owner

        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            //verify request header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!
            )

            //verify request body
            XCTAssertEqual(
              [
                "thingID": "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5",
                "thingPassword": "dummyPassword",
                "owner": owner.typedID.toString()
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String]
            )

            XCTAssertEqual(
              request.url?.absoluteString,
              setting.app.baseURL + "/thing-if/apps/50a62843/onboardings")
        }

        let dict: [String : Any] = [
          "errorCode" : "INVALID_INPUT_DATA",
          "message" :
            "There are validation errors: password - password is required.",
          "invalidFields":["password": "password is required"]]
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: dict,
            options: .prettyPrinted),
          HTTPURLResponse(
            url:
              URL(string: "https://api-development-jp.internal.kii.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil),
          nil)

        iotSession = MockSession.self
        XCTAssertFalse(api.onboarded)
        api.onboardWith(
          thingID: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5",
          thingPassword: "dummyPassword") { ( target, error) -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  400,
                  errorCode: dict["errorCode"] as! String,
                  errorMessage: dict["message"] as! String
                )
              ),
              error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

    }

    func testOnboardWithThingIDAlreadyOnboardedError() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingID_already_onboarded_error")
        let setting = TestSetting()
        let api = setting.api

        api.target = setting.target
        XCTAssertTrue(api.onboarded)
        api.onboardWith(
          thingID: "dummyThingID",
          thingPassword: "dummyPassword") { (target, error) -> Void in
            XCTAssertEqual(ThingIFError.alreadyOnboarded, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
        XCTAssertTrue(api.onboarded)
    }

    func testOnboardWithThingIDAndOptionsSuccess() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingIDAndOptionsSuccess")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(.standalone)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify request body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "STANDALONE"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String]
            )
        }

        // mock response
        let accessToken = "dummyAccessToken"
        sharedMockSession.mockResponse =
          (try JSONSerialization.data(
             withJSONObject:
               ["thingID": thingID, "accessToken": accessToken],
             options: .prettyPrinted),
           HTTPURLResponse(
             url: URL(string:setting.app.baseURL)!,
             statusCode: 200,
             httpVersion: nil,
             headerFields: nil),
           nil)
        iotSession = MockSession.self

        XCTAssertFalse(setting.api.onboarded)
        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(target!.typedID.id, thingID)
            XCTAssertEqual(target!.accessToken, accessToken)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }

        XCTAssertTrue(setting.api.onboarded)
        XCTAssertEqual(
          setting.api,
          try ThingIFAPI.loadWithStoredInstance(setting.api.tag))
    }

    func testOnboardWithThingIDAndOptions403Error() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingIDAndOptions403Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(.gateway)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "GATEWAY"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String]
            )
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

        XCTAssertFalse(setting.api.onboarded)
        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
            XCTAssertNil(target)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(403, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
        XCTAssertFalse(setting.api.onboarded)
    }

    func testOnboardWithThingIDAndOptions404Error() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingIDAndOptions404Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(.endnode)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "ENDNODE"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String]
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          error: nil)
        iotSession = MockSession.self

        XCTAssertFalse(setting.api.onboarded)
        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
            XCTAssertNil(target)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
        XCTAssertFalse(setting.api.onboarded)
    }

    func testOnboardWithThingIDAndOptions500Error() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingIDAndOptions500Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(.standalone)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              request.url!.absoluteString,
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings")

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
              ],
              request.allHTTPHeaderFields!)

            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "STANDALONE"
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String]
            )
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

        XCTAssertFalse(setting.api.onboarded)
        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
            XCTAssertNil(target)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(500, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
        XCTAssertFalse(setting.api.onboarded)
    }

    func testOnboardWithThingIDAndOptionsTwiceTest() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingIDAndOptionsTwiceTest")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let accessToken = "dummyAccessToken"
        let options = OnboardWithThingIDOptions(.standalone)

        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["thingID": thingID, "accessToken": accessToken],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        XCTAssertFalse(setting.api.onboarded)
        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options){
            (target, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(target)
            XCTAssertEqual(target!.typedID.id, thingID)
            XCTAssertEqual(target!.accessToken, accessToken)
            expectation.fulfill()
        }
        XCTAssertTrue(setting.api.onboarded)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }

        XCTAssertEqual(
          setting.api,
          try ThingIFAPI.loadWithStoredInstance(setting.api.tag))

        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
            XCTAssertNil(target)
            XCTAssertEqual(ThingIFError.alreadyOnboarded, error)
        }

        XCTAssertTrue(setting.api.onboarded)
        XCTAssertEqual(
          setting.api,
          try ThingIFAPI.loadWithStoredInstance(setting.api.tag))
    }

}
