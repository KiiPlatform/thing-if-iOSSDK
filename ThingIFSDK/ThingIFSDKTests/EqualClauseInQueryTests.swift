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

        let actualDict = actual.makeJsonObject()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual(1, actualDict["value"] as! Int)
    }

    func testEqualBoolTrue() {
        let actual = EqualsClauseInQuery("f", boolValue: true)

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual(true, actual.value as! Bool)

        let actualDict = actual.makeJsonObject()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual(true, actualDict["value"] as! Bool)
    }

    func testEqualBoolFalse() {
        let actual = EqualsClauseInQuery("f", boolValue: false)

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual(false, actual.value as! Bool)

        let actualDict = actual.makeJsonObject()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual(false, actualDict["value"] as! Bool)
    }

    func testEqualString() {
        let actual = EqualsClauseInQuery("f", stringValue: "string")

        XCTAssertEqual("f", actual.field)
        XCTAssertEqual("string", actual.value as! String)

        let actualDict = actual.makeJsonObject()

        XCTAssertEqual("eq", actualDict["type"] as! String)
        XCTAssertEqual("f", actualDict["field"] as! String)
        XCTAssertEqual("string", actualDict["value"] as! String)
    }

}
