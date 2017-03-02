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

}
