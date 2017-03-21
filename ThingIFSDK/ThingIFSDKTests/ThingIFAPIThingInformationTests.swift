//
//  ThingIFAPIThingInformationTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/21.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

import XCTest
@testable import ThingIFSDK

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
            XCTAssertEqual(ThingIFError.unsupportedError, error)
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
            XCTAssertEqual(ThingIFError.unsupportedError, error)
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
}
