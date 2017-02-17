//
//  ActionResultTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ActionResultTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitMinValues() {
        let target = ActionResult(true, actionName: "dummy", data: nil, errorMessage: nil)

        XCTAssertNotNil(target)
        XCTAssertTrue(target.succeeded)
        XCTAssertEqual(target.actionName, "dummy")
        XCTAssertNil(target.data)
        XCTAssertNil(target.errorMessage)
    }

    func testInitMaxValues() {
        let target = ActionResult(false, actionName: "dummy", data: {}, errorMessage: "dummy error")

        XCTAssertNotNil(target)
        XCTAssertFalse(target.succeeded)
        XCTAssertEqual(target.actionName, "dummy")
        XCTAssertNotNil(target.data)
        XCTAssertEqual(target.errorMessage, "dummy error")
    }

    func testCoding() {
        let original = ActionResult(false, actionName: "dummy", data: "dummyData", errorMessage: "dummy error")
        XCTAssertFalse(original.succeeded)
        XCTAssertEqual(original.actionName, "dummy")
        XCTAssertEqual(original.data as! String, "dummyData")
        XCTAssertEqual(original.errorMessage, "dummy error")

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = ActionResult(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded!.succeeded, original.succeeded)
        XCTAssertEqual(decoded!.actionName, original.actionName)
        XCTAssertEqual(decoded!.data as! String, original.data as! String)
        XCTAssertEqual(decoded!.errorMessage, original.errorMessage)
    }

    func testCodingNil() {
        let original = ActionResult(true, actionName: "dummy", data: nil, errorMessage: nil)
        XCTAssertTrue(original.succeeded)
        XCTAssertEqual(original.actionName, "dummy")
        XCTAssertNil(original.data)
        XCTAssertNil(original.errorMessage)

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = ActionResult(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded!.succeeded, original.succeeded)
        XCTAssertEqual(decoded!.actionName, original.actionName)
        XCTAssertNil(decoded!.data)
        XCTAssertNil(decoded!.errorMessage)
    }
}
