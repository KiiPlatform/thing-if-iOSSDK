//
//  PostNewTriggerForSchedulePredicateTests.swift
//  ThingIFSDK
//
//  Created on 2016/05/20.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewTriggerForSchedulePredicateTests: LargeTestBase {

    func testSuccess() {

        let api = self.onboardedApi!
        let onboardedTarget = api.target!

        let colorActions: [Dictionary<String, AnyObject>] = [
            [
                "setColor": [128, 0, 255]
            ],
            [
                "setColorTemperature": 25
            ]
        ]

        var triggerID1: String?

        var expectation =
            self.expectationWithDescription("post trigger for color")
        api.postNewTrigger(
            DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: colorActions,
            predicate: SchedulePredicate(schedule: "1 * * * *"),
            completionHandler: {
                (trigger, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertNotEqual(trigger!.triggerID, nil)
                    XCTAssertTrue(trigger!.enabled)
                    XCTAssertNil(trigger!.serverCode)

                    // check command.
                    XCTAssertEqual("", trigger!.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger!.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger!.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger!.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger!.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger!.command!.commandState)
                    XCTAssertNil(trigger!.command!.firedByTriggerID)
                    XCTAssertNil(trigger!.command!.created)
                    XCTAssertNil(trigger!.command!.modified)
                    XCTAssertEqual(colorActions, trigger!.command!.actions)
                    XCTAssertEqual([], trigger!.command!.actionResults)

                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger!.predicate.getEventSource())
                    XCTAssertEqual("1 * * * *",
                                   (trigger!.predicate
                                        as! SchedulePredicate).schedule)

                    triggerID1 = trigger!.triggerID
                    expectation.fulfill()
            }
        )
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        let powerAction: [Dictionary<String, AnyObject>] = [
            [
                "turnPower": true
            ],
            [
                "setBrightness": 50
            ]
        ]

        var triggerID2: String?

        expectation = self.expectationWithDescription("post trigger for power")
        api.postNewTrigger(
            DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: powerAction,
            predicate: SchedulePredicate(schedule: "* 1 * * *"),
            completionHandler: {
                (trigger, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertNotEqual(trigger!.triggerID, nil)
                    XCTAssertTrue(trigger!.enabled)
                    XCTAssertNil(trigger!.serverCode)

                    // check command.
                    XCTAssertEqual("", trigger!.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger!.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger!.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger!.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger!.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger!.command!.commandState)
                    XCTAssertNil(trigger!.command!.firedByTriggerID)
                    XCTAssertNil(trigger!.command!.created)
                    XCTAssertNil(trigger!.command!.modified)
                    XCTAssertEqual(powerAction, trigger!.command!.actions)
                    XCTAssertEqual([], trigger!.command!.actionResults)

                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger!.predicate.getEventSource())
                    XCTAssertEqual("* 1 * * *",
                                   (trigger!.predicate
                                        as! SchedulePredicate).schedule)

                    triggerID2 = trigger!.triggerID
                    expectation.fulfill()
            }
        )
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription("list trigger first")
        api.listTriggers(
            100,
            paginationKey: nil,
            completionHandler: {
                (triggers, paginationKey, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(2, triggers!.count)
                    for trigger in triggers! {
                        if trigger.triggerID == triggerID1 {
                            XCTAssertNotEqual(trigger, nil)
                            XCTAssertEqual(triggerID1, trigger.triggerID)
                            XCTAssertTrue(trigger.enabled)
                            XCTAssertNil(trigger.serverCode)

                            // check command.
                            XCTAssertEqual("", trigger.command!.commandID)
                            XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                           trigger.command!.schemaName)
                            XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                           trigger.command!.schemaVersion)
                            XCTAssertEqual(onboardedTarget.typedID,
                                           trigger.command!.targetID)
                            XCTAssertEqual(api.owner.typedID,
                                           trigger.command!.issuerID)
                            XCTAssertEqual(CommandState.SENDING,
                                           trigger.command!.commandState)
                            XCTAssertNil(trigger.command!.firedByTriggerID)
                            XCTAssertNil(trigger.command!.created)
                            XCTAssertNil(trigger.command!.modified)
                            XCTAssertEqual(colorActions,
                                           trigger.command!.actions)
                            XCTAssertEqual([], trigger.command!.actionResults)

                            // check predicate
                            XCTAssertEqual(EventSource.Schedule,
                                           trigger.predicate.getEventSource())
                            XCTAssertEqual("1 * * * *",
                                           (trigger.predicate
                                                as! SchedulePredicate).schedule)
                        } else if trigger.triggerID == triggerID2 {
                            XCTAssertNotEqual(trigger, nil)
                            XCTAssertEqual(triggerID2, trigger.triggerID)
                            XCTAssertTrue(trigger.enabled)
                            XCTAssertNil(trigger.serverCode)

                            // check command.
                            XCTAssertEqual("", trigger.command!.commandID)
                            XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                           trigger.command!.schemaName)
                            XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                           trigger.command!.schemaVersion)
                            XCTAssertEqual(onboardedTarget.typedID,
                                           trigger.command!.targetID)
                            XCTAssertEqual(api.owner.typedID,
                                           trigger.command!.issuerID)
                            XCTAssertEqual(CommandState.SENDING,
                                           trigger.command!.commandState)
                            XCTAssertNil(trigger.command!.firedByTriggerID)
                            XCTAssertNil(trigger.command!.created)
                            XCTAssertNil(trigger.command!.modified)
                            XCTAssertEqual(powerAction,
                                           trigger.command!.actions)
                            XCTAssertEqual([], trigger.command!.actionResults)

                            // check predicate
                            XCTAssertEqual(EventSource.Schedule,
                                           trigger.predicate.getEventSource())
                            XCTAssertEqual("* 1 * * *",
                                           (trigger.predicate
                                                as! SchedulePredicate).schedule)
                        }
                    }
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription("delete trigger")
        api.deleteTrigger(
            triggerID1!,
            completionHandler: {
                (deleted, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(triggerID1, deleted)
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        let modifiedPowerAction: [Dictionary<String, AnyObject>] = [
            [
                "turnPower": true
            ],
            [
                "setBrightness": 100
            ]
        ]

        expectation = self.expectationWithDescription("patch trigger")
        api.patchTrigger(
            triggerID2!,
            schemaName: DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: modifiedPowerAction,
            predicate: SchedulePredicate(schedule: "* * 1 * *"),
            completionHandler: {
                (trigger, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertEqual(triggerID2, trigger!.triggerID)
                    XCTAssertTrue(trigger!.enabled)
                    XCTAssertNil(trigger!.serverCode)

                    // check command.
                    XCTAssertEqual("", trigger!.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger!.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger!.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger!.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger!.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger!.command!.commandState)
                    XCTAssertNil(trigger!.command!.firedByTriggerID)
                    XCTAssertNil(trigger!.command!.created)
                    XCTAssertNil(trigger!.command!.modified)
                    XCTAssertEqual(modifiedPowerAction,
                                   trigger!.command!.actions)
                    XCTAssertEqual([], trigger!.command!.actionResults)

                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger!.predicate.getEventSource())
                    XCTAssertEqual("* * 1 * *",
                                   (trigger!.predicate
                                        as! SchedulePredicate).schedule)

                    expectation.fulfill()
            }
        )
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription("list trigger second")
        api.listTriggers(
            100,
            paginationKey: nil,
            completionHandler: {
                (triggers, paginationKey, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(1, triggers!.count)
                    let trigger = triggers![0]
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertEqual(triggerID2, trigger.triggerID)
                    XCTAssertTrue(trigger.enabled)
                    XCTAssertNil(trigger.serverCode)

                            // check command.
                    XCTAssertEqual("", trigger.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger.command!.commandState)
                    XCTAssertNil(trigger.command!.firedByTriggerID)
                    XCTAssertNil(trigger.command!.created)
                    XCTAssertNil(trigger.command!.modified)
                    XCTAssertEqual(modifiedPowerAction,
                                   trigger.command!.actions)
                    XCTAssertEqual([], trigger.command!.actionResults)
                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger.predicate.getEventSource())
                    XCTAssertEqual("* * 1 * *",
                                   (trigger.predicate
                                    as! SchedulePredicate).schedule)
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }
    }

    func testInvalidSchedulePredicate() {
        let api = self.onboardedApi!
        let expectation =
            self.expectationWithDescription("post trigger for color")
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "setColor": [128, 0, 255]
            ],
            [
                "setColorTemperature": 25
            ]
        ]

        api.postNewTrigger(
            DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: actions,
            predicate: SchedulePredicate(schedule: "wrong format"),
            completionHandler: {
                (trigger, error) -> Void in
                XCTAssertNil(trigger)
                XCTAssertTrue(error != nil)
                switch error! {
                case let .ERROR_RESPONSE(reason):
                    XCTAssertEqual(400, reason.httpStatusCode)
                    XCTAssertEqual("WRONG_PREDICATE", reason.errorCode)
                    XCTAssertEqual("Value for \'schedule\' field is incorrect",
                                   reason.errorMessage)
                    break
                default:
                    XCTFail()
                    break
                }
                expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

    }
}
