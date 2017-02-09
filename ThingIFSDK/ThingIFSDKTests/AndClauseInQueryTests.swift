//
//  AndClauseInQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/09.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class AndClauseInQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEqualsAndNotEquals() {
        let testCases: [
          (
            actual: AndClauseInQuery,
            expected: [String : Any]
          )
        ] = [
          (
            AndClauseInQuery([EqualsClauseInQuery("f", intValue: 1)]),
            [
              "type": "and",
              "clauses": [[ "type": "eq", "field": "f", "value": 1]]
            ]
          ),
          (
            AndClauseInQuery([EqualsClauseInQuery("f", boolValue: true)]),
            [
              "type": "and",
              "clauses" : [["type": "eq", "field": "f", "value": true]]
            ]
          ),
          (
            AndClauseInQuery([EqualsClauseInQuery("f", boolValue: false)]),
            [
              "type": "and",
              "clauses" : [[ "type": "eq", "field": "f", "value": false]]
            ]
          ),
          (
            AndClauseInQuery([EqualsClauseInQuery("f", stringValue: "str")]),
            [
              "type": "and",
              "clauses" : [["type": "eq", "field": "f", "value": "str"]]
            ]
          ),
          (
            AndClauseInQuery(
              [NotEqualsClauseInQuery(EqualsClauseInQuery("f", intValue: 1))]),
            [
              "type": "and",
              "clauses": [
                ["type": "not",
                 "clause": ["type": "eq", "field": "f", "value": 1]]]
            ]
          ),
          (
            AndClauseInQuery(
              [NotEqualsClauseInQuery(
                 EqualsClauseInQuery("f", boolValue: true))]),
            [
              "type": "and",
              "clauses" : [
                ["type": "not",
                 "clause": ["type": "eq", "field": "f", "value": true]]]
            ]
          ),
          (
            AndClauseInQuery(
              [NotEqualsClauseInQuery(
                 EqualsClauseInQuery("f", boolValue: false))]),
            [
              "type": "and",
              "clauses" : [
                ["type": "not",
                 "clause": [ "type": "eq", "field": "f", "value": false]]]
            ]
          ),
          (
            AndClauseInQuery(
              [NotEqualsClauseInQuery(
                 EqualsClauseInQuery("f", stringValue: "str"))]),
            [
              "type": "and",
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

            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized = AndClauseInQuery(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.clauses.count, deserialized.clauses.count)
            assertEqualsDictionary(
              actual.makeDictionary(),
              deserialized.makeDictionary())
        }
    }

    func testRange() {
        let testCases: [
          (
            actual: AndClauseInQuery,
            expected: [String : Any]
          )
        ] = [
          (
            AndClauseInQuery([RangeClauseInQuery.greaterThan("f", limit: 1)]),
            [
              "type": "and",
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
            AndClauseInQuery(
              [RangeClauseInQuery.greaterThanOrEqualTo("f", limit: 1)]),
            [
              "type": "and",
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
            AndClauseInQuery([RangeClauseInQuery.lessThan("f", limit: 1)]),
            [
              "type": "and",
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
            AndClauseInQuery(
              [RangeClauseInQuery.lessThanOrEqualTo("f", limit: 1)]),
            [
              "type": "and",
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
            AndClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: true)]),
            [
              "type": "and",
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
            AndClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: true,
              upperLimit: 2,
              upperIncluded: false)]),
            [
              "type": "and",
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
            AndClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: true)]),
            [
              "type": "and",
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
            AndClauseInQuery(
              [RangeClauseInQuery.range(
              "f",
              lowerLimit: 1,
              lowerIncluded: false,
              upperLimit: 2,
              upperIncluded: false)]),
            [
              "type": "and",
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

            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized = AndClauseInQuery(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.clauses.count, deserialized.clauses.count)
            assertEqualsDictionary(
              actual.makeDictionary(),
              deserialized.makeDictionary())
        }
    }

    func testAnd() {
        let actual = AndClauseInQuery(
          EqualsClauseInQuery("f", intValue: 1),
          NotEqualsClauseInQuery(EqualsClauseInQuery("f", boolValue: true)),
          RangeClauseInQuery.greaterThan("f", limit: 1))

        XCTAssertEqual(3, actual.clauses.count)

        actual.add(
          AndClauseInQuery(EqualsClauseInQuery("f", stringValue: "str"))).add(
          OrClauseInQuery(EqualsClauseInQuery("f", stringValue: "str")))

        XCTAssertEqual(5, actual.clauses.count)
        assertEqualsDictionary(
          [
            "type": "and",
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

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = AndClauseInQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.clauses.count, deserialized.clauses.count)
        assertEqualsDictionary(
          actual.makeDictionary(),
          deserialized.makeDictionary())

    }
}
