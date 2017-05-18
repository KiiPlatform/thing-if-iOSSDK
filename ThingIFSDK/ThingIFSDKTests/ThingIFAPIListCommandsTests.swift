//
//  ThingIFAPIListCommandsTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/22.
//  Copyright 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIListCommandsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let target: Target
        let input: (paginationKey: String?, bestEffortLimit: Int?)
        let output: (commands: [Command], nextPaginationKey: String?)
    }

    func testListCommandsSuccess() throws {
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner

        let commandIDPrifex = "0267251d9d60-1858-5e11-3dc3-00f3f0b"
        let turnPower = Action("turnPower", value: true)
        let setBrightness = Action("setBrightness", value: 100)

        // perform onboarding
        api.target = target

        let testcases = [
          // Empty result.
          TestCase(
            target: target,
            input: (nil, nil),
            output: ([], nil)),
          // Only one alias action.
          TestCase(
            target: target,
            input: (nil, nil),
            output: (
              [
                Command(
                  "\(commandIDPrifex)1",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias1", actions: turnPower)],
                  commandState: .sending,
                  created: Date())
              ],
              nil)
          ),
          // Two actions.
          TestCase(
            target: target,
            input: (nil, nil),
            output: (
              [
                Command(
                  "\(commandIDPrifex)2",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions:
                    [AliasAction("alias1", actions: turnPower, setBrightness)],
                  commandState: .sending,
                  created: Date())
              ],
              nil)
          ),
          // Two alias actions.
          TestCase(
            target: target,
            input: (nil, nil),
            output: (
              [
                Command(
                  "\(commandIDPrifex)2",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions:
                    [
                      AliasAction("alias1", actions: turnPower),
                      AliasAction("alias2", actions: setBrightness),
                    ],
                  commandState: .sending,
                  created: Date())
              ],
              nil)
          ),
          // With paginationKey
          TestCase(
            target: target,
            input: ("200/2", nil),
            output: (
              [
                Command(
                  "\(commandIDPrifex)1",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias1", actions: turnPower)],
                  commandState: .sending,
                  created: Date())
              ],
              nil)
          ),
          // With bestEffortLimit
          TestCase(
            target: target,
            input: (nil, 2),
            output: (
              [
                Command(
                  "\(commandIDPrifex)1",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias1", actions: turnPower)],
                  commandState: .sending,
                  created: Date())
              ],
              nil)
          ),
          // With nextPaginationKey
          TestCase(
            target: target,
            input: (nil, nil),
            output: (
              [
                Command(
                  "\(commandIDPrifex)1",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias1", actions: turnPower)],
                  commandState: .sending,
                  created: Date())
              ],
              "100")
          ),
          // With paginationKey, bestEffortLimit and nextPaginationKey
          TestCase(
            target: target,
            input: ("200/2", 2),
            output: (
              [
                Command(
                  "\(commandIDPrifex)1",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias1", actions: turnPower)],
                  commandState: .sending,
                  created: Date())
              ],
              "nextPaginationKey")
          ),
          // Two commands.
          TestCase(
            target: target,
            input: (nil, nil),
            output: (
              [
                Command(
                  "\(commandIDPrifex)1",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias1", actions: turnPower)],
                  commandState: .sending,
                  created: Date()),
                Command(
                  "\(commandIDPrifex)2",
                  targetID: target.typedID,
                  issuerID: owner.typedID,
                  aliasActions: [AliasAction("alias2", actions: setBrightness)],
                  commandState: .sending,
                  created: Date())
              ],
              nil)
          )
        ]

        for (index, testcase) in testcases.enumerated() {
            try listCommandsSuccess(
              "testListCommandsSuccess_\(index)",
              testcase: testcase)
        }
    }

    func listCommandsSuccess(_ tag: String, testcase: TestCase) throws {
        let expectation = self.expectation(description: tag)

        let setting = TestSetting()
        let api = setting.api

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET", tag)

            // verify path
            var path = "\(setting.app.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/commands"
            if let paginationKey = testcase.input.paginationKey,
               let bestEffortLimit = testcase.input.bestEffortLimit {
                path += ("?paginationKey=\(paginationKey)" +
                           "&bestEffortLimit=\(bestEffortLimit)")
            } else if let paginationKey = testcase.input.paginationKey {
                path += "?paginationKey=\(paginationKey)"
            } else if let bestEffortLimit = testcase.input.bestEffortLimit {
                path += "?bestEffortLimit=\(bestEffortLimit)"
            }
            XCTAssertEqual(path, request.url!.absoluteString, tag)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!,
              tag)
        }
        // mock response
        var responseBody: [String : Any] =
          ["commands" : testcase.output.commands.map { $0.makeJsonObject() }]
        responseBody["nextPaginationKey"] = testcase.output.nextPaginationKey

        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: responseBody,
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          error: nil)
        iotSession = MockSession.self

        api.target = setting.target
        api.listCommands(
          testcase.input.bestEffortLimit,
          paginationKey: testcase.input.paginationKey) {
            commands, nextPaginationKey, error -> Void in

            XCTAssertNil(error, tag)
            XCTAssertEqual(
              testcase.output.nextPaginationKey,
              nextPaginationKey,
              tag)
            XCTAssertEqual(testcase.output.commands, commands!, tag)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, tag + "execution timeout.")
        }
    }

    func testListCommand_404_error() throws {
        let expectation = self.expectation(description: "getCommand404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            XCTAssertEqual(
              "\(api.baseURL)/thing-if/apps/\(api.appID)/targets/\(setting.target.typedID.type):\(setting.target.typedID.id)/commands",
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
        // mock response
        let errorCode = "TARGET_NOT_FOUND"
        let errorMessage = "Target \(target.typedID.toString()) not found"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              [
                "errorCode" : errorCode,
                "message" : errorMessage
              ],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)

        iotSession = MockSession.self
        api.listCommands(nil, paginationKey: nil) {
            commands, nextPaginationKey, error -> Void in
            XCTAssertNil(commands)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  404,
                  errorCode: errorCode,
                  errorMessage: errorMessage)),
              error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout.")
        }
    }

    func testListCommand_target_not_available_error() {
        let expectation = self.expectation(
          description: "testListCommand_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.listCommands(nil, paginationKey: nil) {
            commands, nextPaginationKey, error -> Void in

            XCTAssertNil(commands)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, "execution timeout.")
        }
    }
}
