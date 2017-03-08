//
//  NotEqualsClauseInQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/07.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class NotEqualsClauseInQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNotEqualClauses() {

        let testCases: [
          (
            input: EqualsClauseInQuery,
            expected: (field: String, value: Any)
          )
        ] = [
          (
            input: EqualsClauseInQuery("f", intValue: 1),
            expected: (field: "f", value : 1)
          ),
          (
            input: EqualsClauseInQuery("f", boolValue: true),
            expected: (field: "f", value : true)
          ),
          (
            input: EqualsClauseInQuery("f", boolValue: false),
            expected: (field: "f", value : false)
          ),
          (
            input: EqualsClauseInQuery("f", stringValue: "string"),
            expected: (field: "f", value : "string")
          )
        ]

        for (input, expected) in testCases {
            let actual = NotEqualsClauseInQuery(input)
            XCTAssertEqual(expected.field, actual.equals.field)
            assertEqualsAny(expected.value, actual.equals.value)
            assertEqualsDictionary(
              [
                "type": "not",
                "clause": [
                  "type": "eq",
                  "field": expected.field,
                  "value": expected.value
                ]
              ], actual.makeJsonObject())
        }
    }

}
