//
//  GatewayAPILoginTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/15.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPILoginTests: GatewayAPITestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() throws {
        let expectation = self.expectation(description: "testSuccess")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
              "\(setting.app.baseURL)/\(setting.app.siteName)/token",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Basic " +
                  "\(setting.app.appID):\(setting.app.appKey)".data(
                    using: String.Encoding.utf8)!.base64EncodedString(
                    options:
                      NSData.Base64EncodingOptions.lineLength64Characters),
                "Content-Type": "application/json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "username": username,
                "password": password
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String])
        }

        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["accessToken" : ACCESSTOKEN],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        let gatewayAPI = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testEmptyUsernameError() {
        let expectation = self.expectation(
          description: "testEmptyUsernameError")
        let setting = TestSetting()
        let password = "dummyPass"

        let gatewayAPI = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login("", password: password) { error in
            XCTAssertEqual(ThingIFError.unsupportedError, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testEmptyPasswordError() {
        let expectation = self.expectation(
          description: "testEmptyPasswordError")
        let setting = TestSetting()
        let username = "dummyUser"

        let gatewayAPI = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: "") { error in
            XCTAssertEqual(ThingIFError.unsupportedError, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
