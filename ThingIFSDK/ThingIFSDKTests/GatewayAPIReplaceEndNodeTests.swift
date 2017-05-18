//
//  GatewayAPIReplaceEndNodeTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPIReplaceEndNodeTests: GatewayAPITestBase {

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
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)",
                    "Content-Type": MediaType.mediaTypeJson.rawValue
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
                [ "vendorThingID": vendorThingID ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as! Dictionary)
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

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        let expectation = self.expectation(description: "testNoLoggedInError")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(ThingIFError.userIsNotLoggedIn, error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testEmptyThingIDError() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testEmptyThingIDError")
        let vendorThingID = "dummyVendorThingID"

        api.replaceEndNode(
            "",
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                  ThingIFError.invalidArgument(message: "thingID is empty."),
                  error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testEmptyVendorThingIDError() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testEmptyThingIDError")
        let thingID = "dummyThingID"

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: "",
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                  ThingIFError.invalidArgument(
                    message: "vendorThingID is empty."),
                  error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test400Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test400Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)",
                    "Content-Type": MediaType.mediaTypeJson.rawValue
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
                [ "vendorThingID": vendorThingID ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as! Dictionary)
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

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(400, errorCode: "", errorMessage: "")),
                    error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test401Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test401Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)",
                    "Content-Type": MediaType.mediaTypeJson.rawValue
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
                [ "vendorThingID": vendorThingID ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as! Dictionary)
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

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(401, errorCode: "", errorMessage: "")),
                    error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test404Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test404Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)",
                    "Content-Type": MediaType.mediaTypeJson.rawValue
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
                [ "vendorThingID": vendorThingID ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as! Dictionary)
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(404, errorCode: "", errorMessage: "")),
                    error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test409Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test409Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)",
                    "Content-Type": MediaType.mediaTypeJson.rawValue
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
                [ "vendorThingID": vendorThingID ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as! Dictionary)
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

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(409, errorCode: "", errorMessage: "")),
                    error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test503Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test503Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)",
                request.url!.absoluteString)
            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(self.ACCESSTOKEN)",
                    "Content-Type": MediaType.mediaTypeJson.rawValue
                ],
                request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
                [ "vendorThingID": vendorThingID ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as! Dictionary)
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 503,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(503, errorCode: "", errorMessage: "")),
                    error)
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
