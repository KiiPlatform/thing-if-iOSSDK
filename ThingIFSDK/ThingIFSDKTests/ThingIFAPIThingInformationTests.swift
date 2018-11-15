//
//  ThingIFAPIThingInformationTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/21.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

import XCTest
@testable import ThingIF

class ThingIFAPIThingInformationTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testGetVendorThingIDSuccess() throws {
        let expectation =
          self.expectation(description: "testGetVendorThingIDSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/api/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/vendor-thing-id",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        let vendorThingID = "dummyVendorThingID"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["_vendorThingID": vendorThingID],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getVendorThingID() { gotID, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(gotID, vendorThingID)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testGetVendorThingID404Error()
    {
        let expectation =
          self.expectation(description: "testGetVendorThingID404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/api/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/vendor-thing-id",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
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

        setting.api.getVendorThingID() { gotID, error -> Void in
            XCTAssertNil(gotID)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateVendorThingIDSuccess() {
        let expectation =
          self.expectation(description: "testUpdateVendorThingIDSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/api/apps/\(setting.app.appID)/things/\(target.typedID.id)/vendor-thing-id",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.VendorThingIDUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(
          vendorThingID: newVendorThingID,
          password: newPassword) { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateVendorThingID400Error() {
        let expectation =
          self.expectation(description: "testUpdateVendorThingID400Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/api/apps/\(setting.app.appID)/things/\(target.typedID.id)/vendor-thing-id",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.VendorThingIDUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(
          vendorThingID: newVendorThingID,
          password: newPassword) { error -> Void in
            XCTAssertNotNil(error)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(400, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateVendorThingID409Error() {
        let expectation =
          self.expectation(description: "testUpdateVendorThingID409Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual("\(setting.api.baseURL)/api/apps/\(setting.app.appID)/things/\(target.typedID.id)/vendor-thing-id", request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.VendorThingIDUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 409,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(
          vendorThingID: newVendorThingID,
          password: newPassword) { error -> Void in
            XCTAssertNotNil(error)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(409, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateVendorThingIDWithEmptyVendorThingIDError() {
        let expectation = self.expectation(
          description: "testUpdateVendorThingIDWithEmptyVendorThingIDError")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = ""
        let newPassword = "dummyPassword"

        // perform onboarding
        api.target = target

        setting.api.update(
          vendorThingID: newVendorThingID,
          password: newPassword) { error -> Void in
            XCTAssertEqual(
              ThingIFError.invalidArgument(
                message: "vendorThingID is empty."),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateVendorThingIDWithEmptyPasswordError() {
        let expectation = self.expectation(
          description: "testUpdateVendorThingIDWithEmptyPasswordError")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = ""

        // perform onboarding
        api.target = target

        setting.api.update(
          vendorThingID: newVendorThingID,
          password: newPassword) { error -> Void in
            XCTAssertEqual(
              ThingIFError.invalidArgument(
                message: "password is empty."),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetFirmwareVersionSuccess() throws {
        let expectation =
          self.expectation(description: "testGetFirmwareVersionSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/firmware-version",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        let expectedFirmwareVersion = "V1"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["firmwareVersion": expectedFirmwareVersion],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getFirmwareVersion() { firmwareVersion, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(firmwareVersion, expectedFirmwareVersion)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetFirmwareVersionSuccessNil() throws {
        let expectation =
          self.expectation(description: "testGetFirmwareVersionSuccessNil")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/firmware-version",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response

        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["errorCode" : "THING_WITHOUT_FIRMWARE_VERSION"],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getFirmwareVersion() { firmwareVersion, error -> Void in
            XCTAssertNil(error)
            XCTAssertNil(firmwareVersion)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetFirmwareVersionError401() throws {
        let expectation =
          self.expectation(description: "testGetFirmwareVersionError401")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/firmware-version",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response

        // TODO: When server response fixed, change to
        // FIRMWARE_VERSION_NOT_FOUND.
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getFirmwareVersion() { firmwareVersion, error -> Void in
            XCTAssertNil(firmwareVersion)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(401, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetFirmwareVersionError403() throws {
        let expectation =
          self.expectation(description: "testGetFirmwareVersionError403")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/firmware-version",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response

        // TODO: When server response fixed, change to
        // FIRMWARE_VERSION_NOT_FOUND.
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getFirmwareVersion() { firmwareVersion, error -> Void in
            XCTAssertNil(firmwareVersion)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(403, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetFirmwareVersionError404() throws {
        let expectation =
          self.expectation(description: "testGetFirmwareVersionError404")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/firmware-version",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response

        // TODO: When server response fixed, change to
        // FIRMWARE_VERSION_NOT_FOUND.
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getFirmwareVersion() { firmwareVersion, error -> Void in
            XCTAssertNil(firmwareVersion)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetFirmwareVersionError503() throws {
        let expectation =
          self.expectation(description: "testGetFirmwareVersionError503")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/firmware-version",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response

        // TODO: When server response fixed, change to
        // FIRMWARE_VERSION_NOT_FOUND.
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getFirmwareVersion() { firmwareVersion, error -> Void in
            XCTAssertNil(firmwareVersion)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(503, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateFirmwareVersionSuccess() {
        let expectation =
          self.expectation(description: "testUpdateFirmwareVersionSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let firmwareVersion = "V1"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/firmware-version",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingFirmwareVersionUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["firmwareVersion": firmwareVersion],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(firmwareVersion: firmwareVersion) { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateFirmwareVersionWithoutTarget() {
        let expectation = self.expectation(
          description: "testUpdateFirmwareVersionEmptyFirmwareVersion")
        let setting = TestSetting()
        let firmwareVersion = "V1"

        setting.api.update(firmwareVersion: firmwareVersion) { error -> Void in
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateFirmwareVersionEmptyFirmwareVersion() {
        let expectation = self.expectation(
          description: "testUpdateFirmwareVersionEmptyFirmwareVersion")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        setting.api.update(firmwareVersion: "") { error -> Void in
            XCTAssertEqual(
              ThingIFError.invalidArgument(message: "firmwareVersionis empty."),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateFirmwareVersionError403() {
        let expectation =
          self.expectation(description: "testUpdateFirmwareVersionError403")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let firmwareVersion = "V1"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/firmware-version",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingFirmwareVersionUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["firmwareVersion": firmwareVersion],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
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

        setting.api.update(firmwareVersion: firmwareVersion) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(403, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateFirmwareVersionError404() {
        let expectation =
          self.expectation(description: "testUpdateFirmwareVersionError404")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let firmwareVersion = "V1"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/firmware-version",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingFirmwareVersionUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["firmwareVersion": firmwareVersion],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
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
          nil)
        iotSession = MockSession.self

        setting.api.update(firmwareVersion: firmwareVersion) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateFirmwareVersionError503() {
        let expectation =
          self.expectation(description: "testUpdateFirmwareVersionError503")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let firmwareVersion = "V1"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/firmware-version",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingFirmwareVersionUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["firmwareVersion": firmwareVersion],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(firmwareVersion: firmwareVersion) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(503, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetThingTypeSuccess() throws {
        let expectation =
          self.expectation(description: "testGetThingTypeSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/thing-type",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        let expectedThingType = "dummyThingType"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["thingType": expectedThingType],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getThingType() { thingType, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(thingType, expectedThingType)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetThingTypeSuccessNil() throws {
        let expectation =
          self.expectation(description: "testGetThingTypeSuccessNil")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/thing-type",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["errorCode": "THING_WITHOUT_THING_TYPE"],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getThingType() { thingType, error -> Void in
            XCTAssertNil(error)
            XCTAssertNil(thingType)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetThingTypeError401() throws {
        let expectation =
          self.expectation(description: "testGetThingTypeError401")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/thing-type",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getThingType() { thingType, error -> Void in
            XCTAssertNil(thingType)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(401, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetThingTypeError403() throws {
        let expectation =
          self.expectation(description: "testGetThingTypeError403")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/thing-type",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
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

        setting.api.getThingType() { thingType, error -> Void in
            XCTAssertNil(thingType)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(403, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetThingTypeError404() throws {
        let expectation =
          self.expectation(description: "testGetThingTypeError404")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/thing-type",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
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

        setting.api.getThingType() { thingType, error -> Void in
            XCTAssertNil(thingType)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func  testGetThingTypeError503() throws {
        let expectation =
          self.expectation(description: "testGetThingTypeError503")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(setting.target.typedID.id)/thing-type",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getThingType() { thingType, error -> Void in
            XCTAssertNil(thingType)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(503, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingTypeSuccess() {
        let expectation =
          self.expectation(description: "testUpdateThingTypeSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let thingType = "dummyThingType"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/thing-type",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingTypeUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["thingType": thingType],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(thingType: thingType) { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingWithoutTarget() {
        let expectation =
          self.expectation(description: "testUpdateThingWithoutTarget")
        let setting = TestSetting()

        setting.api.update(thingType: "dummyThingType") { error -> Void in
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingEmptyThingType() {
        let expectation =
          self.expectation(description: "testUpdateThingEmptyThingType")
        let setting = TestSetting()
        let target = setting.target

        // perform onboarding
        setting.api.target = target

        setting.api.update(thingType: "") { error -> Void in
            XCTAssertEqual(
              ThingIFError.invalidArgument(message: "thingType is empty."),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingError400() {
        let expectation =
          self.expectation(description: "testUpdateThingError400")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let thingType = "dummyThingType"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/thing-type",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingTypeUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["thingType": thingType],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(thingType: thingType) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(400, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingError403() {
        let expectation =
          self.expectation(description: "testUpdateThingError403")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let thingType = "dummyThingType"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/thing-type",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingTypeUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["thingType": thingType],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
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

        setting.api.update(thingType: thingType) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(403, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingError404() {
        let expectation =
          self.expectation(description: "testUpdateThingError404")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let thingType = "dummyThingType"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/thing-type",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingTypeUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["thingType": thingType],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
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
          nil)
        iotSession = MockSession.self

        setting.api.update(thingType: thingType) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingError409() {
        let expectation =
          self.expectation(description: "testUpdateThingError409")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let thingType = "dummyThingType"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/thing-type",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingTypeUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["thingType": thingType],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 409,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(thingType: thingType) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(409, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testUpdateThingError503() {
        let expectation =
          self.expectation(description: "testUpdateThingError503")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let thingType = "dummyThingType"

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/things/\(target.typedID.id)/thing-type",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.ThingTypeUpdateRequest+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              ["thingType": thingType],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.update(thingType: thingType) { error -> Void in
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(503, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

}
