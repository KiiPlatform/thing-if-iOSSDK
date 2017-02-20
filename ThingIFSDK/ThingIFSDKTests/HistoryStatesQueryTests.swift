//
//  HistoryStatesQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class HistoryStatesQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }


    func testOptinalNotNil() {
        let clause = EqualsClauseInQuery("f", intValue: 1)
        let actual = HistoryStatesQuery(
          "alias",
          clause: clause,
          firmwareVersion: "version",
          bestEffortLimit: 1,
          nextPaginationKey: "next")

        XCTAssertEqual("alias", actual.alias)
        assertEqualsQueryClause(clause, actual.clause)
        XCTAssertEqual("version", actual.firmwareVersion)
        XCTAssertEqual(1, actual.bestEffortLimit)
        XCTAssertEqual("next", actual.nextPaginationKey)
    }

    func testOptinalNil() {
        let actual = HistoryStatesQuery("alias")

        XCTAssertEqual("alias", actual.alias)
        XCTAssertNil(actual.clause)
        XCTAssertNil(actual.firmwareVersion)
        XCTAssertNil(actual.bestEffortLimit)
        XCTAssertNil(actual.nextPaginationKey)
    }
}
