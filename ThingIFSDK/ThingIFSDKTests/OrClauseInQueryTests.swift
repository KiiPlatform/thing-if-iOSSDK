//
//  OrClauseInQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/09.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OrClauseInQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEqualsAndNotEquals() {
        let testCases: [
          (
            actual: OrClauseInQuery,
            expected: [String : Any]
          )
        ] = [
          (
            OrClauseInQuery([EqualsClauseInQuery("f", intValue: 1)]),
            [
              "type": "or",
              "clauses": [[ "type": "eq", "field": "f", "value": 1]]
            ]
          ),
          (
            OrClauseInQuery([EqualsClauseInQuery("f", boolValue: true)]),
            [
              "type": "or",
              "clauses" : [["type": "eq", "field": "f", "value": true]]
            ]
          ),
          (
            OrClauseInQuery([EqualsClauseInQuery("f", boolValue: false)]),
            [
              "type": "or",
              "clauses" : [[ "type": "eq", "field": "f", "value": false]]
            ]
          ),
          (
            OrClauseInQuery([EqualsClauseInQuery("f", stringValue: "str")]),
            [
              "type": "or",
              "clauses" : [["type": "eq", "field": "f", "value": "str"]]
            ]
          ),
          (
            OrClauseInQuery(
              [NotEqualsClauseInQuery(EqualsClauseInQuery("f", intValue: 1))]),
            [
              "type": "or",
              "clauses": [
                ["type": "not",
                 "clause": ["type": "eq", "field": "f", "value": 1]]]
            ]
          ),
          (
            OrClauseInQuery(
              [NotEqualsClauseInQuery(
                 EqualsClauseInQuery("f", boolValue: true))]),
            [
              "type": "or",
              "clauses" : [
                ["type": "not",
                 "clause": ["type": "eq", "field": "f", "value": true]]]
            ]
          ),
          (
            OrClauseInQuery(
              [NotEqualsClauseInQuery(
                 EqualsClauseInQuery("f", boolValue: false))]),
            [
              "type": "or",
              "clauses" : [
                ["type": "not",
                 "clause": [ "type": "eq", "field": "f", "value": false]]]
            ]
          ),
          (
            OrClauseInQuery(
              [NotEqualsClauseInQuery(
                 EqualsClauseInQuery("f", stringValue: "str"))]),
            [
              "type": "or",
              "clauses" : [
                ["type": "not",
                 "clause": ["type": "eq", "field": "f", "value": "str"]]]
            ]
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (actual, expected) = testCase
            XCTAssertEqual(
              (expected["clauses"] as! [[String : Any]]).count,
              actual.clauses.count)
            assertEqualsDictionary(
              expected,
              actual.makeDictionary(),
              "label \(index)")
        }
    }

    func testRange() {
        let testCases: [
          (
            actual: OrClauseInQuery,
            expected: [String : Any]
          )
        ] = [
          (
            OrClauseInQuery([RangeClauseInQuery.greaterThan("f", limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": false
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery(
              [RangeClauseInQuery.greaterThanOrEqualTo("f", limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": true
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery([RangeClauseInQuery.lessThan("f", limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "upperLimit": 1,
                  "upperIncluded": false
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery(
              [RangeClauseInQuery.lessThanOrEqualTo("f", limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "upperLimit": 1,
                  "upperIncluded": true
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: true)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": true,
                  "upperLimit": 2,
                  "upperIncluded": true
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: false)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": true,
                  "upperLimit": 2,
                  "upperIncluded": false
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: true)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": false,
                  "upperLimit": 2,
                  "upperIncluded": true
                ]
              ]
            ]
          ),
          (
            OrClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: false)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": false,
                  "upperLimit": 2,
                  "upperIncluded": false
                ]
              ]
            ]
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (actual, expected) = testCase
            XCTAssertEqual(
              (expected["clauses"] as! [[String : Any]]).count,
              actual.clauses.count)
            assertEqualsDictionary(
              expected,
              actual.makeDictionary(),
              "label \(index)")
        }
    }

    func testOr() {
        var actual = OrClauseInQuery(
          EqualsClauseInQuery("f", intValue: 1),
          NotEqualsClauseInQuery(EqualsClauseInQuery("f", boolValue: true)),
          RangeClauseInQuery.greaterThan("f", limit: 1))

        XCTAssertEqual(3, actual.clauses.count)

        actual.add(
          AndClauseInQuery(EqualsClauseInQuery("f", stringValue: "str")))
        actual.add(
          OrClauseInQuery(EqualsClauseInQuery("f", stringValue: "str")))

        XCTAssertEqual(5, actual.clauses.count)
        assertEqualsDictionary(
          [
            "type": "or",
            "clauses": [
              ["type": "eq", "field": "f", "value": 1],
              [
                "type": "not",
                "clause": ["type": "eq", "field": "f", "value": true]
              ],
              [
                "type": "range",
                "field": "f",
                "lowerLimit": 1,
                "lowerIncluded": false
              ],
              [
                "type": "and",
                "clauses": [["type": "eq", "field": "f", "value": "str"]],
              ],
              [
                "type": "or",
                "clauses": [["type": "eq", "field": "f", "value": "str"]],
              ]
            ]
          ], actual.makeDictionary())
    }
}
