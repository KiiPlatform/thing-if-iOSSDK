//
//  GatewayAPIListPendingEndNodesTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPIListPendingEndNodesTests: GatewayAPITestBase {

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
        let propeties:Dictionary<String, Any> = [ "debug": true ]
        let list = [
            [ "vendorThingID": "abcd-1234" ],
            [ "vendorThingID": "efgh-5678" ],
            [ "vendorThingID": "ijkl-9012", "thingProperties": propeties ]
        ]

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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
                ["results": list],
                options: .prettyPrinted),
            HTTPURLResponse(
                url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(nodes)
            XCTAssertEqual(3, nodes!.count)
            XCTAssertEqual(list[0]["vendorThingID"] as? String, nodes![0].vendorThingID)
            XCTAssertNil(nodes![0].thingProperties)
            XCTAssertEqual(list[1]["vendorThingID"] as? String, nodes![1].vendorThingID)
            XCTAssertNil(nodes![1].thingProperties)
            XCTAssertEqual(list[2]["vendorThingID"] as? String, nodes![2].vendorThingID)
            self.verifyDict(propeties, actualDict: nodes![2].thingProperties)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testEmpty() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testEmpty")
        let list: [String : Any] = [ : ]

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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
                ["results": list],
                options: .prettyPrinted),
            HTTPURLResponse(
                url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(nodes)
            XCTAssertEqual(0, nodes!.count)
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

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
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
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertEqual(ThingIFError.errorResponse(
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
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertEqual(ThingIFError.errorResponse(
                required: ErrorResponse(401, errorCode: "", errorMessage: "")),
                           error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test404Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test404Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertEqual(ThingIFError.errorResponse(
                required: ErrorResponse(404, errorCode: "", errorMessage: "")),
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
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertEqual(ThingIFError.errorResponse(
                required: ErrorResponse(409, errorCode: "", errorMessage: "")),
                           error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func test503Error() throws
    {
        let api = try getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test503Error")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending",
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
                statusCode: 503,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertEqual(ThingIFError.errorResponse(
                required: ErrorResponse(503, errorCode: "", errorMessage: "")),
                           error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
