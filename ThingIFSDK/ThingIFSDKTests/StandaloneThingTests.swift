//
//  StandaloneThingTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class StandaloneThingTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOptionalNonNil() {
        let actual = StandaloneThing(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertEqual("thingID", actual.thingID)
        XCTAssertEqual("vendorThingID", actual.vendorThingID)
        XCTAssertEqual("accessToken", actual.accessToken)
        XCTAssertEqual(
          TypedID(TypedID.Types.thing, id: "thingID"),
          actual.typedID)
    }

    func testOptionalNil() {
        let actual = StandaloneThing(
          "thingID",
          vendorThingID: "vendorThingID")

        XCTAssertEqual("thingID", actual.thingID)
        XCTAssertEqual("vendorThingID", actual.vendorThingID)
        XCTAssertNil(actual.accessToken)
        XCTAssertEqual(
          TypedID(TypedID.Types.thing, id: "thingID"),
          actual.typedID)
    }

    func testEqualAndHash() {
        let base = StandaloneThing(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertTrue(base == base)

        let same = StandaloneThing(
          "thingID",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertTrue(base == same)
        XCTAssertEqual(base.hashValue, same.hashValue)

        let different = StandaloneThing(
          "thingID2",
          vendorThingID: "vendorThingID",
          accessToken: "accessToken")

        XCTAssertFalse(base == different)
        XCTAssertTrue(base != different)
        XCTAssertNotEqual(base.hashValue, different.hashValue)
    }

}
