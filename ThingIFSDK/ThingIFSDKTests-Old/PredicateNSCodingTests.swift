//
//  PredicateNSCodingTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PredicateNSCodingTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStatePredicate() {
        let predicate = StatePredicate(
                condition: Condition(clause: EqualsClause(field: "f", stringValue: "v")),
                triggersWhen: TriggersWhen.conditionFalseToTrue);

        let data = NSKeyedArchiver.archivedData(withRootObject: predicate);

        XCTAssertNotNil(data);

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! StatePredicate;

        XCTAssertNotNil(decode);
        XCTAssertNotNil(decode.condition);
        self.verifyDict2(decode.condition.makeDictionary(), predicate.condition.makeDictionary());
        XCTAssertEqual(decode.triggersWhen, predicate.triggersWhen);
    }
}
