//
//  GroupedHistoryStatesTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class GroupedHistoryStatesTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 100))
        let historyState = HistoryState(["key": "value"], createdAt: Date(timeIntervalSince1970: 50))
        let target = GroupedHistoryStates(timeRange, objects: [historyState])

        XCTAssertNotNil(target)
        XCTAssertNotNil(target.timeRange)
        XCTAssertEqual(target.timeRange.from, timeRange.from)
        XCTAssertEqual(target.timeRange.to, timeRange.to)
        XCTAssertNotNil(target.objects)
        XCTAssertEqual(target.objects.count, 1)
        XCTAssertNotNil(target.objects[0].state)
        XCTAssertEqual(target.objects[0].state.count, 1)
        XCTAssertEqual(target.objects[0].state["key"] as! String, "value")
        XCTAssertEqual(target.objects[0].createdAt, historyState.createdAt)
    }

    func testCoding() {
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 100))
        let historyState = HistoryState(["key": "value"], createdAt: Date(timeIntervalSince1970: 50))
        let original = GroupedHistoryStates(timeRange, objects: [historyState])

        XCTAssertNotNil(original)
        XCTAssertNotNil(original.timeRange)
        XCTAssertEqual(original.timeRange.from, timeRange.from)
        XCTAssertEqual(original.timeRange.to, timeRange.to)
        XCTAssertNotNil(original.objects)
        XCTAssertEqual(original.objects.count, 1)
        XCTAssertNotNil(original.objects[0].state)
        XCTAssertEqual(original.objects[0].state.count, 1)
        XCTAssertEqual(original.objects[0].state["key"] as! String, "value")
        XCTAssertEqual(original.objects[0].createdAt, historyState.createdAt)

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = GroupedHistoryStates(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertNotNil(decoded!.timeRange)
        XCTAssertEqual(decoded!.timeRange.from, timeRange.from)
        XCTAssertEqual(decoded!.timeRange.to, timeRange.to)
        XCTAssertNotNil(decoded!.objects)
        XCTAssertEqual(decoded!.objects.count, 1)
        XCTAssertNotNil(decoded!.objects[0].state)
        XCTAssertEqual(decoded!.objects[0].state.count, 1)
        XCTAssertEqual(decoded!.objects[0].state["key"] as! String, "value")
        XCTAssertEqual(decoded!.objects[0].createdAt, historyState.createdAt)
    }
}
