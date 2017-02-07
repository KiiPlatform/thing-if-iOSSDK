//
//  TypedIDTests.swift
//  ThingIFSDK
//
//  Created on 2016/05/27.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class TypedIDTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testTypedID() {
        let typedID_A = TypedID(type: "THING", id: "id")
        let typedID_B = TypedID(type: "thing", id: "id")
        let typedID_C = TypedID(type: "Thing", id: "id")

        XCTAssertEqual(typedID_A, typedID_B)
        XCTAssertEqual(typedID_A, typedID_C)
        XCTAssertEqual(typedID_B, typedID_C)

        XCTAssertEqual(typedID_A.type, typedID_B.type)
        XCTAssertEqual(typedID_A.type, typedID_C.type)
        XCTAssertEqual(typedID_B.type, typedID_C.type)

        XCTAssertEqual("thing", typedID_A.type)
        XCTAssertEqual("thing", typedID_B.type)
        XCTAssertEqual("thing", typedID_C.type)

        XCTAssertEqual("id", typedID_A.id)
        XCTAssertEqual("id", typedID_B.id)
        XCTAssertEqual("id", typedID_C.id)

    }
}
