//
//  GetGatewayInformationTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class GetGatewayInformationTests: GatewayAPITestBase {

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
        let vendorThingID = "dummyID"
        let expectation = self.expectation(description: "testSuccess")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
                "\(api.gatewayAddress.absoluteString)/gateway-info",
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
            try JSONSerialization.data(
                withJSONObject:
                [ "vendorThingID" : vendorThingID],
                options: .prettyPrinted),
            HTTPURLResponse(
                url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(info)
            XCTAssertEqual(vendorThingID, info!.vendorThingID)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api = GatewayAPI(setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        let expectation = self.expectation(description: "testNoLoggedInError")

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(info)
            XCTAssertEqual(ThingIFError.userIsNotLoggedIn, error)
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
                "\(api.gatewayAddress.absoluteString)/gateway-info",
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

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(info)
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
}
