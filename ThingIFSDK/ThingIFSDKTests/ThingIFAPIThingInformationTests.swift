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

}
