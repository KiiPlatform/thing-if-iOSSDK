//
//  GatewayAPINSCodingTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPINSCodingTests: GatewayAPITestBase {

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
        let expectation = self.expectation(description: "testSuccess")
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

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        let data = NSKeyedArchiver.archivedData(withRootObject: gatewayAPI);
        XCTAssertNotNil(data);

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! GatewayAPI;
        XCTAssertNotNil(decode);

        XCTAssertEqual(gatewayAPI.app.appID, decode.app.appID);
        XCTAssertEqual(gatewayAPI.app.appKey, decode.app.appKey);
        XCTAssertEqual(gatewayAPI.app.siteName, decode.app.siteName);
        XCTAssertEqual(gatewayAPI.app.baseURL, decode.app.baseURL);
        XCTAssertEqual(gatewayAPI.gatewayAddress, decode.gatewayAddress);
        XCTAssertEqual(gatewayAPI.accessToken, decode.accessToken);
    }
}
