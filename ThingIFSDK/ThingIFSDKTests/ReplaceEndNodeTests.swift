//
//  ReplaceEndNodeTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ReplaceEndNodeTests: GatewayAPITestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testSuccess()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testSuccess")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [ "vendorThingID": vendorThingID];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 204, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
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
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        let expectation = self.expectation(description: "testNoLoggedInError")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .userIsNotLoggedIn:
                    break
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmptyThingIDError()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testEmptyThingIDError")
        let vendorThingID = "dummyVendorThingID"

        api.replaceEndNode(
            "",
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .unsupportedError:
                    break
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmptyVendorThingIDError()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testEmptyThingIDError")
        let thingID = "dummyThingID"

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: "",
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .unsupportedError:
                    break
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test400Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test400Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [ "vendorThingID": vendorThingID];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 400, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test401Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test401Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [ "vendorThingID": vendorThingID];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 401, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test404Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test404Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [ "vendorThingID": vendorThingID];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 404, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test409Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test409Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [ "vendorThingID": vendorThingID];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 409, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(409, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test503Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test503Error")
        let thingID = "dummyThingID"
        let vendorThingID = "dummyVendorThingID"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/THING_ID:\(thingID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [ "vendorThingID": vendorThingID];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 503, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.replaceEndNode(
            thingID,
            endNodeVendorThingID: vendorThingID,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(503, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unknown error response")
                }
                expectation.fulfill()
            }
        )

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
