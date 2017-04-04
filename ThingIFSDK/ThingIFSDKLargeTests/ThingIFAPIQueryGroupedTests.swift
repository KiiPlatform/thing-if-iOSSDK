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
            let expectation =
              self.expectation(description: "updateState\(index)")
            onboardedApi.updateTargetState(ALIAS1, state: state) {
                (error) in
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
                XCTAssertNil(error)
            }
            sleep(1)
        }

        // to next date group
        sleep(60)
        // update second 4 states
        sleep(2)
        for (index, state) in airState2.enumerated() {
            let expectation =
              self.expectation(description: "updateState\(index)")
            onboardedApi.updateTargetState(ALIAS1, state: state) {
                (error) in
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
                XCTAssertNil(error)
            }
            sleep(1)
        }
        let end = Date()

        let expectation1 =
          self.expectation(description: "query with only time range ")
        self.onboardedApi.query(
          GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: TimeRange(start, to: end))) { states, error in

            XCTAssertNil(error)
            XCTAssertGreaterThanOrEqual(states!.count, 2)

            var actualStates: [[String : Any]] = []
            states!.forEach { actualStates += $0.objects.map { $0.state } }
            XCTAssertEqual(
              (airState1 + airState2) as NSArray,
              actualStates as NSArray)
            expectation1.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

        let expectation2 =
          self.expectation(description: "query with clause")
        self.onboardedApi.query(
          GroupedHistoryStatesQuery(
            ALIAS1,
            timeRange: TimeRange(start, to: end),
            clause: RangeClauseInQuery.greaterThanOrEqualTo(
              "currentTemperature",
              limit: 23))) { states, error in

            XCTAssertNil(error)
            XCTAssertGreaterThanOrEqual(states!.count, 1)

            var actualStates: [[String : Any]] = []
            states!.forEach { actualStates += $0.objects.map { $0.state } }
            XCTAssertEqual(
              airState1 as NSArray,
              actualStates as NSArray)
            expectation2.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
  }
}
