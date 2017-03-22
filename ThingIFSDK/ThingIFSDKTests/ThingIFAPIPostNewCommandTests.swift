//
//  ThingIFAPIPostNewCommandTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/19.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

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
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions: turnPower)],
            issuerID: owner.typedID),
          TestCase(
            target: target,
            aliasActions: [AliasAction("alias1", actions:setBrightness)],
            issuerID: owner.typedID),
          TestCase(
            target: target,
            aliasActions:
              [AliasAction("alias1", actions: turnPower, setBrightness)],
            issuerID: owner.typedID),
          TestCase(
            target: target,
            aliasActions:
              [
                AliasAction("alias1", actions: turnPower),
                AliasAction("alias2", actions: turnPower, setBrightness),
              ],
            issuerID: owner.typedID)
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
          created: Date()
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
                XCTAssertEqual(
                  [
                    "issuer": testCase.issuerID.toString(),
                    "actions": testCase.aliasActions.map { $0.makeJsonObject() }
                  ],
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
          CommandForm(testCase.aliasActions))  { command, error -> Void in
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
          [AliasAction("wrongAlias", actions: Action("turnPower", value: true))]

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
          "There are validation errors: lampAlias.setBrightness - Invalid value."
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
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

}
