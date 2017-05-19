//
//  OnboardWithThingIDOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/21.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class OnboardWithThingIDOptionsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }


    func testOptinalNotNil() {
        let testCases: [
          (
            expected: LayoutPosition,
            actual: OnboardWithThingIDOptions
          )
        ] = [
          (
            LayoutPosition.gateway,
            OnboardWithThingIDOptions(LayoutPosition.gateway)
          ),
          (
            LayoutPosition.standalone,
            OnboardWithThingIDOptions(LayoutPosition.standalone)
          ),
          (
            LayoutPosition.endnode,
            OnboardWithThingIDOptions(LayoutPosition.endnode)
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (expected, actual) = testCase
            XCTAssertEqual(expected, actual.layoutPosition, "\(index)")
        }
    }

    func testOptinalNil() {
        let actual = OnboardWithThingIDOptions()
        XCTAssertNil(actual.layoutPosition)
    }
}
