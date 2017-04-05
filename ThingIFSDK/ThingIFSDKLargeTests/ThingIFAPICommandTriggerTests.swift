//
//  ThingIFAPICommandTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/04/05.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPICommandTriggerTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {

        // List empty triggers
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers { triggers, paginationKey, error in
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual([], triggers)
                }
                expectation.fulfill()
            }
        }

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
                    XCTAssertTrue(createdTriggers.insert(trigger).inserted)
                }
                expectation.fulfill()
            }
        }

        // post new comand trigger with SchedulePredicate
        let schedulePredicate = SchedulePredicate("1 * * * *")
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewTrigger(
              TriggeredCommandForm(temperatureAliasActions),
              predicate: schedulePredicate) { trigger, error in

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
                    XCTAssertTrue(createdTriggers.insert(trigger).inserted)
                }
                expectation.fulfill()
            }
        }

        // post new comand trigger with ScheduleOncePredicate
        let scheduleOncePredicate =
          ScheduleOncePredicate(Date(timeIntervalSinceNow: 3600))
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewTrigger(
              TriggeredCommandForm(temperatureAliasActions),
              predicate: scheduleOncePredicate) { trigger, error in

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
                    XCTAssertTrue(createdTriggers.insert(trigger).inserted)
                }
                expectation.fulfill()
            }
        }

        // List all triggers
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers { triggers, paginationKey, error in
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual(createdTriggers, Set(triggers))
                }
                expectation.fulfill()
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
                expectation.fulfill()
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
                expectation.fulfill()
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
                expectation.fulfill()
            }
        }

        // List all modified triggers
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers { triggers, paginationKey, error in
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual(modifiedTriggers, Set(triggers))
                }
                expectation.fulfill()
            }
        }

        // Get triggers
        for modifiedTrigger in modifiedTriggers {
            self.executeAsynchronous { expectation in
                self.onboardedApi.getTrigger(
                  modifiedTrigger.triggerID) { trigger, error in
                    XCTAssertNil(error)
                    XCTAssertEqual(modifiedTrigger, trigger)
                    expectation.fulfill()
                }
            }
        }

        // List a trigger.
        var gotPaginationKey: String?
        var gotTrigger: Trigger?
        self.executeAsynchronous { expectation in
            self.onboardedApi.listTriggers(1) {
                triggers, paginationKey, error in

                XCTAssertNil(error)
                XCTAssertNotNil(paginationKey)
                gotPaginationKey = paginationKey
                XCTAssertNotNil(triggers)

                ({ () in
                     guard let triggers = triggers else {
                         return
                     }
                     XCTAssertEqual(1, triggers.count)
                     XCTAssertTrue(modifiedTriggers.contains(triggers[0]))
                     gotTrigger = triggers[0]
                 })()

                expectation.fulfill()
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
                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertNotNil(triggers)
                if let triggers = triggers {
                    XCTAssertEqual(modifiedTriggers, Set(triggers))
                }
                expectation.fulfill()
            }
        }

        // delete all triggers
        for triggerID in triggerIDs {
            self.executeAsynchronous { expectation in
                self.onboardedApi.deleteTrigger(triggerID) { deleted, error in
                    XCTAssertNil(error)
                    XCTAssertEqual(triggerID, deleted)
                    expectation.fulfill()
                }
            }
        }
    }

}
