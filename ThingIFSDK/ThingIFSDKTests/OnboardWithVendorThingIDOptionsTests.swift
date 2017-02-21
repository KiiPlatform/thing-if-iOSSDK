//
//  OnboardWithVendorThingIDOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/21.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class OnboardWithVendorThingIDOptionsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }


    func testOptinalNotNil() {
        let testCases: [
          (
            expected:(
              thingType: String?,
              firmwareVersion: String?,
              thingProperties: [String : Any]?,
              layoutPosition: LayoutPosition?
            ),
            actual: OnboardWithVendorThingIDOptions
          )
        ] = [
          (
            ("thingType", "version", ["key" : "value"], LayoutPosition.gateway),
            OnboardWithVendorThingIDOptions(
              "thingType",
              firmwareVersion: "version",
              thingProperties: ["key" : "value"],
              position: LayoutPosition.gateway)
          ),
          (
            (nil, "version", ["key" : "value"], LayoutPosition.standalone),
            OnboardWithVendorThingIDOptions(
              firmwareVersion: "version",
              thingProperties: ["key" : "value"],
              position: LayoutPosition.standalone)
          ),
          (
            (nil, nil, ["key" : "value"], LayoutPosition.endnode),
            OnboardWithVendorThingIDOptions(
              thingProperties: ["key" : "value"],
              position: LayoutPosition.endnode)
          ),
          (
            (nil, nil, nil, LayoutPosition.endnode),
            OnboardWithVendorThingIDOptions(position: LayoutPosition.endnode)
          ),

          (
            ("thingType", nil, nil, nil),
            OnboardWithVendorThingIDOptions("thingType")
          ),
          (
            (nil, "version", nil, nil),
            OnboardWithVendorThingIDOptions(firmwareVersion: "version")
          ),
          (
            (nil, nil, ["key" : "value"], nil),
            OnboardWithVendorThingIDOptions(
              thingProperties: ["key" : "value"])
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (expected, actual) = testCase
            XCTAssertEqual(expected.thingType, actual.thingType, "\(index)")
            XCTAssertEqual(
              expected.firmwareVersion,
              actual.firmwareVersion,
              "\(index)")
            assertEqualsDictionary(
              expected.thingProperties,
              actual.thingProperties,
              "\(index)")
            XCTAssertEqual(
              expected.layoutPosition,
              actual.layoutPosition,
              "\(index)")
        }
    }

    func testOptinalNil() {
        let actual = OnboardWithVendorThingIDOptions()
        XCTAssertNil(actual.thingType)
        XCTAssertNil(actual.firmwareVersion)
        XCTAssertNil(actual.thingProperties)
        XCTAssertNil(actual.layoutPosition)
    }
}
