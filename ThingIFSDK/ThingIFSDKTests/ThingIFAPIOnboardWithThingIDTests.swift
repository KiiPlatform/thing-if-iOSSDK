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
                "Authorization" : "Bearer \(owner.accessToken)",
                "Content-Type" : "application/vnd.kii.OnboardingWithThingIDByOwner+json",
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader
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
        api.onboardWith(
          thingID: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5",
          thingPassword: "dummyPassword") { ( target, error) -> Void in
            if error == nil {
                XCTFail("error must not nil")
                return
            }
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
                XCTAssertEqual(
                  dict["errorCode"] as! String,
                  actualErrorResponse.errorCode)
                XCTAssertEqual(
                  dict["message"] as! String,
                  actualErrorResponse.errorMessage)
            default:
                XCTFail("invalid error")
                break
            }

            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }

    func testOnboardWithThingIDAlreadyOnboardedError() throws {
        let expectation = self.expectation(
          description: "testOnboardWithThingID_already_onboarded_error")
        let setting = TestSetting()
        let api = setting.api

        api.target = setting.target
        api.onboardWith(
          thingID: "dummyThingID",
          thingPassword: "dummyPassword") { (target, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .alreadyOnboarded:
                    break
                default:
                    XCTFail("should be ALREADY_ONBOARDED error")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
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
            if error != nil {
                XCTFail("execution timeout")
            }
        }

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

        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
            XCTAssertNil(target)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(403, actualErrorResponse.httpStatusCode)
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

        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
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

        setting.api.onboardWith(
          thingID: thingID,
          thingPassword: password,
          options: options) {
            (target, error) in
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

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
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
            XCTAssertNotNil(error)
            switch error! {
            case .alreadyOnboarded:
                break
            default:
                XCTFail("unexpected error: \(error)")
            }
        }

        XCTAssertEqual(
          setting.api,
          try ThingIFAPI.loadWithStoredInstance(setting.api.tag))
    }

}