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

        // Get empty command list.
        self.executeAsynchronous { expectation in
            self.onboardedApi.listCommands() { commands, paginationKey, error in

                XCTAssertNil(paginationKey)
                XCTAssertNil(error)
                XCTAssertNotNil(commands)
                XCTAssertEqual([], commands!)
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
                createdCommands.append(command!)
                expectation.fulfill()
            }
        }
    }
}
