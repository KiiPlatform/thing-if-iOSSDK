//
//  OrClauseInTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/10.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OrClauseInTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEqualsOrNotEquals() {
        let testCases: [
          (
            actual: OrClauseInTrigger,
            expected: [String : Any]
          )
        ] = [
          (
            OrClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  intValue: 1)]),
            [
              "type": "or",
              "clauses": [
                ["type": "eq", "alias": "alias", "field": "f", "value": 1]
              ]
            ]
          ),
          (
            OrClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  boolValue: true)]),
            [
              "type": "or",
              "clauses" : [
                ["type": "eq", "alias": "alias","field": "f", "value": true]
              ]
            ]
          ),
          (
            OrClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  boolValue: false)]),
            [
              "type": "or",
              "clauses" : [
                ["type": "eq", "alias": "alias", "field": "f", "value": false]
              ]
            ]
          ),
          (
            OrClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  stringValue: "str")]),
            [
              "type": "or",
              "clauses" : [
                ["type": "eq", "alias": "alias","field": "f", "value": "str"]
              ]
            ]
          ),
          (
            OrClauseInTrigger(
              [NotEqualsClauseInTrigger(EqualsClauseInTrigger(
                                          "alias",
                                          field: "f",
                                          intValue: 1))]),
            [
              "type": "or",
              "clauses": [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias","field": "f", "value": 1]
                ]]
            ]
          ),
          (
            OrClauseInTrigger(
              [NotEqualsClauseInTrigger(
                 EqualsClauseInTrigger("alias", field: "f", boolValue: true))]),
            [
              "type": "or",
              "clauses" : [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias","field": "f", "value": true]
                ]
              ]
            ]
          ),
          (
            OrClauseInTrigger(
              [NotEqualsClauseInTrigger(
                 EqualsClauseInTrigger(
                   "alias",
                   field: "f",
                   boolValue: false))]),
            [
              "type": "or",
              "clauses" : [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias", "field": "f", "value": false]
                ]
              ]
            ]
          ),
          (
            OrClauseInTrigger(
              [NotEqualsClauseInTrigger(
                 EqualsClauseInTrigger(
                   "alias",
                   field: "f",
                   stringValue: "str"))]),
            [
              "type": "or",
              "clauses" : [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias","field": "f", "value": "str"
                 ]
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

    func testRange() {
        let testCases: [
          (
            actual: OrClauseInTrigger,
            expected: [String : Any]
          )
        ] = [
          (
            OrClauseInTrigger([RangeClauseInTrigger.greaterThan(
                                  "alias",
                                  field: "f",
                                  limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": false
                ]
              ]
            ]
          ),
          (
            OrClauseInTrigger(
              [RangeClauseInTrigger.greaterThanOrEqualTo(
                 "alias",
                 field: "f",
                 limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
                  "field": "f",
                  "lowerLimit": 1,
                  "lowerIncluded": true
                ]
              ]
            ]
          ),
          (
            OrClauseInTrigger([RangeClauseInTrigger.lessThan(
                                  "alias",
                                  field: "f",
                                  limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
                  "field": "f",
                  "upperLimit": 1,
                  "upperIncluded": false
                ]
              ]
            ]
          ),
          (
            OrClauseInTrigger(
              [RangeClauseInTrigger.lessThanOrEqualTo(
                 "alias",
                 field: "f",
                 limit: 1)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
                  "field": "f",
                  "upperLimit": 1,
                  "upperIncluded": true
                ]
              ]
            ]
          ),
          (
            OrClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: true,
                 upperLimit: 2,
                 upperIncluded: true)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
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
            OrClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: true,
                 upperLimit: 2,
                 upperIncluded: false)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
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
            OrClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: false,
                 upperLimit: 2,
                 upperIncluded: true)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
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
            OrClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: false,
                 upperLimit: 2,
                 upperIncluded: false)]),
            [
              "type": "or",
              "clauses": [
                [
                  "type": "range",
                  "alias": "alias",
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
        var actual = OrClauseInTrigger(
          EqualsClauseInTrigger("alias", field: "f", intValue: 1),
          NotEqualsClauseInTrigger(EqualsClauseInTrigger(
                                     "alias",
                                     field: "f",
                                     boolValue: true)),
          RangeClauseInTrigger.greaterThan("alias", field: "f", limit: 1))

        XCTAssertEqual(3, actual.clauses.count)

        actual.add(
          AndClauseInTrigger(EqualsClauseInTrigger(
                               "alias",
                               field: "f",
                               stringValue: "str")))
        actual.add(
          OrClauseInTrigger(EqualsClauseInTrigger(
                              "alias",
                              field: "f",
                              stringValue: "str")))

        XCTAssertEqual(5, actual.clauses.count)
        assertEqualsDictionary(
          [
            "type": "or",
            "clauses": [
              ["type": "eq", "alias": "alias","field": "f", "value": 1],
              [
                "type": "not",
                "clause": [
                  "type": "eq", "alias": "alias","field": "f", "value": true
                ]
              ],
              [
                "type": "range",
                "alias": "alias",
                "field": "f",
                "lowerLimit": 1,
                "lowerIncluded": false
              ],
              [
                "type": "and",
                "clauses": [
                  ["type": "eq", "alias": "alias","field": "f", "value": "str"]
                ],
              ],
              [
                "type": "or",
                "clauses": [
                  ["type": "eq", "alias": "alias","field": "f", "value": "str"]
                ],
              ]
            ]
          ], actual.makeDictionary())
    }
}
