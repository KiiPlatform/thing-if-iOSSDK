//
//  SchedulePredicateTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/20.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

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

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = SchedulePredicate(coder: decoder)!
        decoder.finishDecoding();

        XCTAssertEqual(actual.schedule, deserialized.schedule)
        XCTAssertEqual(actual.eventSource, deserialized.eventSource)
    }
}
