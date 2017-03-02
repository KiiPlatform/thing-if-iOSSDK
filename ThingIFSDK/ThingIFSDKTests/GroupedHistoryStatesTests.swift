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

}
