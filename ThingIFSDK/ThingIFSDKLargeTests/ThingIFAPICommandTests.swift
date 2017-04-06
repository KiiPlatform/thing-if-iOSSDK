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
                    // commands must be empty.
                    XCTAssertEqual([], commands)
                }
                expectation.fulfill()
            }
        }

        var createdCommands: Set<Command> = []
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

                // To check command is valid or not, We use CommandToCheck.
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
                    // Command must be inserted to set as new Item..
                    XCTAssertTrue(createdCommands.insert(command).inserted)
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

                // To check command is valid or not, We use CommandToCheck.
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
                    // Command must be inserted to set as new Item..
                    XCTAssertTrue(createdCommands.insert(command).inserted)
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

                // To check command is valid or not, We use CommandToCheck.
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
                    // Command must be inserted to set as new Item..
                    XCTAssertTrue(createdCommands.insert(command).inserted)
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
                    XCTAssertEqual(createdCommands, Set(commands))
                }
                expectation.fulfill()
            }
        }

        // List a command
        var gotPaginationKey: String?
        var gotComand: Command?
        self.executeAsynchronous { expectation in
            self.onboardedApi.listCommands(1) {
                commands, paginationKey, error in

                { () in
                    XCTAssertNotNil(paginationKey)
                    XCTAssertNil(error)
                    XCTAssertNotNil(commands)
                    guard let commands = commands else {
                        return
                    }
                    XCTAssertEqual(1, commands.count)
                    XCTAssertTrue(createdCommands.contains(commands[0]))

                    gotPaginationKey = paginationKey
                    gotComand = commands[0]
                }()
                expectation.fulfill()
            }
        }

        // list rest commands
        guard let paginationKey = gotPaginationKey,
              let commandToRemove = gotComand else {
            return
        }

        XCTAssertNotNil(createdCommands.remove(commandToRemove))
        self.executeAsynchronous { expectation in
            self.onboardedApi.listCommands(
              3, paginationKey: paginationKey) {

                commands, paginationKey, error in

                { () in
                    XCTAssertNil(paginationKey)
                    XCTAssertNil(error)
                    XCTAssertNotNil(commands)
                    guard let commands = commands else {
                        return
                    }
                    XCTAssertEqual(2, commands.count)
                    XCTAssertEqual(createdCommands, Set(commands))
                }()
                expectation.fulfill()
            }
        }
    }

    func testFailToGetCommand() {
        self.executeAsynchronous { expectation in
            self.onboardedApi.getCommand("dummyID") { command, error in

                XCTAssertNil(command)
                XCTAssertEqual(
                  ThingIFError.errorResponse(
                    required: ErrorResponse(
                      404,
                      errorCode: "COMMAND_NOT_FOUND",
                      errorMessage: "Command dummyID not found")
                  ),
                  error
                )
                expectation.fulfill()
            }
        }
    }
}
