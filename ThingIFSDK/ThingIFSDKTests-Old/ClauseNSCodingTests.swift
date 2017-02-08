//
//  ClauseNSCodingTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ClauseNSCodingTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRangeClause() {
        let clause = RangeClause(field: "f", lowerLimitInt: 0, lowerIncluded: false)

        let data = NSKeyedArchiver.archivedData(withRootObject: clause)

        XCTAssertNotNil(data)

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! Clause

        XCTAssertNotNil(decode)
        verifyDict2(decode.makeDictionary(), clause.makeDictionary());
    }

    func testAndClause() {
        let clause = AndClause(clauses:
            EqualsClause(field: "f", stringValue: "v"),
            RangeClause(field: "f", lowerLimitInt: 0, lowerIncluded: false))

        let data = NSKeyedArchiver.archivedData(withRootObject: clause)

        XCTAssertNotNil(data)

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! Clause

        XCTAssertNotNil(decode)
        verifyDict2(decode.makeDictionary(), clause.makeDictionary());
    }

    func testAndClause2() {
        var clauses = [Clause]()
        clauses.append(EqualsClause(field: "f", stringValue: "v"))
        clauses.append(RangeClause(field: "f", lowerLimitInt: 0, lowerIncluded: false))
        let clause = AndClause(clauses: clauses)

        let data = NSKeyedArchiver.archivedData(withRootObject: clause)

        XCTAssertNotNil(data)

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! Clause

        XCTAssertNotNil(decode)
        verifyDict2(decode.makeDictionary(), clause.makeDictionary());
    }

    func testOrClause() {
        let clause = OrClause(clauses:
            NotEqualsClause(field: "f", stringValue: "v"),
            RangeClause(field: "f", upperLimitInt: 0, upperIncluded: false))

        let data = NSKeyedArchiver.archivedData(withRootObject: clause)

        XCTAssertNotNil(data)

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! Clause

        XCTAssertNotNil(decode)
        verifyDict2(decode.makeDictionary(), clause.makeDictionary());
    }

    func testOrClause2() {
        var clauses = [Clause]()
        clauses.append(NotEqualsClause(field: "f", stringValue: "v"))
        clauses.append(RangeClause(field: "f", upperLimitInt: 0, upperIncluded: false))
        let clause = OrClause(clauses: clauses)

        let data = NSKeyedArchiver.archivedData(withRootObject: clause)

        XCTAssertNotNil(data)

        let decode = NSKeyedUnarchiver.unarchiveObject(with: data) as! Clause

        XCTAssertNotNil(decode)
        verifyDict2(decode.makeDictionary(), clause.makeDictionary());
    }
}
