//
//  NotEqualsClauseInTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/09.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class NotEqualsClauseInTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNotEqualClauses() {

        let testCases: [
          (
            input: EqualsClauseInTrigger,
            expected: (alias: String, field: String, value: Any)
          )
        ] = [
          (
            input: EqualsClauseInTrigger("alias", field: "f", intValue: 1),
            expected: ("alias", "f", 1)
          ),
          (
            input: EqualsClauseInTrigger("alias", field: "f", boolValue: true),
            expected: ("alias", "f", true)
          ),
          (
            input: EqualsClauseInTrigger("alias", field: "f", boolValue: false),
            expected: ("alias", "f", false)
          ),
          (
            input: EqualsClauseInTrigger(
              "alias",
              field: "f",
              stringValue: "string"),
            expected: ("alias", "f", "string")
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (input, expected) = testCase
            let actual = NotEqualsClauseInTrigger(input)
            let label = "label \(index)"
            XCTAssertEqual(expected.field, actual.equals.field, label)
            XCTAssertEqual(
              AnyWrapper(expected.value),
              AnyWrapper(actual.equals.value),
              label)
            XCTAssertEqual(
              [
                "type": "not",
                "clause": [
                  "type": "eq",
                  "alias": expected.alias,
                  "field": expected.field,
                  "value": expected.value
                ]
              ] as NSDictionary,
              actual.makeJsonObject() as NSDictionary,
              label)
        }
    }

}
