//
//  GatewayAPIRestoreTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class GatewayAPIRestoreTests: GatewayAPITestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testSuccess() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testSuccess")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/gateway-app/gateway/restore",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)"
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertNil(request.httpBody)
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 204,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.restore({ (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        let expectation = self.expectation(description: "testNoLoggedInError")

        api.restore({ (error:ThingIFError?) -> Void in
            XCTAssertEqual(ThingIFError.userIsNotLoggedIn, error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test400Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test400Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/gateway-app/gateway/restore",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)"
                ],
                request.allHTTPHeaderFields!)
            //verify body
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

        api.restore( { (error:ThingIFError?) -> Void in
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(400, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test401Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test401Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/gateway-app/gateway/restore",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)"
                ],
                request.allHTTPHeaderFields!)
            //verify body
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

        api.restore( { (error:ThingIFError?) -> Void in
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(401, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test409Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test409Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/gateway-app/gateway/restore",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)"
                ],
                request.allHTTPHeaderFields!)
            //verify body
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

        api.restore( { (error:ThingIFError?) -> Void in
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(409, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
