//
//  ActionTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ActionTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValue() {
        let actual = Action("name", value: "value")

        XCTAssertEqual("name", actual.name)
        XCTAssertEqual("value", actual.value as? String)
    }

}
