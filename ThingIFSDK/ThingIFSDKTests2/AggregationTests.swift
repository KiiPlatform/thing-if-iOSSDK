//
//  AggregationTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/02.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class AggregationTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCount() {
        let testList:
          [
            (
              input: (field: String, fieldType: Aggregation.FieldType),
              expected: (field: String, fieldType: Aggregation.FieldType)
            )
          ] = [
            (
              input: (field: "f", fieldType: .integer),
              expected: (field: "f", fieldType: .integer)
            ),
            (
              input: (field: "f", fieldType: .decimal),
              expected: (field: "f", fieldType: .decimal)
            ),
            (
              input: (field: "f", fieldType: .bool),
              expected: (field: "f", fieldType: .bool)
            ),
            (
              input: (field: "f", fieldType: .object),
              expected: (field: "f", fieldType: .object)
            ),
            (
              input: (field: "f", fieldType: .array),
              expected: (field: "f", fieldType: .array)
            )
          ]

        for (input, expected) in testList {
            let actual = Aggregation.makeCountAggregation(
              input.field,
              fieldType: input.fieldType)
            XCTAssertEqual(actual.field, expected.field)
            XCTAssertEqual(actual.fieldType, expected.fieldType)
            XCTAssertEqual(actual.function, Aggregation.FunctionType.count)


            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized: Aggregation = Aggregation(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.field, deserialized.field)
            XCTAssertEqual(actual.fieldType, deserialized.fieldType)
            XCTAssertEqual(actual.function, deserialized.function)

        }
    }

    func testMaxSuccess() {
        let testList:
          [
            (
              input: (field: String, fieldType: Aggregation.FieldType),
              expected: (field: String, fieldType: Aggregation.FieldType)
            )
          ] = [
            (
              input: (field: "f", fieldType: .integer),
              expected: (field: "f", fieldType: .integer)
            ),
            (
              input: (field: "f", fieldType: .decimal),
              expected: (field: "f", fieldType: .decimal)
            )
          ]

        for (input, expected) in testList {
            let actualOpt = Aggregation.makeMaxAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNotNil(
              actualOpt,
              "field: " + input.field +
                ", fieldType: " + input.fieldType.rawValue)

            let actual = actualOpt!
            XCTAssertEqual(actual.field, expected.field)
            XCTAssertEqual(actual.fieldType, expected.fieldType)
            XCTAssertEqual(actual.function, Aggregation.FunctionType.max)


            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized: Aggregation = Aggregation(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.field, deserialized.field)
            XCTAssertEqual(actual.fieldType, deserialized.fieldType)
            XCTAssertEqual(actual.function, deserialized.function)

        }
    }

    func testMaxFail() {
        let testList:
          [
            (field: String, fieldType: Aggregation.FieldType)
          ] = [
            (field: "f", fieldType: .bool),
            (field: "f", fieldType: .object),
            (field: "f", fieldType: .array)
          ]

        for input in testList {
            let actual = Aggregation.makeMaxAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNil(
              actual,
              "field: " + input.field + ", type: " + input.fieldType.rawValue)
        }
    }

    func testMinSuccess() {
        let testList:
          [
            (
              input: (field: String, fieldType: Aggregation.FieldType),
              expected: (field: String, fieldType: Aggregation.FieldType)
            )
          ] = [
            (
              input: (field: "f", fieldType: .integer),
              expected: (field: "f", fieldType: .integer)
            ),
            (
              input: (field: "f", fieldType: .decimal),
              expected: (field: "f", fieldType: .decimal)
            )
          ]

        for (input, expected) in testList {
            let actualOpt = Aggregation.makeMinAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNotNil(
              actualOpt,
              "field: " + input.field +
                ", fieldType: " + input.fieldType.rawValue)

            let actual = actualOpt!
            XCTAssertEqual(actual.field, expected.field)
            XCTAssertEqual(actual.fieldType, expected.fieldType)
            XCTAssertEqual(actual.function, Aggregation.FunctionType.min)


            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized: Aggregation = Aggregation(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.field, deserialized.field)
            XCTAssertEqual(actual.fieldType, deserialized.fieldType)
            XCTAssertEqual(actual.function, deserialized.function)

        }
    }

    func testMinFail() {
        let testList:
          [
            (field: String, fieldType: Aggregation.FieldType)
          ] = [
            (field: "f", fieldType: .bool),
            (field: "f", fieldType: .object),
            (field: "f", fieldType: .array)
          ]

        for input in testList {
            let actual = Aggregation.makeMinAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNil(
              actual,
              "field: " + input.field + ", type: " + input.fieldType.rawValue)
        }
    }

    func testSumSuccess() {
        let testList:
          [
            (
              input: (field: String, fieldType: Aggregation.FieldType),
              expected: (field: String, fieldType: Aggregation.FieldType)
            )
          ] = [
            (
              input: (field: "f", fieldType: .integer),
              expected: (field: "f", fieldType: .integer)
            ),
            (
              input: (field: "f", fieldType: .decimal),
              expected: (field: "f", fieldType: .decimal)
            )
          ]

        for (input, expected) in testList {
            let actualOpt = Aggregation.makeSumAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNotNil(
              actualOpt,
              "field: " + input.field +
                ", fieldType: " + input.fieldType.rawValue)

            let actual = actualOpt!
            XCTAssertEqual(actual.field, expected.field)
            XCTAssertEqual(actual.fieldType, expected.fieldType)
            XCTAssertEqual(actual.function, Aggregation.FunctionType.sum)


            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized: Aggregation = Aggregation(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.field, deserialized.field)
            XCTAssertEqual(actual.fieldType, deserialized.fieldType)
            XCTAssertEqual(actual.function, deserialized.function)

        }
    }

    func testSumFail() {
        let testList:
          [
            (field: String, fieldType: Aggregation.FieldType)
          ] = [
            (field: "f", fieldType: .bool),
            (field: "f", fieldType: .object),
            (field: "f", fieldType: .array)
          ]

        for input in testList {
            let actual = Aggregation.makeSumAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNil(
              actual,
              "field: " + input.field + ", type: " + input.fieldType.rawValue)
        }
    }

    func testMeanSuccess() {
        let testList:
          [
            (
              input: (field: String, fieldType: Aggregation.FieldType),
              expected: (field: String, fieldType: Aggregation.FieldType)
            )
          ] = [
            (
              input: (field: "f", fieldType: .integer),
              expected: (field: "f", fieldType: .integer)
            ),
            (
              input: (field: "f", fieldType: .decimal),
              expected: (field: "f", fieldType: .decimal)
            )
          ]

        for (input, expected) in testList {
            let actualOpt = Aggregation.makeMeanAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNotNil(
              actualOpt,
              "field: " + input.field +
                ", fieldType: " + input.fieldType.rawValue)

            let actual = actualOpt!
            XCTAssertEqual(actual.field, expected.field)
            XCTAssertEqual(actual.fieldType, expected.fieldType)
            XCTAssertEqual(actual.function, Aggregation.FunctionType.mean)


            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized: Aggregation = Aggregation(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.field, deserialized.field)
            XCTAssertEqual(actual.fieldType, deserialized.fieldType)
            XCTAssertEqual(actual.function, deserialized.function)

        }
    }

    func testMeanFail() {
        let testList:
          [
            (field: String, fieldType: Aggregation.FieldType)
          ] = [
            (field: "f", fieldType: .bool),
            (field: "f", fieldType: .object),
            (field: "f", fieldType: .array)
          ]

        for input in testList {
            let actual = Aggregation.makeMeanAggregation(
              input.field,
              fieldType: input.fieldType)

            XCTAssertNil(
              actual,
              "field: " + input.field + ", type: " + input.fieldType.rawValue)
        }
    }

    func testAggregationSuccess() {
        let testList: [
          (
            input: (
              function: Aggregation.FunctionType,
              field: String,
              fieldType: Aggregation.FieldType
            ),
            expected: (
              function: Aggregation.FunctionType,
              field: String,
              fieldType: Aggregation.FieldType
            )
          )] = [
          (
            input: (function: .count, field: "f", fieldType: .integer),
            expected: (function: .count, field: "f", fieldType: .integer)
          ),
          (
            input: (function: .count, field: "f", fieldType: .decimal),
            expected: (function: .count, field: "f", fieldType: .decimal)
          ),
          (
            input: (function: .count, field: "f", fieldType: .bool),
            expected: (function: .count, field: "f", fieldType: .bool)
          ),
          (
            input: (function: .count, field: "f", fieldType: .object),
            expected: (function: .count, field: "f", fieldType: .object)
          ),
          (
            input: (function: .count, field: "f", fieldType: .array),
            expected: (function: .count, field: "f", fieldType: .array)
          ),
          (
            input: (function: .max, field: "f", fieldType: .integer),
            expected: (function: .max, field: "f", fieldType: .integer)
          ),
          (
            input: (function: .max, field: "f", fieldType: .decimal),
            expected: (function: .max, field: "f", fieldType: .decimal)
          ),
          (
            input: (function: .min, field: "f", fieldType: .integer),
            expected: (function: .min, field: "f", fieldType: .integer)
          ),
          (
            input: (function: .min, field: "f", fieldType: .decimal),
            expected: (function: .min, field: "f", fieldType: .decimal)
          ),
          (
            input: (function: .sum, field: "f", fieldType: .integer),
            expected: (function: .sum, field: "f", fieldType: .integer)
          ),
          (
            input: (function: .sum, field: "f", fieldType: .decimal),
            expected: (function: .sum, field: "f", fieldType: .decimal)
          ),
          (
            input: (function: .mean, field: "f", fieldType: .integer),
            expected: (function: .mean, field: "f", fieldType: .integer)
          ),
          (
            input: (function: .mean, field: "f", fieldType: .decimal),
            expected: (function: .mean, field: "f", fieldType: .decimal)
          )
        ]

        for (input, expected) in testList {
            let actualOpt = Aggregation.makeAggregation(
              input.function,
              field: input.field,
              fieldType: input.fieldType)

            XCTAssertNotNil(
              actualOpt,
              "function: " + input.function.rawValue +
                ", field: " + input.field +
                ", fieldType: " + input.fieldType.rawValue)

            let actual = actualOpt!
            XCTAssertEqual(actual.field, expected.field)
            XCTAssertEqual(actual.fieldType, expected.fieldType)
            XCTAssertEqual(actual.function, expected.function)


            let data: NSMutableData = NSMutableData(capacity: 1024)!;
            let coder: NSKeyedArchiver =
              NSKeyedArchiver(forWritingWith: data);
            actual.encode(with: coder);
            coder.finishEncoding();

            let decoder: NSKeyedUnarchiver =
              NSKeyedUnarchiver(forReadingWith: data as Data);
            let deserialized: Aggregation = Aggregation(coder: decoder)!;
            decoder.finishDecoding();

            XCTAssertEqual(actual.field, deserialized.field)
            XCTAssertEqual(actual.fieldType, deserialized.fieldType)
            XCTAssertEqual(actual.function, deserialized.function)

        }
    }

    func testAggregationFail() {
        let testList: [
          (
            function: Aggregation.FunctionType,
            field: String,
            fieldType: Aggregation.FieldType
          )
        ] = [
          (function: .max, field: "f", fieldType: .bool),
          (function: .max, field: "f", fieldType: .object),
          (function: .max, field: "f", fieldType: .array),
          (function: .min, field: "f", fieldType: .bool),
          (function: .min, field: "f", fieldType: .object),
          (function: .min, field: "f", fieldType: .array),
          (function: .sum, field: "f", fieldType: .bool),
          (function: .sum, field: "f", fieldType: .object),
          (function: .sum, field: "f", fieldType: .array),
          (function: .mean, field: "f", fieldType: .bool),
          (function: .mean, field: "f", fieldType: .object),
          (function: .mean, field: "f", fieldType: .array)
        ]

        for input in testList {
            let actual = Aggregation.makeAggregation(
              input.function,
              field: input.field,
              fieldType: input.fieldType)

            XCTAssertNil(
              actual,
              "function: " + input.function.rawValue +
                ", field: " + input.field +
                ", type: " + input.fieldType.rawValue)
        }
    }
}
