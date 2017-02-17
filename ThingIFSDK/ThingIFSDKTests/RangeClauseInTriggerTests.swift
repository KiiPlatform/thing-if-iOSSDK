//
//  RangeClauseInTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/09.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class RangeClauseInTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRangeClauseInt() {
        let testCases: [
          (
            actual: RangeClauseInTrigger,
            expected: (
              alias: String,
              field: String,
              lower: (limit: NSNumber, included: Bool)?,
              upper: (limit: NSNumber, included: Bool)?
            )
          )
        ] = [
          (
            RangeClauseInTrigger.greaterThan("alias", field: "f", limit: 1),
            ("alias", "f", (1, false), nil)
          ),
          (
            RangeClauseInTrigger.greaterThanOrEqualTo(
              "alias",
              field: "f",
              limit: 1),
            ("alias", "f", (1, true), nil)
          ),
          (
            RangeClauseInTrigger.lessThan("alias", field: "f", limit: 1),
            ("alias", "f", nil, (1, false))
          ),
          (
            RangeClauseInTrigger.lessThanOrEqualTo(
              "alias",
              field: "f",
              limit: 1),
            ("alias", "f", nil, (1, true))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: true
            ),
            ("alias", "f", (1, true), (2, true))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: true
            ),
            ("alias", "f", (1, false), (2, true))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: false
            ),
            ("alias", "f", (1, true), (2, false))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: false
            ),
            ("alias", "f", (1, false), (2, false))
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (actual, expected) = testCase
            let label = "label \(index)"

            XCTAssertEqual(expected.alias, actual.alias, label)
            XCTAssertEqual(expected.field, actual.field, label)
            XCTAssertEqual(expected.lower?.limit, actual.lowerLimit, label)
            XCTAssertEqual(
              expected.lower?.included,
              actual.lowerIncluded,
              label)
            XCTAssertEqual(expected.upper?.limit, actual.upperLimit, label)
            XCTAssertEqual(
              expected.upper?.included,
              actual.upperIncluded,
              label)

            var dict: [String: Any] = [
              "type": "range",
              "alias": expected.alias,
              "field": expected.field
            ]
            dict["lowerLimit"] = expected.lower?.limit
            dict["lowerIncluded"] = expected.lower?.included
            dict["upperLimit"] = expected.upper?.limit
            dict["upperIncluded"] = expected.upper?.included
            assertEqualsDictionary(dict, actual.makeDictionary(), label)

            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized = RangeClauseInTrigger(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.alias, deserialized.alias, label)
            XCTAssertEqual(actual.field, deserialized.field, label)
            XCTAssertEqual(actual.lowerLimit, deserialized.lowerLimit, label)
            XCTAssertEqual(
              actual.lowerIncluded,
              deserialized.lowerIncluded,
              label)
            XCTAssertEqual(actual.upperLimit, deserialized.upperLimit, label)
            XCTAssertEqual(
              actual.upperIncluded,
              deserialized.upperIncluded,
              label)
        }

    }

    func testRangeClauseDecimal() {
        let testCases: [
          (
            actual: RangeClauseInTrigger,
            expected: (
              alias: String,
              field: String,
              lower: (limit: NSNumber, included: Bool)?,
              upper: (limit: NSNumber, included: Bool)?
            )
          )
        ] = [
          (
            RangeClauseInTrigger.greaterThan("alias", field: "f", limit: 1.01),
            ("alias", "f", (1.01, false), nil)
          ),
          (
            RangeClauseInTrigger.greaterThanOrEqualTo(
              "alias",
              field: "f",
              limit: 1.01),
            ("alias", "f", (1.01, true), nil)
          ),
          (
            RangeClauseInTrigger.lessThan(
              "alias",
              field: "f",
              limit: 1.01),
            ("alias", "f", nil, (1.01, false))
          ),
          (
            RangeClauseInTrigger.lessThanOrEqualTo(
              "alias",
              field: "f",
              limit: 1.01),
            ("alias", "f", nil, (1.01, true))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1.01,
              lowerIncluded: true,
              upperLimit: 2.01,
              upperIncluded: true
            ),
            ("alias", "f", (1.01, true), (2.01, true))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1.01,
              lowerIncluded: false,
              upperLimit: 2.01,
              upperIncluded: true
            ),
            ("alias", "f", (1.01, false), (2.01, true))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1.01,
              lowerIncluded: true,
              upperLimit: 2.01,
              upperIncluded: false
            ),
            ("alias", "f", (1.01, true), (2.01, false))
          ),
          (
            RangeClauseInTrigger.range(
              "alias",
              field: "f",
              lowerLimit: 1.01,
              lowerIncluded: false,
              upperLimit: 2.01,
              upperIncluded: false
            ),
            ("alias", "f", (1.01, false), (2.01, false))
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (actual, expected) = testCase
            let label = "label \(index)"

            XCTAssertEqual(expected.alias, actual.alias, label)
            XCTAssertEqual(expected.field, actual.field, label)
            assertEqualsWithAccuracyOrNil(
              expected.lower?.limit as? Double,
              actual.lowerLimit as? Double,
              accuracy: 0.001, label)
            XCTAssertEqual(
              expected.lower?.included,
              actual.lowerIncluded,
              label)
            assertEqualsWithAccuracyOrNil(
              expected.upper?.limit as? Double,
              actual.upperLimit as? Double,
              accuracy: 0.001, label)
            XCTAssertEqual(
              expected.upper?.included,
              actual.upperIncluded,
              label)

            var dict: [String: Any] = [
              "type": "range",
              "alias": expected.alias,
              "field": expected.field
            ]
            dict["lowerLimit"] = expected.lower?.limit
            dict["lowerIncluded"] = expected.lower?.included
            dict["upperLimit"] = expected.upper?.limit
            dict["upperIncluded"] = expected.upper?.included
            assertEqualsDictionary(dict, actual.makeDictionary(), label)

            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized = RangeClauseInTrigger(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.alias, deserialized.alias, label)
            XCTAssertEqual(actual.field, deserialized.field, label)
            assertEqualsWithAccuracyOrNil(
              actual.lowerLimit as? Double,
              deserialized.lowerLimit as? Double,
              accuracy: 0.001, label)
            XCTAssertEqual(actual.lowerIncluded,
                           deserialized.lowerIncluded,
                           label)
            assertEqualsWithAccuracyOrNil(
              actual.upperLimit as? Double,
              deserialized.upperLimit as? Double,
              accuracy: 0.001, label)
            XCTAssertEqual(
              actual.upperIncluded,
              deserialized.upperIncluded,
              label)
        }

    }
}


