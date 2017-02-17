//
//  TmeRangeTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

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

    func testCoding() {
        let from = Date(timeIntervalSince1970: 1)
        let to = Date(timeIntervalSince1970: 100)
        let original = TimeRange(from, to: to)
        XCTAssertNotNil(original)
        XCTAssertEqual(original.from, from)
        XCTAssertEqual(original.to, to)

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = TimeRange(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded!.from, from)
        XCTAssertEqual(decoded!.to, to)
    }
}
