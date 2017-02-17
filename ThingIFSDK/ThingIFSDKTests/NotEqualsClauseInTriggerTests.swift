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
            assertEqualsAny(expected.value, actual.equals.value, label)
            assertEqualsDictionary(
              [
                "type": "not",
                "clause": [
                  "type": "eq",
                  "alias": expected.alias,
                  "field": expected.field,
                  "value": expected.value
                ]
              ], actual.makeDictionary(), label)

            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized = NotEqualsClauseInTrigger(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(
              actual.equals.field,
              deserialized.equals.field,
              label)
            assertEqualsAny(
              actual.equals.value,
              deserialized.equals.value,
              label)
            assertEqualsDictionary(
              actual.makeDictionary(),
              deserialized.makeDictionary(),
              label)

        }
    }

}
