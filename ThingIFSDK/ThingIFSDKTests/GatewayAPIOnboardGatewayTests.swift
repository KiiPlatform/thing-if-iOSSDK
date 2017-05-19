//
//  GatewayAPIOnboardGatewayTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/15.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class GatewayAPIOnboardGatewayTests: GatewayAPITestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() throws {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testSuccess")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"


        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
              "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/onboarding",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(self.ACCESSTOKEN)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["thingID": thingID, "vendorThingID": vendorThingID],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.onboardGateway { gateway, error in
            XCTAssertNil(error)
            XCTAssertEqual(
              GatewayWrapper(thingID, vendorThingID: vendorThingID),
              GatewayWrapper(gateway))
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testNoLoggedInError() {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!)
        let expectation = self.expectation(description: "testNoLoggedInError")

        api.onboardGateway { gateway, error -> Void in
            XCTAssertNil(gateway)
            XCTAssertEqual(ThingIFError.userIsNotLoggedIn, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test400Error() throws {
        let api:GatewayAPI = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test400Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
              "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/onboarding",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(self.ACCESSTOKEN)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.onboardGateway { gateway, error -> Void in
            XCTAssertNil(gateway)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(400, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test401Error() throws {
        let api:GatewayAPI = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test401Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path

            XCTAssertEqual(
              "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/onboarding",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(self.ACCESSTOKEN)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.onboardGateway { gateway, error in
            XCTAssertNil(gateway)
            XCTAssertNotNil(error)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(401, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test409Error() throws {
        let api:GatewayAPI = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test409Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
              "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/onboarding",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(self.ACCESSTOKEN)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 409,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.onboardGateway { gateway, error in
            XCTAssertNil(gateway)
            XCTAssertNotNil(error)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(409, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test503Error() throws {
        let api:GatewayAPI = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test503Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier(){ request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
              "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/onboarding",
              request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(self.ACCESSTOKEN)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(
              string:api.gatewayAddress.absoluteString)!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.onboardGateway { gateway, error in
            XCTAssertNil(gateway)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(503, errorCode: "", errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

}
