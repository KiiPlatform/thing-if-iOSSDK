//
//  GetGatewayInformationTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GetGatewayInformationTests: GatewayAPITestBase {

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
        let vendorThingID = "dummyID"
        let expectation = self.expectationWithDescription("testSuccess")

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                // verify path
                let expectedPath = "\(api.gatewayAddress.absoluteString!)/gateway-info"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "authorization": "Bearer \(self.ACCESSTOKEN)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
            }

            // mock response
            let dict = ["vendorThingID": vendorThingID]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                XCTAssertEqual(vendorThingID, info!.vendorThingID)
                expectation.fulfill()
            })
        } catch(_) {
            XCTFail("should not throw error")
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        let expectation = self.expectationWithDescription("testNoLoggedInError")

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(info)
            XCTAssertNotNil(error)
            switch error! {
            case .USER_IS_NOT_LOGGED_IN:
                break
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test401Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("test401Error")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString!)/gateway-info"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
            statusCode: 401, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(info)
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
