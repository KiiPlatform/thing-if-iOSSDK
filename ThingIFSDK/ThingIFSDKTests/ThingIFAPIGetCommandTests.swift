//
//  ThingIFAPIGetCommandTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/16.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIGetCommandTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    override class func defaultTestSuite() -> XCTestSuite { //TODO: This is temporary to mark crashed test, remove this later

        let testSuite = XCTestSuite(name: NSStringFromClass(self))

        return testSuite
    }


    func testSuccess() throws {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        // perform onboarding
        api.target = setting.target

        let targetID =
          try TypedID(
            "\(setting.target.typedID.type):\(setting.target.typedID.id)")
        let issuerID =
          try TypedID(
            "\(setting.owner.typedID.type):\(setting.owner.typedID.id)")
        let turnPower = Action("turnPower", value: true)
        let setBrightness = Action("setBrightness", value: 100)
        let powerResult = ActionResult(true, actionName: "turnPower")
        let brightnessResults = ActionResult(true, actionName: "setBrightness")

        let testCases = [
          // check all CommandState.
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            commandState: .sending,
            created: Date()),
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            commandState: .sendFailed,
            created: Date()),
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            commandState: .incomplete,
            created: Date()),
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            commandState: .done,
            created: Date()),
          // check 2 actions
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions:
              [AliasAction("alias1", actions: turnPower, setBrightness)],
            commandState: .sending,
            created: Date()),
          // check 2 alias actions
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions:
              [
                AliasAction("alias1", actions: turnPower, setBrightness),
                AliasAction("alias2", actions: setBrightness, turnPower)
              ],
            commandState: .sending,
            created: Date()),
          // check all optionals
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            aliasActionResults:
              [AliasActionResult("alias1", results: powerResult)],
            commandState: .sending,
            firedByTriggerID: "firedByTriggerID",
            created: Date(),
            modified: Date(),
            title: "title",
            commandDescription: "commandDescription",
            metadata: ["key" : "value"]),
          // check all optionals with 2 alias action results
          Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: targetID,
            issuerID: issuerID,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            aliasActionResults: [
              AliasActionResult(
                "alias1",
                results: powerResult, brightnessResults),
              AliasActionResult(
                "alias2",
                results: brightnessResults, powerResult)
            ],
            commandState: .sending,
            firedByTriggerID: "firedByTriggerID",
            created: Date(),
            modified: Date(),
            title: "title",
            commandDescription: "commandDescription",
            metadata: ["key" : "value"])
        ]
        for (index, testCase) in testCases.enumerated() {
            try getCommandSuccess(
              testCase,
              setting: setting,
              tag: "testGetCommandSuccess_\(index)")
        }
    }

    func getCommandSuccess(
      _ testCase: Command,
      setting: TestSetting,
      tag: String) throws
    {
        let expectation = self.expectation(description: tag)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(testCase.targetID.toString())/commands/\(testCase.commandID!)",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)

        }

        sharedMockSession.mockResponse =
          (
            try JSONSerialization.data(
              withJSONObject: testCase.makeJsonObject(),
              options: .prettyPrinted),
            HTTPURLResponse(
              url: URL(string:setting.app.baseURL)!,
              statusCode: 200,
              httpVersion: nil,
              headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.getCommand(testCase.commandID!) { command, error in
            XCTAssertNil(error)
            XCTAssertEqual(testCase, command)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetCommand_404_error() throws {
        let expectation = self.expectation(description: "getCommand404Error")
        let setting = TestSetting()
        let api = setting.api

        let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // perform onboarding
        api.target = setting.target

        sharedMockSession.requestVerifier = makeRequestVerifier() {request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
              "\(api.baseURL)/thing-if/apps/\(api.appID)/targets/\(setting.target.typedID.type):\(setting.target.typedID.id)/commands/\(commandID)",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
        }

        let errorCode = "TARGET_NOT_FOUND"
        let message = "Target \(setting.target.typedID.toString()) not found"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(withJSONObject: ["errorCode" : errorCode,
                                                      "message" : message],
                                     options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self
        api.getCommand(commandID) { command, error -> Void in
            XCTAssertNil(command)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  404,
                  errorCode: errorCode,
                  errorMessage: message)),
              error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetCommand_trigger_not_available_error() throws {
        let expectation = self.expectation(
          description: "testGetCommand_trigger_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.getCommand(commandID) { command, error -> Void in
            XCTAssertNil(command)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
