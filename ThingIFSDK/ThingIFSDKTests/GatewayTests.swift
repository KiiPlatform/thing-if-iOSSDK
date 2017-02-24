//
//  GatewayTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/24.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOptionalNonNil() {
        let actual = Gateway(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertEqual("thingID", actual.thingID)
        XCTAssertEqual("vendorThingID", actual.vendorThingID)
        XCTAssertEqual("accessToken", actual.accessToken)
        XCTAssertEqual(
          TypedID(TypedID.Types.thing, id: "thingID"),
          actual.typedID)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = Gateway(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.thingID, deserialized.thingID)
        XCTAssertEqual(actual.vendorThingID, deserialized.vendorThingID)
        XCTAssertEqual(actual.accessToken, deserialized.accessToken)
        XCTAssertEqual(actual.thingID, deserialized.thingID)

    }

    func testOptionalNil() {
        let actual = Gateway(
          "thingID",
          vendorThingID: "vendorThingID")

        XCTAssertEqual("thingID", actual.thingID)
        XCTAssertEqual("vendorThingID", actual.vendorThingID)
        XCTAssertNil(actual.accessToken)
        XCTAssertEqual(
          TypedID(TypedID.Types.thing, id: "thingID"),
          actual.typedID)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = Gateway(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertEqual(actual.thingID, deserialized.thingID)
        XCTAssertEqual(actual.vendorThingID, deserialized.vendorThingID)
        XCTAssertEqual(actual.accessToken, deserialized.accessToken)
        XCTAssertEqual(actual.thingID, deserialized.thingID)

    }

    func testEqualAndHash() {
        let base = Gateway(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertTrue(base == base)
        XCTAssertTrue(base.isEqual(base))
        XCTAssertEqual(base.hashValue, base.hash)

        let same = Gateway(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertTrue(base == same)
        XCTAssertTrue(base.isEqual(same))
        XCTAssertTrue(same.isEqual(base))
        XCTAssertEqual(base.hashValue, same.hashValue)

        let different = Gateway(
          "thingID2",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertFalse(base == different)
        XCTAssertFalse(base.isEqual(different))
        XCTAssertFalse(different.isEqual(base))
        XCTAssertNotEqual(base.hashValue, different.hashValue)


        let standalong =  StandaloneThing(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertFalse(base == standalong)
        XCTAssertFalse(base.isEqual(standalong))
        XCTAssertFalse(standalong.isEqual(base))
        XCTAssertEqual(base.hashValue, standalong.hashValue)

        let endnode =  EndNode(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertFalse(base == endnode)
        XCTAssertFalse(base.isEqual(endnode))
        XCTAssertFalse(endnode.isEqual(base))
        XCTAssertEqual(base.hashValue, endnode.hashValue)
    }

}
