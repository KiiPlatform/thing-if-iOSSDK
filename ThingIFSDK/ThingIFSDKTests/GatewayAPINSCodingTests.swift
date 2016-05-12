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

    func test()
    {
        let expectation = self.expectationWithDescription("test")
        let setting = TestSetting()

        do {
            let dict = ["accessToken": ACCESSTOKEN]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login("dummy", password: "dummy", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        let data = NSKeyedArchiver.archivedDataWithRootObject(gatewayAPI);
        XCTAssertNotNil(data);

        let decode = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! GatewayAPI;
        XCTAssertNotNil(decode);

        XCTAssertEqual(gatewayAPI.app.appID, decode.app.appID);
        XCTAssertEqual(gatewayAPI.app.appKey, decode.app.appKey);
        XCTAssertEqual(gatewayAPI.app.siteName, decode.app.siteName);
        XCTAssertEqual(gatewayAPI.app.baseURL, decode.app.baseURL);
        XCTAssertEqual(gatewayAPI.gatewayAddress, decode.gatewayAddress);
        XCTAssertEqual(gatewayAPI.getAccessToken(), decode.getAccessToken());
    }
}