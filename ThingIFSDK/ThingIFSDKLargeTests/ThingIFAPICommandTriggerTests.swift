//
//  ThingIFAPICommandTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/04/05.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class ThingIFAPICommandTriggerTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /*
     Summary of testSuccess.

     === Aim ===
     testSuccess checks APIs concerned with trigger for
     command. This test checks following methods:

     - ThingIFAPI.listTriggers
     - ThingIFAPI.getTrigger
     - ThingIFAPI.postNewTrigger
     - ThingIFAPI.patchTrigger
     - ThingIFAPI.deleteTrigger

     This test checks only success case. Error cases are out of scope
     of this test.

     === Test flow ===

     1. Get triggers with ThingIFAPI.listTriggers. The list is empty.
     2. Create 3 triggers with ThingIFAPI.postNewTrigger. Each
        creating triggers has different type of predicate. One is
        StatePredicate, other is SchedulePredicate, and the other is
        ScheduleOncePredicate.
     3. Get triggers with ThingIFAPI.listTriggers again. The list
        contains 3 triggers which we create at 2.
     4. Update all triggers which we carete at 2 with
        ThingIFAPI.patchTrigger. We change predicates and alias
        actions in this update.
     5. Get triggers with ThingIFAPI.listTriggers again. The list
        contains triggers which we update at 4.
     6. Get each triggers with ThingIFAPI.getTrigger. The triggers is
        same as triggers updated at 4.
     7. Get a trigger with ThingIFAPI.listTriggers using bestEffortLimit as 1.
     8. Get rest of triggers with ThingIFAPI.listTriggers using
        bestEffortLimit and paginationKey.
     9. Enable and disable a trigger.
     10. Delete all triggers with ThingIFAPI.deleteTrigger.
     */
    func testSuccess() {

        // List empty triggers
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers { triggers, paginationKey, error in
                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual([], triggers)
                }
            }
        }

        // Set of created triggers by ThingIFAPI.postNewTrigger. We
        // use this to check that results of ThingIFAPI.listTriggers
        // is same trigger which we create with
        // ThingIFAPI.postNewTrigger.
        var createdTriggers: Set<Trigger> = []

        // post new comand trigger with StatePredicate
        let temperatureAliasActions = [
          AliasAction(
            ALIAS1,
            actions: [
              Action("turnPower", value: true),
              Action("setPresetTemperature", value: 25)
            ]
          )
        ]
        let statePredicate = StatePredicate(
          Condition(
            EqualsClauseInTrigger(ALIAS1, field: "power", boolValue: true)),
          triggersWhen: .conditionTrue)
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewTrigger(
              TriggeredCommandForm(temperatureAliasActions),
              predicate: statePredicate) { trigger, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertEqual(
                  TriggerToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    enabled: true,
                    command: CommandToCheck(
                      false,
                      targetID: self.onboardedApi.target!.typedID,
                      issuerID: self.onboardedApi.owner.typedID,
                      commandState: nil,
                      hasFiredByTriggerID: false,
                      hasCreated: false,
                      hasModified: false,
                      aliasActions: temperatureAliasActions,
                      aliasActionResults: []
                    ),
                    predicate: statePredicate),
                  TriggerToCheck(trigger)
                )
                if let trigger = trigger {
                    // createdTriggers is set so we can not insert
                    // same trigger to createdTriggers. If server
                    // returns same trigger, it is server error. We
                    // catch it with this check.
                    XCTAssertTrue(createdTriggers.insert(trigger).inserted)
                }
            }
        }

        // post new comand trigger with SchedulePredicate
        let schedulePredicate = SchedulePredicate("1 * * * *")
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewTrigger(
              TriggeredCommandForm(temperatureAliasActions),
              predicate: schedulePredicate) { trigger, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertEqual(
                  TriggerToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    enabled: true,
                    command: CommandToCheck(
                      false,
                      targetID: self.onboardedApi.target!.typedID,
                      issuerID: self.onboardedApi.owner.typedID,
                      commandState: nil,
                      hasFiredByTriggerID: false,
                      hasCreated: false,
                      hasModified: false,
                      aliasActions: temperatureAliasActions,
                      aliasActionResults: []
                    ),
                    predicate: schedulePredicate),
                  TriggerToCheck(trigger)
                )
                if let trigger = trigger {
                    // createdTriggers is set so we can not insert
                    // same trigger to createdTriggers. If server
                    // returns same trigger, it is server error. We
                    // catch it with this check.
                    XCTAssertTrue(createdTriggers.insert(trigger).inserted)
                }
            }
        }

        // post new comand trigger with ScheduleOncePredicate
        let scheduleOncePredicate =
          ScheduleOncePredicate(Date(timeIntervalSinceNow: 3600))
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewTrigger(
              TriggeredCommandForm(temperatureAliasActions),
              predicate: scheduleOncePredicate) { trigger, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertEqual(
                  TriggerToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    enabled: true,
                    command: CommandToCheck(
                      false,
                      targetID: self.onboardedApi.target!.typedID,
                      issuerID: self.onboardedApi.owner.typedID,
                      commandState: nil,
                      hasFiredByTriggerID: false,
                      hasCreated: false,
                      hasModified: false,
                      aliasActions: temperatureAliasActions,
                      aliasActionResults: []
                    ),
                    predicate: scheduleOncePredicate),
                  TriggerToCheck(trigger)
                )
                if let trigger = trigger {
                    // createdTriggers is set so we can not insert
                    // same trigger to createdTriggers. If server
                    // returns same trigger, it is server error. We
                    // catch it with this check.
                    XCTAssertTrue(createdTriggers.insert(trigger).inserted)
                }
            }
        }

        // List all triggers
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers { triggers, paginationKey, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual(createdTriggers, Set(triggers))
                }
            }
        }

        // patch all triggers
        var modifiedTriggers: Set<Trigger> = []
        let triggerIDs = createdTriggers.map { $0.triggerID }
        XCTAssertEqual(3, triggerIDs.count)
        let humidityAliasActions = [
          AliasAction(ALIAS2, actions: [Action("setPresetHumidity", value: 45)])
        ]

        // patch to StatePredicate
        let modifiedStatePredicate = StatePredicate(
          Condition(
            NotEqualsClauseInTrigger(
              EqualsClauseInTrigger(ALIAS1, field: "power", boolValue: true))),
          triggersWhen: .conditionTrue)
        self.executeAsynchronous { expectation in
            self.onboardedApi.patchTrigger(
              triggerIDs[0],
              triggeredCommandForm:
                TriggeredCommandForm(humidityAliasActions),
              predicate: modifiedStatePredicate) { trigger, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertEqual(
                  TriggerToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    enabled: true,
                    command: CommandToCheck(
                      false,
                      targetID: self.onboardedApi.target!.typedID,
                      issuerID: self.onboardedApi.owner.typedID,
                      commandState: nil,
                      hasFiredByTriggerID: false,
                      hasCreated: false,
                      hasModified: false,
                      aliasActions: humidityAliasActions,
                      aliasActionResults: []
                    ),
                    predicate: modifiedStatePredicate),
                  TriggerToCheck(trigger)
                )
                if let trigger = trigger {
                    XCTAssertTrue(modifiedTriggers.insert(trigger).inserted)
                }
            }
        }

        // patch to SchedulePredicate
        let modifiedSchedulePredicate = SchedulePredicate("* 1 * * *")
        self.executeAsynchronous { expectation in
            self.onboardedApi.patchTrigger(
              triggerIDs[1],
              triggeredCommandForm:
                TriggeredCommandForm(humidityAliasActions),
              predicate: modifiedSchedulePredicate) { trigger, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertEqual(
                  TriggerToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    enabled: true,
                    command: CommandToCheck(
                      false,
                      targetID: self.onboardedApi.target!.typedID,
                      issuerID: self.onboardedApi.owner.typedID,
                      commandState: nil,
                      hasFiredByTriggerID: false,
                      hasCreated: false,
                      hasModified: false,
                      aliasActions: humidityAliasActions,
                      aliasActionResults: []
                    ),
                    predicate: modifiedSchedulePredicate),
                  TriggerToCheck(trigger)
                )
                if let trigger = trigger {
                    XCTAssertTrue(modifiedTriggers.insert(trigger).inserted)
                }
            }
        }

        // patch to ScheduleOncePredicate
        let modifiedScheduleOncePredicate =
        ScheduleOncePredicate(Date(timeIntervalSinceNow: 7200))
        self.executeAsynchronous { expectation in
            self.onboardedApi.patchTrigger(
              triggerIDs[2],
              triggeredCommandForm:
                TriggeredCommandForm(humidityAliasActions),
              predicate: modifiedScheduleOncePredicate) { trigger, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertEqual(
                  TriggerToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    enabled: true,
                    command: CommandToCheck(
                      false,
                      targetID: self.onboardedApi.target!.typedID,
                      issuerID: self.onboardedApi.owner.typedID,
                      commandState: nil,
                      hasFiredByTriggerID: false,
                      hasCreated: false,
                      hasModified: false,
                      aliasActions: humidityAliasActions,
                      aliasActionResults: []
                    ),
                    predicate: modifiedScheduleOncePredicate),
                  TriggerToCheck(trigger)
                )
                if let trigger = trigger {
                    XCTAssertTrue(modifiedTriggers.insert(trigger).inserted)
                }
            }
        }

        // List all modified triggers
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers { triggers, paginationKey, error in
                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual(modifiedTriggers, Set(triggers))
                }
            }
        }

        // Get triggers
        for modifiedTrigger in modifiedTriggers {
            self.executeAsynchronous { expectation in
                self.onboardedApi.getTrigger(
                  modifiedTrigger.triggerID) { trigger, error in
                    defer {
                        expectation.fulfill()
                    }

                    XCTAssertNil(error)
                    XCTAssertEqual(modifiedTrigger, trigger)
                }
            }
        }

        // List a trigger.
        var gotPaginationKey: String?
        var gotTrigger: Trigger?
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers(1) {
                triggers, paginationKey, error in

                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertNotNil(paginationKey)
                gotPaginationKey = paginationKey
                XCTAssertNotNil(triggers)

                guard let triggers = triggers else {
                    return
                }
                XCTAssertEqual(1, triggers.count)
                XCTAssertTrue(modifiedTriggers.contains(triggers[0]))
                gotTrigger = triggers[0]
            }
        }

        // List rest triggers
        guard let paginationKey = gotPaginationKey,
              let triggerToRemove = gotTrigger else {
            return
        }
        XCTAssertNotNil(modifiedTriggers.remove(triggerToRemove))
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers(
              3,
              paginationKey: paginationKey) { triggers, paginationKey, error in
                defer {
                    expectation.fulfill()
                }

                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual(modifiedTriggers, Set(triggers))
                }
            }
        }

        // Disable trigger
        let trigger = modifiedTriggers.first!
        self.executeAsynchronous { expectation in
            self.onboardedApi.enableTrigger(trigger.triggerID, enable: false) {
                received, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual(Trigger(trigger, enabled: false), received)
            }
        }
        // Enable trigger
        self.executeAsynchronous { expectation in
            self.onboardedApi.enableTrigger(trigger.triggerID, enable: true) {
                received, error in

                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertEqual(Trigger(trigger, enabled: true), received)
            }
        }

        // delete all triggers
        for triggerID in triggerIDs {
            self.executeAsynchronous { expectation in
                self.onboardedApi.deleteTrigger(triggerID) { deleted, error in
                    defer {
                        expectation.fulfill()
                    }
                    XCTAssertNil(error)
                    XCTAssertEqual(triggerID, deleted)
                }
            }
        }
    }


    func testFailToGetTrigger() {
        self.executeAsynchronous { expectation in
            self.onboardedApi.getTrigger("dummyID") { trigger, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(trigger)
                XCTAssertEqual(ThingIFError.errorResponse(
                                 required: ErrorResponse(
                                   404,
                                   errorCode: "TRIGGER_NOT_FOUND",
                                   errorMessage: "Trigger dummyID not found")),
                               error)
            }
        }
    }

    func testFailToDeleteTrigger() {
        self.executeAsynchronous { expectation in
            self.onboardedApi.deleteTrigger("dummyID") { triggerID, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertEqual("dummyID", triggerID)
                XCTAssertEqual(ThingIFError.errorResponse(
                                 required: ErrorResponse(
                                   404,
                                   errorCode: "TRIGGER_NOT_FOUND",
                                   errorMessage: "Trigger dummyID not found")),
                               error)
            }
        }
    }
}
