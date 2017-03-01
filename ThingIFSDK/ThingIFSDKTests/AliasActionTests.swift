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

}
