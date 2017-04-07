//
//  ThingIFAPIScheduleTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2016/05/20.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIScheduleTriggerTests: OnboardedTestsBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {

        let temperatureAliasActions = [
          AliasAction(
            ALIAS1,
            actions: [
              Action("turnPower", value: true),
              Action("setPresetTemperature", value: 25)
            ]
          )
        ]

        var gotTriggerID: String?
        let targetID = self.onboardedApi.target!.typedID
        let schedulePredicateForTemperature = SchedulePredicate("1 * * * *")
        let checkDataForTemperature = TriggerToCheck(
          true,
          targetID: targetID,
          enabled: true,
          command: CommandToCheck(
            false,
            targetID: targetID,
            issuerID: self.onboardedApi.owner.typedID,
            commandState: nil,
            hasFiredByTriggerID: false,
            hasCreated: false,
            hasModified: false,
            aliasActions: temperatureAliasActions,
            aliasActionResults: []
          ),
          predicate: schedulePredicateForTemperature)

        var expectation =
          self.expectation(description: "post trigger for temperature")
        self.onboardedApi.postNewTrigger(
          TriggeredCommandForm(
            temperatureAliasActions,
            targetID: targetID),
          predicate: schedulePredicateForTemperature) { trigger, error in

            XCTAssertNil(error)
            XCTAssertEqual(checkDataForTemperature, TriggerToCheck(trigger))

            gotTriggerID = trigger?.triggerID
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(gotTriggerID)
        guard let triggerID1 = gotTriggerID else {
            return
        }

        let humidityAliasActions = [
          AliasAction(ALIAS2, actions: [Action("setPresetHumidity", value: 45)])
        ]

        let schedulePredicateForHumidity = SchedulePredicate("* 1 * * *")
        let checkDataForHumidity = TriggerToCheck(
          true,
          targetID: targetID,
          enabled: true,
          command: CommandToCheck(
            false,
            targetID: targetID,
            issuerID: self.onboardedApi.owner.typedID,
            commandState: nil,
            hasFiredByTriggerID: false,
            hasCreated: false,
            hasModified: false,
            aliasActions: humidityAliasActions,
            aliasActionResults: []
          ),
          predicate: schedulePredicateForHumidity)

        expectation = self.expectation(description: "post trigger for humidity")
        self.onboardedApi.postNewTrigger(
          TriggeredCommandForm(
            humidityAliasActions),
          predicate: schedulePredicateForHumidity) { trigger, error in

            XCTAssertNil(error)
            XCTAssertEqual(checkDataForHumidity, TriggerToCheck(trigger))

            gotTriggerID = trigger!.triggerID
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(gotTriggerID)
        guard let triggerID2 = gotTriggerID else {
            return
        }

        expectation = self.expectation(description: "list trigger first")
        self.onboardedApi.listTriggers(100)  { triggers, paginationKey, error in

            { () in
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                guard let triggers = triggers else {
                    return
                }

                XCTAssertEqual(
                  [triggerID1, triggerID2], triggers.map { $0.triggerID })


                XCTAssertEqual(
                  [checkDataForTemperature, checkDataForHumidity],
                  (triggers.map { TriggerToCheck($0)! })
                )

            }()
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        expectation = self.expectation(description: "delete trigger")
        self.onboardedApi.deleteTrigger(triggerID1) { deleted, error in
            XCTAssertNil(error)
            XCTAssertEqual(triggerID1, deleted)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        let modifiedHumidityAliasActions = [
          AliasAction(ALIAS2, actions: [Action("setPresetHumidity", value: 55)])
        ]

        let schedulePredicateForModifiedHumidity =
          SchedulePredicate("* 1 * * *")
        let checkDataForModifiedHumidity = TriggerToCheck(
          true,
          targetID: targetID,
          enabled: true,
          command: CommandToCheck(
            false,
            targetID: targetID,
            issuerID: self.onboardedApi.owner.typedID,
            commandState: nil,
            hasFiredByTriggerID: false,
            hasCreated: false,
            hasModified: false,
            aliasActions: modifiedHumidityAliasActions,
            aliasActionResults: []
          ),
          predicate: schedulePredicateForModifiedHumidity)

        expectation = self.expectation(description: "patch trigger")
        self.onboardedApi.patchTrigger(
            triggerID2,
            triggeredCommandForm: TriggeredCommandForm(
              modifiedHumidityAliasActions),
            predicate: schedulePredicateForModifiedHumidity) { trigger, error in

            XCTAssertNil(error)
            XCTAssertEqual(
              checkDataForModifiedHumidity,
              TriggerToCheck(trigger))
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        expectation = self.expectation(description: "list trigger second")
        self.onboardedApi.listTriggers(100) { triggers, paginationKey, error in

            { () in
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                guard let triggers = triggers else {
                    return
                }

                XCTAssertEqual([triggerID2], triggers.map { $0.triggerID })

                XCTAssertEqual(
                  [checkDataForModifiedHumidity],
                  (triggers.map { TriggerToCheck($0)! })
                )

            }()
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        expectation = self.expectation(description: "delete modified trigger")
        self.onboardedApi.deleteTrigger(triggerID2) { deleted, error in
            XCTAssertNil(error)
            XCTAssertEqual(triggerID2, deleted)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
    }

    func testInvalidSchedulePredicate() {
        let temperatureAliasActions = [
          AliasAction(
            ALIAS1,
            actions: [
              Action("turnPower", value: true),
              Action("setPresetTemperature", value: 25)
            ]
          )
        ]

        let expectation =
            self.expectation(description: "post trigger for color")

        self.onboardedApi.postNewTrigger(
          TriggeredCommandForm(temperatureAliasActions),
          predicate: SchedulePredicate("wrong format")) {
            trigger, error in

            XCTAssertNil(trigger)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  400,
                  errorCode: "WRONG_PREDICATE",
                  errorMessage: "Value for \'schedule\' field is incorrect")),
              error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
    }

}
