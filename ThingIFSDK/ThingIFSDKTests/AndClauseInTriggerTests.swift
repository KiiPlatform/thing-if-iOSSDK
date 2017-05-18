//
//  AndClauseInTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/10.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class AndClauseInTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEqualsAndNotEquals() {
        let testCases: [
          (
            actual: AndClauseInTrigger,
            expected: [String : Any]
          )
        ] = [
          (
            AndClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  intValue: 1)]),
            [
              "type": "and",
              "clauses": [
                ["type": "eq", "alias": "alias", "field": "f", "value": 1]
              ]
            ]
          ),
          (
            AndClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  boolValue: true)]),
            [
              "type": "and",
              "clauses" : [
                ["type": "eq", "alias": "alias","field": "f", "value": true]
              ]
            ]
          ),
          (
            AndClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  boolValue: false)]),
            [
              "type": "and",
              "clauses" : [
                ["type": "eq", "alias": "alias", "field": "f", "value": false]
              ]
            ]
          ),
          (
            AndClauseInTrigger([EqualsClauseInTrigger(
                                  "alias",
                                  field: "f",
                                  stringValue: "str")]),
            [
              "type": "and",
              "clauses" : [
                ["type": "eq", "alias": "alias","field": "f", "value": "str"]
              ]
            ]
          ),
          (
            AndClauseInTrigger(
              [NotEqualsClauseInTrigger(EqualsClauseInTrigger(
                                          "alias",
                                          field: "f",
                                          intValue: 1))]),
            [
              "type": "and",
              "clauses": [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias","field": "f", "value": 1]
                ]]
            ]
          ),
          (
            AndClauseInTrigger(
              [NotEqualsClauseInTrigger(
                 EqualsClauseInTrigger("alias", field: "f", boolValue: true))]),
            [
              "type": "and",
              "clauses" : [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias","field": "f", "value": true]
                ]
              ]
            ]
          ),
          (
            AndClauseInTrigger(
              [NotEqualsClauseInTrigger(
                 EqualsClauseInTrigger(
                   "alias",
                   field: "f",
                   boolValue: false))]),
            [
              "type": "and",
              "clauses" : [
                ["type": "not",
                 "clause": [
                   "type": "eq", "alias": "alias", "field": "f", "value": false]
                ]
              ]
            ]
          ),
          (
            AndClauseInTrigger(
              [NotEqualsClauseInTrigger(
                 EqualsClauseInTrigger(
                   "alias",
                   field: "f",
                   stringValue: "str"))]),
            [
              "type": "and",
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
            XCTAssertEqual(
              expected as NSDictionary,
              actual.makeJsonObject() as NSDictionary,
              "label \(index)")
        }
    }

    func testRange() {
        let testCases: [
          (
            actual: AndClauseInTrigger,
            expected: [String : Any]
          )
        ] = [
          (
            AndClauseInTrigger([RangeClauseInTrigger.greaterThan(
                                  "alias",
                                  field: "f",
                                  limit: 1)]),
            [
              "type": "and",
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
            AndClauseInTrigger(
              [RangeClauseInTrigger.greaterThanOrEqualTo(
                 "alias",
                 field: "f",
                 limit: 1)]),
            [
              "type": "and",
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
            AndClauseInTrigger([RangeClauseInTrigger.lessThan(
                                  "alias",
                                  field: "f",
                                  limit: 1)]),
            [
              "type": "and",
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
            AndClauseInTrigger(
              [RangeClauseInTrigger.lessThanOrEqualTo(
                 "alias",
                 field: "f",
                 limit: 1)]),
            [
              "type": "and",
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
            AndClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: true,
                 upperLimit: 2,
                 upperIncluded: true)]),
            [
              "type": "and",
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
            AndClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: true,
                 upperLimit: 2,
                 upperIncluded: false)]),
            [
              "type": "and",
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
            AndClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: false,
                 upperLimit: 2,
                 upperIncluded: true)]),
            [
              "type": "and",
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
            AndClauseInTrigger(
              [RangeClauseInTrigger.range(
                 "alias",
                 field: "f",
                 lowerLimit: 1,
                 lowerIncluded: false,
                 upperLimit: 2,
                 upperIncluded: false)]),
            [
              "type": "and",
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
            XCTAssertEqual(
              expected as NSDictionary,
              actual.makeJsonObject() as NSDictionary,
              "label \(index)")
        }
    }

    func testAnd() {
        var actual = AndClauseInTrigger(
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
        XCTAssertEqual(
          [
            "type": "and",
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
          ] as NSDictionary,
          actual.makeJsonObject() as NSDictionary)
    }
}
