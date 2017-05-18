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
        XCTAssertEqual(results, target.results)
    }

}
