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

    func testLoadFromStoredInstanceLowerSDKVersion()
    {
        let expectation = self.expectation(description: "testLoadFromStoredInstanceLowerSDKVersion")
        let setting = TestSetting()

        do {
            let dict = ["accessToken": ACCESSTOKEN]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                                              statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let api = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!, tag: nil)
        api.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        XCTAssertNil(api.tag)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        let baseKey = "GatewayAPI_INSTANCE"
        let versionKey = "GatewayAPI_VERSION"
        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[versionKey] = "0.0.0"
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }

        XCTAssertThrowsError(try GatewayAPI.loadWithStoredInstance()) { error in
            switch error {
            case ThingIFError.apiUnloadable:
                // Succeed.
                break
            default:
                XCTFail("Unexpected exception throwed.")
            }
        }
    }

    func testLoadFromStoredInstanceUpperSDKVersion()
    {
        let expectation = self.expectation(description: "testLoadFromStoredInstanceUpperSDKVersion")
        let setting = TestSetting()

        do {
            let dict = ["accessToken": ACCESSTOKEN]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                                              statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let api = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!, tag: nil)
        api.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        XCTAssertNil(api.tag)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        let baseKey = "GatewayAPI_INSTANCE"
        let versionKey = "GatewayAPI_VERSION"
        if let tempdict = UserDefaults.standard.object(forKey: baseKey) as? NSDictionary {
            let dict  = tempdict.mutableCopy() as! NSMutableDictionary
            dict[versionKey] = "1000.0.0"
            UserDefaults.standard.set(dict, forKey: baseKey)
            UserDefaults.standard.synchronize()
        }

        do {
            let restoreApi = try GatewayAPI.loadWithStoredInstance()

            XCTAssertNotNil(restoreApi)
            XCTAssertNil(restoreApi!.tag)
            XCTAssertEqual(api.app.appID, restoreApi!.app.appID)
            XCTAssertEqual(api.app.appKey, restoreApi!.app.appKey)
            XCTAssertEqual(api.gatewayAddress, restoreApi!.gatewayAddress)
            XCTAssertEqual(api.accessToken, restoreApi!.accessToken)
        } catch (_) {
            XCTFail("should not throw error")
        }
    }
}
