//
//  TypedIDTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

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

    func testCoding() {
        let original = TypedID(TypedID.Types.thing, id: "dummy")

        XCTAssertNotNil(original)
        XCTAssertEqual(original.type, TypedID.Types.thing)
        XCTAssertEqual(original.id, "dummy")

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = TypedID(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded.type, original.type)
        XCTAssertEqual(decoded.id, original.id)
    }

    func testToString() {
        let thingType = TypedID(TypedID.Types.thing, id: "thingID")
        let groupType = TypedID(TypedID.Types.group, id: "groupID")
        let userType = TypedID(TypedID.Types.user, id: "userID")

        XCTAssertEqual(thingType.toString(), "thing:thingID")
        XCTAssertEqual(groupType.toString(), "group:groupID")
        XCTAssertEqual(userType.toString(), "user:userID")
    }

    func testIsEqual() {
        let target = TypedID(TypedID.Types.thing, id: "dummy")
        let sameOne = TypedID(TypedID.Types.thing, id: "dummy")
        let differentOne = TypedID(TypedID.Types.user, id: "dummy")

        XCTAssertTrue(target.isEqual(target))
        XCTAssertTrue(target == target)
        XCTAssertTrue(target.isEqual(sameOne))
        XCTAssertTrue(target == sameOne)
        XCTAssertFalse(target.isEqual(differentOne))
        XCTAssertFalse(target == differentOne)
    }
}