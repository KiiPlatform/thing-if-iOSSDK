//
//  HistoryStatesQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

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
        XCTAssertEqual(clause, actual.clause as! EqualsClauseInQuery)
        XCTAssertEqual("version", actual.firmwareVersion)
        XCTAssertEqual(1, actual.bestEffortLimit)
        XCTAssertEqual("next", actual.nextPaginationKey)
    }

    func testOptinalNil() {
        let clause = EqualsClauseInQuery("f", intValue: 1)
        let actual = HistoryStatesQuery("alias", clause: clause)

        XCTAssertEqual("alias", actual.alias)
        XCTAssertEqual(clause, actual.clause as! EqualsClauseInQuery)
        XCTAssertNil(actual.firmwareVersion)
        XCTAssertNil(actual.bestEffortLimit)
        XCTAssertNil(actual.nextPaginationKey)
    }
}
