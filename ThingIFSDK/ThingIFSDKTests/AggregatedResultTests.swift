//
//  AggregatedResultTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/10.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class AggregatedResultTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInt() {
        let from = Date()
        let to = Date(timeInterval: 86400, since: from)
        let createdAt = Date()
        let actual = AggregatedResult(
          1,
          timeRange: TimeRange(from, to: to),
          aggregatedObjects: [
            HistoryState(["key1": "value1"], createdAt: createdAt)
          ]
        )

        XCTAssertEqual(1, actual.value)
        XCTAssertEqual(from, actual.timeRange.from)
        XCTAssertEqual(to, actual.timeRange.to)
        XCTAssertEqual(1, actual.aggregatedObjects.count)
        assertEqualsDictionary(
          ["key1": "value1"],
          actual.aggregatedObjects[0].state)
        XCTAssertEqual(createdAt, actual.aggregatedObjects[0].createdAt)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = AggregatedResult<Int>(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.value, deserialized.value)
        XCTAssertEqual(actual.timeRange.from, deserialized.timeRange.from)
        XCTAssertEqual(actual.timeRange.to, deserialized.timeRange.to)
        XCTAssertEqual(
          actual.aggregatedObjects.count,
          deserialized.aggregatedObjects.count)
        assertEqualsDictionary(
          actual.aggregatedObjects[0].state,
          deserialized.aggregatedObjects[0].state)
        XCTAssertEqual(
          actual.aggregatedObjects[0].createdAt,
          deserialized.aggregatedObjects[0].createdAt)
    }

    func testDouble() {
        let from = Date()
        let to = Date(timeInterval: 86400, since: from)
        let createdAt = Date()
        let actual = AggregatedResult(
          1.0001,
          timeRange: TimeRange(from, to: to),
          aggregatedObjects: [
            HistoryState(["key1": "value1"], createdAt: createdAt)
          ]
        )

        XCTAssertEqual(1.0001, actual.value)
        XCTAssertEqual(from, actual.timeRange.from)
        XCTAssertEqual(to, actual.timeRange.to)
        XCTAssertEqual(1, actual.aggregatedObjects.count)
        assertEqualsDictionary(
          ["key1": "value1"],
          actual.aggregatedObjects[0].state)
        XCTAssertEqual(createdAt, actual.aggregatedObjects[0].createdAt)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = AggregatedResult<Double>(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.value, deserialized.value)
        XCTAssertEqual(actual.timeRange.from, deserialized.timeRange.from)
        XCTAssertEqual(actual.timeRange.to, deserialized.timeRange.to)
        XCTAssertEqual(
          actual.aggregatedObjects.count,
          deserialized.aggregatedObjects.count)
        assertEqualsDictionary(
          actual.aggregatedObjects[0].state,
          deserialized.aggregatedObjects[0].state)
        XCTAssertEqual(
          actual.aggregatedObjects[0].createdAt,
          deserialized.aggregatedObjects[0].createdAt)
    }
}
