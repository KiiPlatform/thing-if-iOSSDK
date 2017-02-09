//
//  AliasActionResultTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class AliasActionResultTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let results = [ActionResult(true, actionName: "dummy", data: nil, errorMessage: nil)]
        let target = AliasActionResult("dummy", results: results)

        XCTAssertNotNil(target)
        XCTAssertEqual(target.alias, "dummy")
        verifyArray(results, actual: target.results)
    }

    func testCoding() {
        let results = [ActionResult(true, actionName: "dummy", data: nil, errorMessage: nil)]
        let original = AliasActionResult("dummy", results: results)
        XCTAssertNotNil(original)
        XCTAssertEqual(original.alias, "dummy")
        verifyArray(results, actual: original.results)

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = AliasActionResult(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded!.alias, original.alias)
        XCTAssertNotNil(decoded!.results)
        XCTAssertEqual(decoded!.results.count, results.count)
        XCTAssertEqual(decoded!.results[0].succeeded, results[0].succeeded)
        XCTAssertEqual(decoded!.results[0].actionName, results[0].actionName)
        XCTAssertNil(decoded!.results[0].data)
        XCTAssertNil(decoded!.results[0].errorMessage)
    }
}
