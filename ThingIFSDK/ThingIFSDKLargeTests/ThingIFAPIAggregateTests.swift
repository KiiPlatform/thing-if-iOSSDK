//
//  ThingIFAPIAggregateTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIAggregateTests: OnboardedTestsBase
{

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccessEmptyResults() {
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date())
        let query = GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: timeRange,
            clause: AllClause())
        let aggregation = Aggregation.makeCountAggregation(
            "power",
            fieldType:Aggregation.FieldType.bool)

        self.executeAsynchronous { expectation in
            self.onboardedApi.aggregate(query, aggregation: aggregation) {
                (results: [AggregatedResult<Bool>]?, error) in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual([], results!)
            }
        }
    }

    func testSuccessCount() {
        let states = [
            [ "power" : true, "currentTemperature" : 23],
            [ "power" : true, "currentTemperature" : 26]
        ]

        for state in states {
            self.executeAsynchronous { expectation in
                self.onboardedApi.updateTargetState(self.ALIAS1, state: state) {
                    (error) in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                }
                sleep(2)
            }
        }

        let now = Date()
        let timeRange = TimeRange(now, to: now)
        let query = GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: timeRange,
            clause: AllClause())
        let aggregation = Aggregation.makeCountAggregation(
            "currentTemperature",
            fieldType:Aggregation.FieldType.integer)

        self.executeAsynchronous { expectation in
            self.onboardedApi.aggregate(query, aggregation: aggregation) {
                (results: [AggregatedResult<Int>]?, error) in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(1, results?.count)
                let result = results![0]
                XCTAssertNotNil(result)
                XCTAssertTrue(timeRange.from >= result.timeRange.from)
                XCTAssertTrue(timeRange.to <= result.timeRange.to)
                XCTAssertEqual(2, result.value)
                XCTAssertEqual(0, result.aggregatedObjects.count)
            }
        }
    }

    func testSuccessMax() throws {
        let states = [
            [ "power" : true, "currentTemperature" : 23],
            [ "power" : true, "currentTemperature" : 26]
        ]

        for state in states {
            self.executeAsynchronous { expectation in
                self.onboardedApi.updateTargetState(self.ALIAS1, state: state) {
                    (error) in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                }
                sleep(2)
            }
        }

        let now = Date()
        let timeRange = TimeRange(now, to: now)
        let query = GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: timeRange,
            clause: AllClause())
        let aggregation = try Aggregation.makeMaxAggregation(
            "currentTemperature",
            fieldType:Aggregation.FieldType.integer)

        self.executeAsynchronous { expectation in
            self.onboardedApi.aggregate(query, aggregation: aggregation) {
                (results: [AggregatedResult<Int>]?, error) in
                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(1, results?.count)
                let result = results![0]
                XCTAssertNotNil(result)
                XCTAssertTrue(timeRange.from >= result.timeRange.from)
                XCTAssertTrue(timeRange.to <= result.timeRange.to)
                XCTAssertEqual(26, result.value)
                XCTAssertEqual(1, result.aggregatedObjects.count)
                XCTAssertEqual(
                  states[1] as NSDictionary,
                  result.aggregatedObjects[0].state as NSDictionary)
                XCTAssertNotNil(result.aggregatedObjects[0].createdAt)
            }
        }
    }

    func testSuccessMin() throws {
        let states = [
            [ "power" : true, "currentTemperature" : 23],
            [ "power" : true, "currentTemperature" : 26]
        ]

        for state in states {
            self.executeAsynchronous { expectation in
                self.onboardedApi.updateTargetState(self.ALIAS1, state: state) {
                    (error) in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                }
                sleep(2)
            }
        }

        let now = Date()
        let timeRange = TimeRange(now, to: now)
        let query = GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: timeRange,
            clause: AllClause())
        let aggregation = try Aggregation.makeMinAggregation(
            "currentTemperature",
            fieldType:Aggregation.FieldType.integer)

        self.executeAsynchronous { expectation in
            self.onboardedApi.aggregate(query, aggregation: aggregation) {
                (results: [AggregatedResult<Int>]?, error) in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(1, results?.count)
                let result = results![0]
                XCTAssertNotNil(result)
                XCTAssertTrue(timeRange.from >= result.timeRange.from)
                XCTAssertTrue(timeRange.to <= result.timeRange.to)
                XCTAssertEqual(23, result.value)
                XCTAssertEqual(1, result.aggregatedObjects.count)
                XCTAssertEqual(
                  states[0] as NSDictionary,
                  result.aggregatedObjects[0].state as NSDictionary)
                XCTAssertNotNil(result.aggregatedObjects[0].createdAt)
            }
        }
    }

    func testSuccessMean() throws {
        let states = [
            [ "power" : true, "currentTemperature" : 22],
            [ "power" : true, "currentTemperature" : 28]
        ]

        for state in states {
            self.executeAsynchronous { expectation in
                self.onboardedApi.updateTargetState(self.ALIAS1, state: state) {
                    (error) in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                }
                sleep(2)
            }
        }

        let now = Date()
        let timeRange = TimeRange(now, to: now)
        let query = GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: timeRange,
            clause: AllClause())
        let aggregation = try Aggregation.makeMeanAggregation(
            "currentTemperature",
            fieldType:Aggregation.FieldType.integer)

        self.executeAsynchronous { expectation in
            self.onboardedApi.aggregate(query, aggregation: aggregation) {
                (results: [AggregatedResult<Int>]?, error) in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(1, results?.count)
                let result = results![0]
                XCTAssertNotNil(result)
                XCTAssertTrue(timeRange.from >= result.timeRange.from)
                XCTAssertTrue(timeRange.to <= result.timeRange.to)
                XCTAssertEqual(25, result.value)
                XCTAssertEqual(0, result.aggregatedObjects.count)
            }
        }
    }

    func testSuccessSum() throws {
        let states = [
            [ "power" : true, "currentTemperature" : 23],
            [ "power" : true, "currentTemperature" : 26]
        ]

        for state in states {
            self.executeAsynchronous { expectation in
                self.onboardedApi.updateTargetState(self.ALIAS1, state: state) {
                    (error) in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                }
                sleep(2)
            }
        }

        let now = Date()
        let timeRange = TimeRange(now, to: now)
        let query = GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: timeRange,
            clause: AllClause())
        let aggregation = try Aggregation.makeSumAggregation(
            "currentTemperature",
            fieldType:Aggregation.FieldType.integer)

        self.executeAsynchronous { expectation in
            self.onboardedApi.aggregate(query, aggregation: aggregation) {
                (results: [AggregatedResult<Int>]?, error) in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(1, results?.count)
                let result = results![0]
                XCTAssertNotNil(result)
                XCTAssertTrue(timeRange.from >= result.timeRange.from)
                XCTAssertTrue(timeRange.to <= result.timeRange.to)
                XCTAssertEqual(49, result.value)
                XCTAssertEqual(0, result.aggregatedObjects.count)
            }
        }
    }
}
