//
//  RangeClauseInQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/08.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class RangeClauseInQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRangeClauseInt() {
        let testCases: [
          (
            actual: RangeClauseInQuery,
            expected: (
              field: String,
              lower: (limit: NSNumber, included: Bool)?,
              upper: (limit: NSNumber, included: Bool)?
            )
          )
        ] = [
          (
            actual: RangeClauseInQuery.greaterThan("f", limit: 1),
            expected: (field: "f", lower: (1, false), upper: nil)
          ),
          (
            actual: RangeClauseInQuery.greaterThanOrEqualTo("f", limit: 1),
            expected: (field: "f", lower: (1, true), upper: nil)
          ),
          (
            actual: RangeClauseInQuery.lessThan("f", limit: 1),
            expected: (field: "f", lower: nil, upper: (1, false))
          ),
          (
            actual: RangeClauseInQuery.lessThanOrEqualTo("f", limit: 1),
            expected: (field: "f", lower: nil, upper: (1, true))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: true
            ),
            expected: (field: "f", lower: (1, true), upper: (2, true))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: true
            ),
            expected: (field: "f", lower: (1, false), upper: (2, true))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: false
            ),
            expected: (field: "f", lower: (1, true), upper: (2, false))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: false
            ),
            expected: (field: "f", lower: (1, false), upper: (2, false))
          )
        ]

        for (actual, expected) in testCases {

            XCTAssertEqual(expected.field, actual.field)
            XCTAssertEqual(expected.lower?.limit, actual.lowerLimit)
            XCTAssertEqual(expected.lower?.included, actual.lowerIncluded)
            XCTAssertEqual(expected.upper?.limit, actual.upperLimit)
            XCTAssertEqual(expected.upper?.included, actual.upperIncluded)

            var dict: [String: Any] = [
              "type": "range",
              "field": expected.field
            ]
            dict["lowerLimit"] = expected.lower?.limit
            dict["lowerIncluded"] = expected.lower?.included
            dict["upperLimit"] = expected.upper?.limit
            dict["upperIncluded"] = expected.upper?.included
            assertEqualsDictionary(dict, actual.makeJson())
        }

    }

    func testRangeClauseDecimal() {
        let testCases: [
          (
            actual: RangeClauseInQuery,
            expected: (
              field: String,
              lower: (limit: NSNumber, included: Bool)?,
              upper: (limit: NSNumber, included: Bool)?
            )
          )
        ] = [
          (
            actual: RangeClauseInQuery.greaterThan("f", limit: 1.01),
            expected: (field: "f", lower: (1.01, false), upper: nil)
          ),
          (
            actual: RangeClauseInQuery.greaterThanOrEqualTo("f", limit: 1.01),
            expected: (field: "f", lower: (1.01, true), upper: nil)
          ),
          (
            actual: RangeClauseInQuery.lessThan("f", limit: 1.01),
            expected: (field: "f", lower: nil, upper: (1.01, false))
          ),
          (
            actual: RangeClauseInQuery.lessThanOrEqualTo("f", limit: 1.01),
            expected: (field: "f", lower: nil, upper: (1.01, true))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1.01,
              lowerIncluded: true,
              upperLimit: 2.01,
              upperIncluded: true
            ),
            expected: (field: "f", lower: (1.01, true), upper: (2.01, true))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1.01,
              lowerIncluded: false,
              upperLimit: 2.01,
              upperIncluded: true
            ),
            expected: (field: "f", lower: (1.01, false), upper: (2.01, true))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1.01,
              lowerIncluded: true,
              upperLimit: 2.01,
              upperIncluded: false
            ),
            expected: (field: "f", lower: (1.01, true), upper: (2.01, false))
          ),
          (
            actual: RangeClauseInQuery.range(
              "f",
              lowerLimit: 1.01,
              lowerIncluded: false,
              upperLimit: 2.01,
              upperIncluded: false
            ),
            expected: (field: "f", lower: (1.01, false), upper: (2.01, false))
          )
        ]

        for (actual, expected) in testCases {

            XCTAssertEqual(expected.field, actual.field)
            assertEqualsWithAccuracyOrNil(
              expected.lower?.limit as? Double,
              actual.lowerLimit as? Double,
              accuracy: 0.001)
            XCTAssertEqual(expected.lower?.included, actual.lowerIncluded)
            assertEqualsWithAccuracyOrNil(
              expected.upper?.limit as? Double,
              actual.upperLimit as? Double,
              accuracy: 0.001)
            XCTAssertEqual(expected.upper?.included, actual.upperIncluded)

            var dict: [String: Any] = [
              "type": "range",
              "field": expected.field
            ]
            dict["lowerLimit"] = expected.lower?.limit
            dict["lowerIncluded"] = expected.lower?.included
            dict["upperLimit"] = expected.upper?.limit
            dict["upperIncluded"] = expected.upper?.included
            assertEqualsDictionary(dict, actual.makeJson())
        }

    }
}


