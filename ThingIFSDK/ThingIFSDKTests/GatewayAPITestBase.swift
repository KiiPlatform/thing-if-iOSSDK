//
//  GatewayAPITestBase.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

private var sharedGatewayAPI : GatewayAPI!

class GatewayAPITestBase: SmallTestBase {
    let ACCESSTOKEN: String = "token-0000-1111-aaaa-bbbb"

    func getLoggedInGatewayAPI() -> GatewayAPI {

        if sharedGatewayAPI == nil {
            let expectation = self.expectation(description: "getLoggedInGatewayAPI")
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

            sharedGatewayAPI = gatewayAPI

        }

        return sharedGatewayAPI
    }
}
