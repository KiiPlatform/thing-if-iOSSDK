//
//  ThingIFAPIQueryUngroupedTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

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

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(nextPaginationKey)
                XCTAssertEqual([], results!)
            }
        }
    }

    func testSuccessQueryThingUpdateStates() {
        let states = [
            [ "power" : true, "currentTemperature" : 23],
            [ "power" : true, "currentTemperature" : 24],
            [ "power" : true, "currentTemperature" : 25],
            [ "power" : true, "currentTemperature" : 26]
        ]

        // update 4 states
        for state in states {
            self.executeAsynchronous { expectation in
                self.onboardedApi.updateTargetState(self.ALIAS1, state: state) {
                    (error) in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                }
            }
            sleep(1)
        }

        // all query
        let query1 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause())
        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query1) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(nextPaginationKey)
                XCTAssertEqual(4, results!.count)
                XCTAssertEqual(states[0] as NSDictionary, results![0].state as NSDictionary)
                XCTAssertNotNil(results![0].createdAt)
                XCTAssertEqual(states[1] as NSDictionary, results![1].state as NSDictionary)
                XCTAssertNotNil(results![1].createdAt)
                XCTAssertEqual(states[2] as NSDictionary, results![2].state as NSDictionary)
                XCTAssertNotNil(results![2].createdAt)
                XCTAssertEqual(states[3] as NSDictionary, results![3].state as NSDictionary)
                XCTAssertNotNil(results![3].createdAt)
            }
        }

        // query with empty result returned
        let query2 = HistoryStatesQuery(
            ALIAS1,
            clause: RangeClauseInQuery.greaterThan("currentTemperature", limit: 30),
            firmwareVersion: "v1")

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query2) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(nextPaginationKey)
                XCTAssertEqual(0, results!.count)
            }
        }

        // query with bestEffortLimit
        let query3 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause(),
            firmwareVersion: "v1",
            bestEffortLimit: 3)

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query3) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual("100/3", nextPaginationKey)
                XCTAssertEqual(3, results!.count)
                XCTAssertEqual(states[0] as NSDictionary, results![0].state as NSDictionary)
                XCTAssertNotNil(results![0].createdAt)
                XCTAssertEqual(states[1] as NSDictionary, results![1].state as NSDictionary)
                XCTAssertNotNil(results![1].createdAt)
                XCTAssertEqual(states[2] as NSDictionary, results![2].state as NSDictionary)
                XCTAssertNotNil(results![2].createdAt)
            }
        }

        // query with pagination key
        let query4 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause(),
            nextPaginationKey: "100/3")

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query4) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(nextPaginationKey)
                XCTAssertEqual(1, results!.count)
                XCTAssertEqual(states[3] as NSDictionary, results![0].state as NSDictionary)
                XCTAssertNotNil(results![0].createdAt)
            }
        }

        // update thing new versio, in v3, ALIAS1 is not defined.
        self.executeAsynchronous { expectation in
            self.onboardedApi.update(firmwareVersion: "v3") {
                error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
            }
        }

        // query with older firmwareVersion, in v3, ALIAS1 is not defined.
        let query5 = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause(),
            firmwareVersion: "v1")
        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query5) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(nextPaginationKey)
                XCTAssertEqual(4, results!.count)
                XCTAssertEqual(states[0] as NSDictionary, results![0].state as NSDictionary)
                XCTAssertNotNil(results![0].createdAt)

                XCTAssertEqual(states[1] as NSDictionary, results![1].state as NSDictionary)
                XCTAssertNotNil(results![1].createdAt)
                XCTAssertEqual(states[2] as NSDictionary, results![2].state as NSDictionary)
                XCTAssertNotNil(results![2].createdAt)
                XCTAssertEqual(states[3] as NSDictionary, results![3].state as NSDictionary)
                XCTAssertNotNil(results![3].createdAt)
            }
        }
    }

    func testFailedQueryWithNotDefinedAlias404Error() {
        // update thing new versio, in v3, ALIAS1 is not defined.

        self.executeAsynchronous { expectation in
            self.onboardedApi.update(firmwareVersion: "v3") { error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
            }
        }

        let query = HistoryStatesQuery(
            ALIAS1,
            clause: AllClause())

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(query) {
                results, nextPaginationKey, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(results)
                XCTAssertNil(nextPaginationKey)
                XCTAssertEqual(
                  ThingIFError.errorResponse(
                    required: ErrorResponse(
                      404,
                      errorCode: "TRAIT_ALIAS_NOT_FOUND",
                      errorMessage: "The trait alias was not found")),
                  error)
            }
        }
    }
}
