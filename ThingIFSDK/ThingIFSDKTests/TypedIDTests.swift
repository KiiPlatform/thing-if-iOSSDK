//
//  TypedIDTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class TypedIDTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValues() {
        let target = TypedID(TypedID.Types.thing, id: "dummy")

        XCTAssertNotNil(target)
        XCTAssertEqual(target.type, TypedID.Types.thing)
        XCTAssertEqual(target.id, "dummy")
    }

    func testToString() {
        let thingType = TypedID(TypedID.Types.thing, id: "thingID")
        let groupType = TypedID(TypedID.Types.group, id: "groupID")
        let userType = TypedID(TypedID.Types.user, id: "userID")

        XCTAssertEqual(thingType.toString(), "thing:thingID")
        XCTAssertEqual(groupType.toString(), "group:groupID")
        XCTAssertEqual(userType.toString(), "user:userID")
    }

    func testEqualAndHash() {
        let target = TypedID(TypedID.Types.thing, id: "dummy")

        XCTAssertTrue(target == target)

        let sameOne = TypedID(TypedID.Types.thing, id: "dummy")

        XCTAssertTrue(target == sameOne)
        XCTAssertEqual(target.hashValue, sameOne.hashValue)

        let differentOne = TypedID(TypedID.Types.user, id: "dummy")

        XCTAssertFalse(target == differentOne)
        XCTAssertFalse(differentOne == target)
        XCTAssertTrue(target != differentOne)
        XCTAssertTrue(differentOne != target)
        XCTAssertNotEqual(target.hashValue, differentOne.hashValue)
    }
}
