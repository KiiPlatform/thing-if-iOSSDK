//
//  AliasActionTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class AliasActionTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let action = Action("key", value: "value")
        let target = AliasAction("dummy", actions: action)

        XCTAssertNotNil(target)
        XCTAssertEqual(target.alias, "dummy")
        XCTAssertEqual([action], target.actions)
    }

    func testValuesWithArray() {
        let actions = [
          Action("key1", value: "value1"),
          Action("key2", value: "value2")
        ]
        let target = AliasAction("dummy", actions: actions)

        XCTAssertNotNil(target)
        XCTAssertEqual(target.alias, "dummy")
        XCTAssertEqual(actions, target.actions)
    }

    func testValuesWithVariableNumberOfArgument() {
        let action1 = Action("key1", value: "value1")
        let action2 = Action("key2", value: "value2")
        let action3 = Action("key3", value: "value3")
        let target = AliasAction("dummy", actions: action1, action2, action3)

        XCTAssertNotNil(target)
        XCTAssertEqual(target.alias, "dummy")
        XCTAssertEqual([action1, action2, action3], target.actions)
    }

}
