//
//  GatewayAPIPersistenceTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/13.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPIPersistenceTests: GatewayAPITestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testLoadFromStoredInstance() throws {
        let expectation = self.expectation(
          description: "testLoadFromStoredInstanceWithTag")
        let setting = TestSetting()

        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["accessToken": "accessToken"],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        let api = GatewayAPI(
          setting.app,
          gatewayAddress: URL(string: setting.app.baseURL)!,
          tag: nil)
        api.login(
          "dummy",
          password: "dummy") { error -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        XCTAssertNil(api.tag)

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }

        XCTAssertEqual(api, try GatewayAPI.loadWithStoredInstance())
    }

}
