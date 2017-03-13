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

    func getLoggedInGatewayAPI(
      _ file: StaticString = #file,
      _ line: UInt = #line) throws -> GatewayAPI
    {

        if sharedGatewayAPI == nil {
            let expectation = self.expectation(
              description: "getLoggedInGatewayAPI")
            let setting = TestSetting()

            sharedMockSession.mockResponse = (
              try JSONSerialization.data(
                withJSONObject: ["accessToken": ACCESSTOKEN],
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
              nil)
            iotSession = MockSession.self

            let gatewayAPI = GatewayAPI(
              setting.app,
              gatewayAddress: URL(string: setting.app.baseURL)!)
            gatewayAPI.login(
              "dummy",
              password: "dummy") { error -> Void in
                XCTAssertNil(error, file: file, line: line)
                expectation.fulfill()
            }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout", file: file, line: line)
        }
        sharedGatewayAPI = gatewayAPI
    }

    return sharedGatewayAPI
}
}
