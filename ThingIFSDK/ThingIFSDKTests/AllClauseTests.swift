//
//  AllClauseTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/03.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class AllClauseTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        XCTAssertEqual(
          ["type": "all"],
          AllClause().makeJsonObject() as! [String : String])
    }
}
