//
//  GetVendorThingIDTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GetVendorThingIDTests: SmallTestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testGetVendorThingIDSuccess()
    {
        let expectation = self.expectation(description: "testGetVendorThingIDSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api._target = target

        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                // verify path
                let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.appID)/things/\(setting.target.typedID.id)/vendor-thing-id"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "X-kii-appid": setting.appID,
                    "x-kii-appkey": setting.appKey,
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }

            // mock response
            let vendorThingID = "dummyVendorThingID"
            let dict = ["_vendorThingID": vendorThingID]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.getVendorThingID( { (gotID: String?, error: ThingIFError?) -> Void in
                XCTAssertNil(error)
                XCTAssertEqual(gotID, vendorThingID)
                expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetVendorThingID404Error()
    {
        let expectation = self.expectation(description: "testGetVendorThingID404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.appID)/things/\(setting.target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 404, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.getVendorThingID( { (gotID: String?, error: ThingIFError?) -> Void in
            XCTAssertNil(gotID)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
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
