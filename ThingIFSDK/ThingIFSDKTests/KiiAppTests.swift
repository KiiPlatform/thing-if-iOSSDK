    //
//  KiiAppTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class KiiAppTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitializeWithSite() {
        let testCases: [(actual: Site, expected: Site)] =
          [(.us, .us), (.jp, .jp), (.cn3, .cn3), (.sg, .sg), (.eu, .eu)]

        for (index, testCase) in testCases.enumerated() {
            let (actual, expected) = testCase
            let app = KiiApp("appID", appKey: "appKey", site: actual)
            XCTAssertEqual("appID", app.appID, "\(index)")
            XCTAssertEqual("appKey", app.appKey, "\(index)")
            XCTAssertEqual(expected.getHostName(), app.hostName, "\(index)")
            XCTAssertEqual(expected.getBaseUrl(), app.baseURL, "\(index)")
            XCTAssertEqual(expected.getName(), app.siteName, "\(index)")
        }
    }

    func testInitializeWithOptinalNonNil() {
        let actual = KiiApp(
          "appID",
          appKey: "appKey",
          hostName: "test.com",
          urlSchema: "https",
          siteName: "dummy",
          port: 1)
        XCTAssertEqual("appID", actual.appID)
        XCTAssertEqual("appKey", actual.appKey)
        XCTAssertEqual("test.com", actual.hostName)
        XCTAssertEqual("https://test.com:1", actual.baseURL)
        XCTAssertEqual("dummy", actual.siteName)
    }

    func testInitializeWithOptinalNil() {
        let actual = KiiApp(
          "appID",
          appKey: "appKey",
          hostName: "test.com")
        XCTAssertEqual("appID", actual.appID)
        XCTAssertEqual("appKey", actual.appKey)
        XCTAssertEqual("test.com", actual.hostName)
        XCTAssertEqual("https://test.com", actual.baseURL)
        XCTAssertEqual("CUSTOM", actual.siteName)
    }
}
