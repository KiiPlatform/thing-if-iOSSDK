//
//  VariousTests.swift
//  ThingIFSDK
//
//  Created on 2017/05/08.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

/*
 This test file contains tests which are difficult to classify in some reasons.

 We will create new test files if the number of tests having same
 characteristic in this files becomes enough to classify.
*/
class VariousTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    /*
     This test checks whether we can use ThingIFAPI which is not
     onboarded itself or not.
     */
    func testCheckNoOnboarding() {

        let api = ThingIFAPI(
          self.app!,
          owner: Owner(
            TypedID(
              .user,
              id: self.userInfo["userID"]! as! String),
            accessToken: self.userInfo["_accessToken"]! as! String),
          target: self.onboardedApi.target!)

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
            api.postNewCommand(
              CommandForm(temperatureAliasActions)) { command, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)

                // To check command is valid or not, We use CommandToCheck.
                XCTAssertEqual(
                  CommandToCheck(
                    true,
                    targetID: api.target!.typedID,
                    issuerID: api.owner.typedID,
                    commandState: .sending,
                    hasFiredByTriggerID: false,
                    hasCreated: false,
                    hasModified: false,
                    aliasActions: temperatureAliasActions
                  ),
                  CommandToCheck(command)
                )
            }
        }

    }
}
