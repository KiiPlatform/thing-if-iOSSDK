//
//  StatePredicateTests.swift
//  ThingIFSDK
//
//  Created 2017/02/21.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class StatePredicateTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test() {
        let testCases: [
          (
            expected:
              (
                clause: TriggerClause,
                triggersWhen: TriggersWhen
              ),
            actual: StatePredicate
          )
        ] = [
          (
            (
              EqualsClauseInTrigger("alias", field: "f", intValue: 1),
              TriggersWhen.conditionTrue
            ),
            StatePredicate(
              Condition(
                EqualsClauseInTrigger("alias", field: "f", intValue: 1)),
              triggersWhen: TriggersWhen.conditionTrue)
          ),
          (
            (
              EqualsClauseInTrigger("alias", field: "f", intValue: 1),
              TriggersWhen.conditionFalseToTrue
            ),
            StatePredicate(
              Condition(
                EqualsClauseInTrigger("alias", field: "f", intValue: 1)),
              triggersWhen: TriggersWhen.conditionFalseToTrue)
          ),
          (
            (
              EqualsClauseInTrigger("alias", field: "f", intValue: 1),
              TriggersWhen.conditionChanged
            ),
            StatePredicate(
              Condition(
                EqualsClauseInTrigger("alias", field: "f", intValue: 1)),
              triggersWhen: TriggersWhen.conditionChanged)
          )
        ]

        for (index, testCase) in testCases.enumerated() {
            let (expected, actual) = testCase

            assertEqualsTriggerClause(
              expected.clause,
              actual.condition.clause,
              "\(index)")
            XCTAssertEqual(
              expected.triggersWhen,
              actual.triggersWhen,
              "\(index)")
            XCTAssertEqual(EventSource.states, actual.eventSource, "\(index)")
        }
    }
}

