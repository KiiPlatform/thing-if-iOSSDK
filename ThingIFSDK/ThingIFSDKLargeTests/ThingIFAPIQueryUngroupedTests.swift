//
//  ThingIFAPIQueryUngroupedTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIQueryUngroupedTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccessQueryEmptyResults() {
        let query = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause())

        let expectation = self.expectation(description: "testSuccessQueryEmptyResults")
        onboardedApi.query(query) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual([], results!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testSuccessQueryThingUpdateStates() {
        let states = [
            [ "power" : true, "currentTemperature" : 23],
            [ "power" : true, "currentTemperature" : 24],
            [ "power" : true, "currentTemperature" : 25],
            [ "power" : true, "currentTemperature" : 26]
        ]

        states.forEach {
            let expectation = self.expectation(description: "updateTargetState")
            onboardedApi.updateTargetState(ALIAS1, state: $0) {
                (error) in
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
                XCTAssertNil(error)
            }
            sleep(1)
        }

        let query1 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause())
        let expectation1 = self.expectation(description: "testSuccessQueryThingUpdateStates1")
        onboardedApi.query(query1) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(4, results!.count)
            expectation1.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let query2 = HistoryStatesQuery(
            ALIAS1,
            clause: RangeClauseInQuery.greaterThan("currentTemperature", limit: 30),
            firmwareVersion: "v1")
        let expectation2 = self.expectation(description: "testSuccessQueryThingUpdateStates2")
        onboardedApi.query(query2) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(0, results!.count)
            expectation2.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let query3 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause(),
            firmwareVersion: "v1",
            bestEffortLimit: 3)
        let expectation3 = self.expectation(description: "testSuccessQueryThingUpdateStates3")
        onboardedApi.query(query3) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertEqual("100/3", nextPaginationKey)
            XCTAssertEqual(3, results!.count)
            expectation3.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let query4 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause(),
            nextPaginationKey: "100/3")
        let expectation4 = self.expectation(description: "testSuccessQueryThingUpdateStates4")
        onboardedApi.query(query4) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(1, results!.count)
            expectation4.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let query5 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause(),
            firmwareVersion: "v1")
        let expectation5 = self.expectation(description: "testSuccessQueryThingUpdateStates5")
        onboardedApi.query(query5) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(4, results!.count)
            expectation5.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testFailedQueryWithNotDefinedAlias404Error() {

        let updateExpectation = self.expectation(description: "updateFirmwareVersion")
        onboardedApi.update(firmwareVersion: "v3") {
            error -> Void in
            updateExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let query = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause())

        let expectation = self.expectation(description: "testError404")
        onboardedApi.query(query) {
            (results: [HistoryState]?, nextPaginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(
                        404,
                        errorCode: "TRAIT_ALIAS_NOT_FOUND",
                        errorMessage: "The trait alias was not found")),
                error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
