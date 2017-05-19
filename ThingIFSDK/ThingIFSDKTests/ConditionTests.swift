//
//  ConditionTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/20.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class ConditionTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let clause = EqualsClauseInTrigger("alias", field: "f", intValue: 1)
        let actual = Condition(clause)

        XCTAssertEqual(clause, actual.clause as! EqualsClauseInTrigger)
    }
}
