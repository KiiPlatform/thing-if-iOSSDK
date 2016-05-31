//
//  GatewayAPIStoredInstanceTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPIStoredInstanceTests: GatewayAPITestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testLoadFromStoredInstance()
    {
        let expectation = self.expectationWithDescription("testLoadFromStoredInstanceWithTag")
        let setting = TestSetting()

        do {
            let dict = ["accessToken": ACCESSTOKEN]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let api = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!, tag: nil)
        api.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        XCTAssertNil(api.tag)

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        do {
            let restoreApi = try GatewayAPI.loadWithStoredInstance()

            XCTAssertNotNil(restoreApi)
            XCTAssertNil(restoreApi!.tag)
            XCTAssertEqual(api.app.appID, restoreApi!.app.appID)
            XCTAssertEqual(api.app.appKey, restoreApi!.app.appKey)
            XCTAssertEqual(api.gatewayAddress, restoreApi!.gatewayAddress)
            XCTAssertEqual(api.getAccessToken(), restoreApi!.getAccessToken())
        } catch (_) {
            XCTFail("should not throw error")
        }
    }

    func testLoadFromStoredInstanceWithTag()
    {
        let expectation = self.expectationWithDescription("testLoadFromStoredInstanceWithTag")
        let setting = TestSetting()
        let tag = "dummyTag"

        do {
            let dict = ["accessToken": ACCESSTOKEN]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let api = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!, tag: tag)
        api.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        XCTAssertEqual(tag, api.tag)

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        do {
            let restoreApi = try GatewayAPI.loadWithStoredInstance(tag)

            XCTAssertNotNil(restoreApi)
            XCTAssertEqual(api.tag, restoreApi!.tag)
            XCTAssertEqual(api.app.appID, restoreApi!.app.appID)
            XCTAssertEqual(api.app.appKey, restoreApi!.app.appKey)
            XCTAssertEqual(api.gatewayAddress, restoreApi!.gatewayAddress)
            XCTAssertEqual(api.getAccessToken(), restoreApi!.getAccessToken())
        } catch (_) {
            XCTFail("should not throw error")
        }
    }
}
