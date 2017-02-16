//
//  GroupedHistoryStatesQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class GroupedHistoryStatesQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOptinalNotNil() {
        let from = Date()
        let to = Date(timeInterval: 86400, since: from)
        let timeRange = TimeRange(from, to: to)
        let clause = EqualsClauseInQuery("f", intValue: 1)
        let actual = GroupedHistoryStatesQuery(
          "alias",
          timeRange: timeRange,
          clause: clause,
          firmwareVersion: "version")

        XCTAssertEqual("alias", actual.alias)
        assertEqualsTimeRange(timeRange, actual.timeRange)
        assertEqualsQueryClause(clause, actual.clause)
        XCTAssertEqual("version", actual.firmwareVersion)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = GroupedHistoryStatesQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.alias, deserialized.alias)
        assertEqualsTimeRange(actual.timeRange, deserialized.timeRange)
        assertEqualsQueryClause(actual.clause, deserialized.clause)
        XCTAssertEqual(actual.firmwareVersion, deserialized.firmwareVersion)
    }

    func testOptinalNil() {
        let from = Date()
        let to = Date(timeInterval: 86400, since: from)
        let timeRange = TimeRange(from, to: to)
        let actual = GroupedHistoryStatesQuery(
          "alias",
          timeRange: timeRange)

        XCTAssertEqual("alias", actual.alias)
        assertEqualsTimeRange(timeRange, actual.timeRange)
        assertEqualsQueryClause(nil, actual.clause)
        XCTAssertEqual(nil, actual.firmwareVersion)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = GroupedHistoryStatesQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.alias, deserialized.alias)
        assertEqualsTimeRange(actual.timeRange, deserialized.timeRange)
        assertEqualsQueryClause(actual.clause, deserialized.clause)
        XCTAssertEqual(actual.firmwareVersion, deserialized.firmwareVersion)
    }
}
