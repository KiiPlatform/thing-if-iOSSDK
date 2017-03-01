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
        assertEqualsDictionary(["key" : "value"], actual.parameters)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = ServerCode(coder: decoder)!
        decoder.finishDecoding();

        XCTAssertEqual(actual.endpoint, deserialized.endpoint)
        XCTAssertEqual(
          actual.executorAccessToken,
          deserialized.executorAccessToken)
        XCTAssertEqual(actual.targetAppID, deserialized.targetAppID)
        assertEqualsDictionary(actual.parameters, deserialized.parameters)
    }

    func testOptionalNil() {
        let actual = ServerCode("endpoint")

        XCTAssertEqual("endpoint", actual.endpoint)
        XCTAssertNil(actual.executorAccessToken)
        XCTAssertNil(actual.targetAppID)
        XCTAssertNil(actual.parameters)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = ServerCode(coder: decoder)!
        decoder.finishDecoding();

        XCTAssertEqual(actual.endpoint, deserialized.endpoint)
        XCTAssertEqual(
          actual.executorAccessToken,
          deserialized.executorAccessToken)
        XCTAssertEqual(actual.targetAppID, deserialized.targetAppID)
        assertEqualsDictionary(actual.parameters, deserialized.parameters)
    }

}
