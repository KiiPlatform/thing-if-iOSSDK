//
//  ThingIFAPIPostNewCommandTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/19.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

class ThingIFAPIPostNewCommandTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let target: Target
        let aliasActions: [AliasAction]
        let issuerID: TypedID
        let title: String?
        let commandDescription: String?
        let metadata: [String : Any]?

        init(
          target: Target,
          aliasActions: [AliasAction],
          issuerID: TypedID,
          title: String? = nil,
          commandDescription: String? = nil,
          metadata: [String : Any]? = nil)
        {
            self.target = target
            self.aliasActions = aliasActions
            self.issuerID = issuerID
            self.title = title
            self.commandDescription = commandDescription
            self.metadata = metadata
        }
    }

    func testPostCommandSuccess() throws {
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let turnPower = Action("turnPower", value: true)
        let setBrightness = Action("setBrightness", value: 100)


        // perform onboarding
        api.target = target

        let testCases = [
          // Simple case.
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID),
          // 2 action case
          TestCase(
            target: target,
            aliasActions:
              [AliasAction("alias1", actions: turnPower, setBrightness)],
            issuerID: owner.typedID),
          // 2 alias action case
          TestCase(
            target: target,
            aliasActions:
              [
                AliasAction("alias1", actions: turnPower),
                AliasAction("alias2", actions: turnPower, setBrightness),
              ],
            issuerID: owner.typedID),
          // with title case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            title: "title"),
          // with command description case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            commandDescription: "commandDescription"),
          // with metadata case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            metadata: ["key" : "value"]),
          // with title and command description case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            title: "title",
            commandDescription: "commandDescription"),
          // with title and matadata case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            title: "title",
            metadata: ["key" : "value"]),
          // with command description and matadata case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            commandDescription: "commandDescription",
            metadata: ["key" : "value"]),
          // with all optional case
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID,
            title: "title",
            commandDescription: "commandDescription",
            metadata: ["key" : "value"])
        ]

        for (index, testCase) in testCases.enumerated() {
            try postCommandSuccess(
              "testPostCommandSuccess_\(index)",
              testCase: testCase,
              setting: setting)
        }
    }

    func postCommandSuccess(
      _ tag: String,
      testCase: TestCase,
      setting:TestSetting) throws -> Void
    {
        let expectation = self.expectation(description: tag)
        let commandID = "c6f1b8d0-46ea-11e5-a5eb-06d9d1527620"
        let expectedCommand = Command(
          commandID,
          targetID: testCase.target.typedID,
          issuerID: testCase.issuerID,
          aliasActions: testCase.aliasActions,
          commandState: .sending,
          created: Date(),
          title: testCase.title,
          commandDescription: testCase.commandDescription,
          metadata: testCase.metadata
        )

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
          (
            (
              try JSONSerialization.data(
                withJSONObject:["commandID": commandID],
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil),
              nil
            ),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "POST")

                // verify path
                XCTAssertEqual(
                  "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(testCase.target.typedID.toString())/commands",
                  request.url!.absoluteString)

                //verify header
                XCTAssertEqual(
                  [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type":
                      "application/vnd.kii.CommandCreationRequest+json"
                  ],
                  request.allHTTPHeaderFields!)
                //verify body
                var body: [String : Any] = [
                    "issuer" : testCase.issuerID.toString(),
                    "actions": testCase.aliasActions.map { $0.makeJsonObject() }
                ]
                body["title"] = testCase.title
                body["description"] = testCase.commandDescription
                body["metadata"] = testCase.metadata

                XCTAssertEqual(
                  body as NSDictionary,
                  try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
                )
            }
          ),
          (
            (
              try JSONSerialization.data(
                withJSONObject: expectedCommand.makeJsonObject(),
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
              nil
            ),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "GET")

                // verify path
                XCTAssertEqual(
                  "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(testCase.target.typedID.toString())/commands/\(commandID)",
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
          )
        ]

        setting.api.postNewCommand(
          CommandForm(
            testCase.aliasActions,
            title: testCase.title,
            commandDescription: testCase.commandDescription,
            metadata: testCase.metadata))  { command, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(expectedCommand, command)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout.")
        }
    }

    func testPostNewCommand_400_error() throws {
        let expectation =
          self.expectation(description: "testPostNewCommand_400_error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        let aliasActions =
          [AliasAction("alias1", actions: Action("turnPower", value: true))]

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(target.typedID.toString())/commands",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type":
                  "application/vnd.kii.CommandCreationRequest+json"
              ],
              request.allHTTPHeaderFields!)
            //verify body
            XCTAssertEqual(
              [
                "issuer": setting.owner.typedID.toString(),
                "actions": aliasActions.map { $0.makeJsonObject() }
              ],
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        let errorCode = "COMMAND_TRAIT_VALIDATION"
        let errorMessage =
          "There are validation errors: alias1.turnPower - Invalid value."
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["errorCode" : errorCode, "message" : errorMessage],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.postNewCommand(CommandForm(aliasActions)) {
            command, error -> Void in
            XCTAssertNil(command)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  400,
                  errorCode: errorCode,
                  errorMessage: errorMessage)),
              error)

            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout.")
        }
    }

    func testPostNewCommand_target_not_available_error() {

        let expectation = self.expectation(
          description: "testPostNewCommand_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api
        let aliasActions =
          [AliasAction("alias1", actions: Action("turnPower", value: true))]

        api.postNewCommand(
          CommandForm(aliasActions)) { command, error -> Void in
            XCTAssertNil(command)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout.")
        }
    }
}
