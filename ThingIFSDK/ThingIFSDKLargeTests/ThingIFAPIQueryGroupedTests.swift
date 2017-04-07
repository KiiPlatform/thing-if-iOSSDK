//
//  ThingIFAPIQueryGroupedTests.swift
//  ThingIFSDK
//
//  Created on 2017/04/03.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIQueryGroupedTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testQueryGroupedHitoryStates() throws {
        let airState1: [[String : Any]] = [
          [ "power" : true, "currentTemperature" : 23],
          [ "power" : true, "currentTemperature" : 24],
          [ "power" : true, "currentTemperature" : 25],
          [ "power" : true, "currentTemperature" : 26]
        ]
        let airState2: [[String : Any]] = [
          [ "power" : true, "currentTemperature" : 17],
          [ "power" : true, "currentTemperature" : 18],
          [ "power" : true, "currentTemperature" : 19],
          [ "power" : true, "currentTemperature" : 20]
        ]

        // update first 4 states
        let start = Date()
        for (index, state) in airState1.enumerated() {
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

        // to next date group
        sleep(60)
        // update second 4 states
        sleep(2)
        for (index, state) in airState2.enumerated() {
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
        let end = Date()

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(
              GroupedHistoryStatesQuery(
                self.ALIAS1,
                timeRange: TimeRange(start, to: end))) { states, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertGreaterThanOrEqual(states!.count, 2)

                var actualStates: [[String : Any]] = []
                states!.forEach { actualStates += $0.objects.map { $0.state } }
                XCTAssertEqual(
                  (airState1 + airState2) as NSArray,
                  actualStates as NSArray)
            }
        }

        self.executeAsynchronous { expectation in
            self.onboardedApi.query(
              GroupedHistoryStatesQuery(
                self.ALIAS1,
                timeRange: TimeRange(start, to: end),
                clause: RangeClauseInQuery.greaterThanOrEqualTo(
                  "currentTemperature",
                  limit: 23))) { states, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertGreaterThanOrEqual(states!.count, 1)

                var actualStates: [[String : Any]] = []
                states!.forEach { actualStates += $0.objects.map { $0.state } }
                XCTAssertEqual(
                  airState1 as NSArray,
                  actualStates as NSArray)
            }
        }
    }
}
