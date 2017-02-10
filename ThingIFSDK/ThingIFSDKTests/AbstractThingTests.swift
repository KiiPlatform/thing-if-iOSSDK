//
//  AbstractThingTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class AbstractThingTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMinValues() {
        let target = AbstractThing("dummyThing", vendorThingID: "dummyVendor")

        XCTAssertNotNil(target)
        XCTAssertNotNil(target.typedID)
        XCTAssertEqual(target.typedID.type, TypedID.Types.thing)
        XCTAssertEqual(target.typedID.id, "dummyThing")
        XCTAssertEqual(target.thingID, "dummyThing")
        XCTAssertEqual(target.vendorThingID, "dummyVendor")
        XCTAssertNil(target.accessToken)
    }

    func testMaxValues() {
        let target = AbstractThing("dummyThing", vendorThingID: "dummyVendor", accessToken: "dummyToken")

        XCTAssertNotNil(target)
        XCTAssertNotNil(target.typedID)
        XCTAssertEqual(target.typedID.type, TypedID.Types.thing)
        XCTAssertEqual(target.typedID.id, "dummyThing")
        XCTAssertEqual(target.thingID, "dummyThing")
        XCTAssertEqual(target.vendorThingID, "dummyVendor")
        XCTAssertEqual(target.accessToken, "dummyToken")
    }

    func testIsEqual() {
        let target = AbstractThing("dummyThing", vendorThingID: "dummyVendor", accessToken: "dummyToken")
        let sameOne = AbstractThing("dummyThing", vendorThingID: "dummyVendor2", accessToken: "dummyToken")
        let differentOne = AbstractThing("otherThing", vendorThingID: "dummyVendor", accessToken: "otherToken")

        XCTAssertTrue(target.isEqual(target))
        XCTAssertTrue(target == target)
        XCTAssertFalse(target.isEqual({}))
        XCTAssertTrue(target.isEqual(sameOne))
        XCTAssertTrue(target == sameOne)
        XCTAssertFalse(target.isEqual(differentOne))
        XCTAssertFalse(target == differentOne)
    }

    func testCodingMinValues() {
        let original = AbstractThing("dummyThing", vendorThingID: "dummyVendor")

        XCTAssertNotNil(original)
        XCTAssertNotNil(original.typedID)
        XCTAssertEqual(original.typedID.type, TypedID.Types.thing)
        XCTAssertEqual(original.typedID.id, "dummyThing")
        XCTAssertEqual(original.thingID, "dummyThing")
        XCTAssertEqual(original.vendorThingID, "dummyVendor")
        XCTAssertNil(original.accessToken)

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = AbstractThing(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded.typedID, original.typedID)
        XCTAssertEqual(decoded.thingID, original.thingID)
        XCTAssertEqual(decoded.vendorThingID, original.vendorThingID)
        XCTAssertEqual(decoded.accessToken, original.accessToken)
    }

    func testCodingMaxValues() {
        let original = AbstractThing("dummyThing", vendorThingID: "dummyVendor", accessToken: "dummyToken")

        XCTAssertNotNil(original)
        XCTAssertNotNil(original.typedID)
        XCTAssertEqual(original.typedID.type, TypedID.Types.thing)
        XCTAssertEqual(original.typedID.id, "dummyThing")
        XCTAssertEqual(original.thingID, "dummyThing")
        XCTAssertEqual(original.vendorThingID, "dummyVendor")
        XCTAssertEqual(original.accessToken, "dummyToken")

        let data = NSMutableData(capacity: 1024)!
        let coder = NSKeyedArchiver(forWritingWith: data)
        original.encode(with: coder)
        coder.finishEncoding()

        let decoder: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
        let decoded = AbstractThing(coder: decoder);
        decoder.finishDecoding();

        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded.typedID, original.typedID)
        XCTAssertEqual(decoded.thingID, original.thingID)
        XCTAssertEqual(decoded.vendorThingID, original.vendorThingID)
        XCTAssertEqual(decoded.accessToken, original.accessToken)
    }
}
