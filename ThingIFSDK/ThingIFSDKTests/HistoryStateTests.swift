//
//  HistoryStateTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class HistoryStateTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let date = Date()
        let target = HistoryState(["key": "value"], createdAt: date)

        XCTAssertNotNil(target)
        XCTAssertNotNil(target.state)
        XCTAssertEqual(target.state.count, 1)
        XCTAssertEqual(target.state["key"] as! String, "value")
        XCTAssertEqual(target.createdAt, date)
    }

}
