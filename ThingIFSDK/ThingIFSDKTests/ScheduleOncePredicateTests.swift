//
//  ScheduleOncePredicateTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/20.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ScheduleOncePredicateTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let scheduleAt = Date()
        let actual = ScheduleOncePredicate(scheduleAt)

        XCTAssertEqual(scheduleAt, actual.scheduleAt)
        XCTAssertEqual(EventSource.scheduleOnce, actual.eventSource)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = ScheduleOncePredicate(coder: decoder)!
        decoder.finishDecoding();

        XCTAssertEqual(actual.scheduleAt, deserialized.scheduleAt)
        XCTAssertEqual(actual.eventSource, deserialized.eventSource)
    }
}

