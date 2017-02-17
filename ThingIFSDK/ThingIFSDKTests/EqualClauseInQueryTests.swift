//
//  EqualClauseInQueryTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/07.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class EqualClauseInQueryTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEqualInt() {
        let actual = EqualsClauseInQuery("f", intValue: 1)

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual(1, actual.value as! Int)

        let actualDict = actual.makeDictionary()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual(1, actualDict["value"] as! Int)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = EqualsClauseInQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.field, deserialized.field)
        XCTAssertEqual(actual.value as! Int, deserialized.value as! Int)
    }

    func testEqualBoolTrue() {
        let actual = EqualsClauseInQuery("f", boolValue: true)

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual(true, actual.value as! Bool)

        let actualDict = actual.makeDictionary()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual(true, actualDict["value"] as! Bool)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = EqualsClauseInQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.field, deserialized.field)
        XCTAssertEqual(actual.value as! Bool, deserialized.value as! Bool)
    }

    func testEqualBoolFalse() {
        let actual = EqualsClauseInQuery("f", boolValue: false)

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual(false, actual.value as! Bool)

        let actualDict = actual.makeDictionary()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual(false, actualDict["value"] as! Bool)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = EqualsClauseInQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.field, deserialized.field)
        XCTAssertEqual(actual.value as! Bool, deserialized.value as! Bool)
    }

    func testEqualString() {
        let actual = EqualsClauseInQuery("f", stringValue: "string")

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual("string", actual.value as! String)

        let actualDict = actual.makeDictionary()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual("string", actualDict["value"] as! String)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver = NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = EqualsClauseInQuery(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.field, deserialized.field)
        XCTAssertEqual(actual.value as! String, deserialized.value as! String)
    }

}
