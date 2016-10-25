//
//  ConditionNSCodingTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ConditionNSCodingTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let clause = EqualsClause(field: "f", stringValue: "v")
        let condition = Condition(clause: clause)

        let data = NSKeyedArchiver.archivedData(withRootObject: condition)

        XCTAssertNotNil(data)

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! Condition

        XCTAssertNotNil(decode)
        XCTAssertNotNil(decode.clause)
        XCTAssertEqual(decode.toNSDictionary(), condition.toNSDictionary());
    }
}
