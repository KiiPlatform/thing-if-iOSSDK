//
//  ServerCodeTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ServerCodeTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOptionalNonNil() {
        let actual = ServerCode(
          "endpoint",
          executorAccessToken: "executorAccessToken",
          targetAppID: "targetAppID",
          parameters: ["key" : "value"])

        XCTAssertEqual("endpoint", actual.endpoint)
        XCTAssertEqual("executorAccessToken", actual.executorAccessToken)
        XCTAssertEqual("targetAppID", actual.targetAppID)
        XCTAssertEqual(
          ["key" : "value"],
          actual.parameters as! [String : String])
    }

    func testOptionalNil() {
        let actual = ServerCode("endpoint")

        XCTAssertEqual("endpoint", actual.endpoint)
        XCTAssertNil(actual.executorAccessToken)
        XCTAssertNil(actual.targetAppID)
        XCTAssertNil(actual.parameters)
    }

}
