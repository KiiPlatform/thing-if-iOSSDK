//
//  SchedulePredicateTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/20.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class SchedulePredicateTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let schedule = "00 * * * *"
        let actual = SchedulePredicate(schedule)

        XCTAssertEqual(schedule, actual.schedule)
        XCTAssertEqual(EventSource.schedule, actual.eventSource)
    }
}
