//
//  AliasActionTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class AliasActionTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let target = AliasAction("dummy", action: ["key": "value"])

        XCTAssertNotNil(target)
        XCTAssertEqual(target.alias, "dummy")
        XCTAssertNotNil(target.action)
        XCTAssertEqual(target.action.count, 1)
        XCTAssertEqual(target.action["key"] as! String, "value")
    }

    func testCoding() {
        let original = AliasAction("dummy", action: ["key": "value"])
        XCTAssertNotNil(original)
        XCTAssertEqual(original.alias, "dummy")
        XCTAssertNotNil(original.action)
        XCTAssertEqual(original.action.count, 1)
        XCTAssertEqual(original.action["key"] as! String, "value")

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = AliasAction(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded!.alias, original.alias)
        XCTAssertNotNil(decoded!.action)
        XCTAssertEqual(decoded!.action.count, 1)
        XCTAssertEqual(decoded!.action["key"] as! String, "value")
    }
}
