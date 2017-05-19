//
//  TmeRangeTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class TimeRangeTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let from = Date(timeIntervalSince1970: 1)
        let to = Date(timeIntervalSince1970: 100)
        let target = TimeRange(from, to: to)

        XCTAssertNotNil(target)
        XCTAssertEqual(target.from, from)
        XCTAssertEqual(target.to, to)
    }

}
