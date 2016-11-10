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
        let expectation = self.expectation(description: "testSuccess")

        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                // verify path
                let expectedPath = "\(api.gatewayAddress.absoluteString)/gateway-info"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "authorization": "Bearer \(self.ACCESSTOKEN)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }

            // mock response
            let dict = ["vendorThingID": vendorThingID]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

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

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(info)
            XCTAssertNotNil(error)
            switch error! {
            case .userIsNotLoggedIn:
                break
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

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

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/gateway-info"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 401, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.getGatewayInformation( { (info:GatewayInformation?, error:ThingIFError?) -> Void in
            XCTAssertNil(info)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
