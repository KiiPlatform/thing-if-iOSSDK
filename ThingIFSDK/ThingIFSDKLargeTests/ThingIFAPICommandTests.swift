//
//  ThingIFAPICommandTests.swift
//  ThingIFSDK
//
//  Created on 2017/04/05.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPICommandTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {

        // List commands. The list is empty.
        self.executeAsynchronous { expectation in
            self.onboardedApi.listCommands() { commands, paginationKey, error in

                XCTAssertNil(paginationKey)
                XCTAssertNil(error)
                XCTAssertNotNil(commands)
                if let commands = commands {
                    XCTAssertEqual([], commands)
                }
                expectation.fulfill()
            }
        }

        var createdCommands: [Command] = []
        // Post a new command with only alias actions.
        let temperatureAliasActions = [
          AliasAction(
            ALIAS1,
            actions: [
              Action("turnPower", value: true),
              Action("setPresetTemperature", value: 25)
            ]
          )
        ]
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewCommand(
              CommandForm(temperatureAliasActions)) { command, error in
                XCTAssertNil(error)
                XCTAssertEqual(
                  CommandToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    issuerID: self.onboardedApi.owner.typedID,
                    commandState: .sending,
                    hasFiredByTriggerID: false,
                    hasCreated: false,
                    hasModified: false,
                    aliasActions: temperatureAliasActions
                  ),
                  CommandToCheck(command)
                )
                if let command = command {
                    createdCommands.append(command)
                }
                expectation.fulfill()
            }
        }

        // Post a new command with options.
        let humidityAliasActions = [
          AliasAction(ALIAS2, actions: [Action("setPresetHumidity", value: 45)])
        ]
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewCommand(
              CommandForm(
                humidityAliasActions,
                title: "dummy titile",
                commandDescription: "dummy description",
                metadata: ["k" : "v"])) { command, error in

                XCTAssertNil(error)
                XCTAssertEqual(
                  CommandToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    issuerID: self.onboardedApi.owner.typedID,
                    commandState: .sending,
                    hasFiredByTriggerID: false,
                    hasCreated: false,
                    hasModified: false,
                    aliasActions: humidityAliasActions,
                    title: "dummy titile",
                    commandDescription: "dummy description",
                    metadata: ["k" : "v"]
                  ),
                  CommandToCheck(command)
                )
                if let command = command {
                    createdCommands.append(command)
                }
                expectation.fulfill()
            }
        }

        // Get commands.
        for createdCommand in createdCommands {
            self.executeAsynchronous { expectation in
                self.onboardedApi.getCommand(
                  createdCommand.commandID!) { command, error in

                    XCTAssertNil(error)
                    XCTAssertEqual(createdCommand, command)
                    expectation.fulfill()
                }
            }
        }

        // Post another command
        let anotherTemperatureAliasActions = [
          AliasAction(
            ALIAS1,
            actions: [
              Action("turnPower", value: false),
              Action("setPresetTemperature", value: 30)
            ]
          )
        ]
        self.executeAsynchronous { expectation in
            self.onboardedApi.postNewCommand(
              CommandForm(anotherTemperatureAliasActions)) { command, error in
                XCTAssertNil(error)
                XCTAssertEqual(
                  CommandToCheck(
                    true,
                    targetID: self.onboardedApi.target!.typedID,
                    issuerID: self.onboardedApi.owner.typedID,
                    commandState: .sending,
                    hasFiredByTriggerID: false,
                    hasCreated: false,
                    hasModified: false,
                    aliasActions: anotherTemperatureAliasActions
                  ),
                  CommandToCheck(command)
                )
                if let command = command {
                    createdCommands.append(command)
                }
                expectation.fulfill()
            }
        }

        // List all commands.
        self.executeAsynchronous { expectation in
            self.onboardedApi.listCommands() { commands, paginationKey, error in

                XCTAssertNil(paginationKey)
                XCTAssertNil(error)
                XCTAssertNotNil(commands)
                if let commands = commands {
                    XCTAssertEqual(Set(createdCommands), Set(commands))
                }
                expectation.fulfill()
            }
        }
    }
}
