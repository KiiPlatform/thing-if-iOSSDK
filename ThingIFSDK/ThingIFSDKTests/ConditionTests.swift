//
//  ConditionTests.swift
//  ThingIFSDK
//
//  Created on 2017/02/20.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ConditionTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let clause = EqualsClauseInTrigger("alias", field: "f", intValue: 1)
        let actual = Condition(clause)

        assertEqualsTriggerClause(clause, actual.clause)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = Condition(coder: decoder)!;
        decoder.finishDecoding();

        assertEqualsTriggerClause(actual.clause, deserialized.clause)
    }
}
