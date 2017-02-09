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

    func testCoding() {
        let date = Date()
        let original = HistoryState(["key": "value"], createdAt: date)
        XCTAssertNotNil(original)
        XCTAssertNotNil(original.state)
        XCTAssertEqual(original.state.count, 1)
        XCTAssertEqual(original.state["key"] as! String, "value")
        XCTAssertEqual(original.createdAt, date)

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = HistoryState(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertNotNil(decoded!.state)
        XCTAssertEqual(decoded!.state.count, 1)
        XCTAssertEqual(decoded!.state["key"] as! String, "value")
        XCTAssertEqual(decoded!.createdAt, date)
    }
}
