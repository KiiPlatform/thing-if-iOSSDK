//
//  copyWithTarget.swift
//  ThingIFSDK
//
//  Created by Yongping on 9/3/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class CopyWithTargetTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testCopyWithTarget() {
        let api: ThingIFAPI! = TestSetting().api
        let newTarget = Target(typedID: TypedID(type: "THING", id: "newID"))
        let newIotapi = api.copyWithTarget(newTarget)
        XCTAssertEqualIoTAPIWithoutTarget(api, newIotapi)
        XCTAssertEqual(newIotapi.target?.typedID.toString(), newTarget.typedID.toString())
    }
}