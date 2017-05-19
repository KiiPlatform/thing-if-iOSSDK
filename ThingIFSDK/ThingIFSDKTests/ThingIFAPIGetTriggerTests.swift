//
//  ThingIFAPIGetTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class ThingIFAPIGetTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetTrigger_success_predicates() throws {
        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        let equalColor0 =
          EqualsClauseInTrigger("alias1", field: "color", intValue: 0)
        let equalPowerTrue =
          EqualsClauseInTrigger("alias1", field: "power", boolValue: true)
        let equalBrightness50 =
          EqualsClauseInTrigger("alias1", field: "brightness", intValue: 50)
        let notEqualPowerTrue =
          NotEqualsClauseInTrigger(equalPowerTrue)
        let lessThanOrEqualColor255 = RangeClauseInTrigger.lessThanOrEqualTo(
          "alias1",
          field: "color",
          limit: 255)
        let lessThanColor200 =
          RangeClauseInTrigger.lessThan("alias1", field: "color", limit: 200)
        let greaterThanOrEqualColor1 =
          RangeClauseInTrigger.greaterThanOrEqualTo(
            "alias1",
            field: "color",
            limit: 1)
        let greaterThanColor1 = RangeClauseInTrigger.greaterThan(
          "alias1",
          field: "color",
          limit: 1)

        let clauses: [TriggerClause & ToJsonObject] =
          [
            equalColor0,
            equalPowerTrue,
            notEqualPowerTrue,
            lessThanOrEqualColor255,
            lessThanColor200,
            greaterThanOrEqualColor1,
            greaterThanColor1,
            AndClauseInTrigger(equalColor0, notEqualPowerTrue),
            OrClauseInTrigger(equalColor0, notEqualPowerTrue),
            AndClauseInTrigger(
              equalBrightness50,
              OrClauseInTrigger(equalColor0, notEqualPowerTrue)
            ),
            OrClauseInTrigger(
              equalBrightness50,
              AndClauseInTrigger(equalColor0, notEqualPowerTrue)
            )
          ]

        for (index, clause) in clauses.enumerated() {
            try getTriggerSuccess(
              "testGetTrigger_success_predicates\(index)",
              clause: clause,
              triggersWhen: .conditionFalseToTrue,
              setting: setting)
        }
    }

    func testGetTrigger_success_triggersWhens() throws {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        api.target = setting.target

        let triggersWhens: [TriggersWhen] = [
          .conditionTrue,
          .conditionFalseToTrue,
          .conditionChanged
        ]
        for (index, triggersWhen) in triggersWhens.enumerated() {
            try getTriggerSuccess(
              "testGetTrigger_success_triggersWhens\(index)",
              clause: EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0),
              triggersWhen: triggersWhen,
              setting: setting)
        }
    }

    func getTriggerSuccess(
      _ tag: String,
      clause: TriggerClause & ToJsonObject,
      triggersWhen: TriggersWhen,
      setting:TestSetting) throws -> Void
    {

        let expectation = self.expectation(description: tag)

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(clause),
            triggersWhen: triggersWhen
          ),
          command: Command(
            "dummyCommandID",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions:
              [
                AliasAction(
                  "alias1",
                  actions: [
                    Action("turnPower", value: true),
                    Action("setBrightness", value: 90)
                  ]
                )
              ],
            commandState: .sending,
            created: Date()
          )
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier () { request in
            XCTAssertEqual(request.httpMethod, "GET", tag)
            //verify header
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)",
              request.url?.absoluteString)

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
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: expectedTrigger.makeJsonObject(),
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(
              string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.getTrigger(expectedTriggerID) { trigger, error -> Void in
            XCTAssertNil(error, tag)
            XCTAssertEqual(expectedTrigger, trigger, tag)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, tag)
        }
    }

    func testGetServerCodeTrigger_success() throws {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        let expectation = self.expectation(
          description: "testGetServerCodeTrigger_success")

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)
            ),
            triggersWhen: .conditionFalseToTrue
          ),
          serverCode: ServerCode(
            "my_function",
            executorAccessToken: "abcdefgHIJKLMN1234567",
            targetAppID: "app000001",
            parameters: [
              "arg1" : "abcd",
              "arg2" : 1234,
              "arg3" : 0.12345,
              "arg4" : false
            ]
          )
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)",
              request.url?.absoluteString)
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
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: expectedTrigger.makeJsonObject(),
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.target = setting.target
        api.getTrigger(expectedTriggerID) { trigger, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(trigger, expectedTrigger)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testSchedulePredicate() throws {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        let expectation = self.expectation(
          description: "testSchedulePredicate")

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: SchedulePredicate("00 * * * *"),
          serverCode: ServerCode(
            "my_function",
            executorAccessToken: "abcdefgHIJKLMN1234567",
            targetAppID: "app000001",
            parameters: [
              "arg1" : "abcd",
              "arg2" : 1234,
              "arg3" : 0.12345,
              "arg4" : false
            ]
          )
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)",
              request.url?.absoluteString)
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
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: expectedTrigger.makeJsonObject(),
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.target = setting.target
        api.getTrigger(expectedTriggerID) { trigger, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(trigger, expectedTrigger)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testScheduleOncePredicate() throws {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        let expectation = self.expectation(
          description: "testScheduleOncePredicate")

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: ScheduleOncePredicate(Date()),
          serverCode: ServerCode(
            "my_function",
            executorAccessToken: "abcdefgHIJKLMN1234567",
            targetAppID: "app000001",
            parameters: [
              "arg1" : "abcd",
              "arg2" : 1234,
              "arg3" : 0.12345,
              "arg4" : false
            ]
          )
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)",
              request.url?.absoluteString)
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
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: expectedTrigger.makeJsonObject(),
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.target = setting.target
        api.getTrigger(expectedTriggerID) { trigger, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(trigger, expectedTrigger)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTrigger_404_error() throws {
        let expectation = self.expectation(description: "testGetTrigger_404_error")
        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)",
              request.url?.absoluteString)

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
        let errorMessage =
          "Target \(setting.target.typedID.toString()) not found"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["errorCode" : errorCode, "message" : errorMessage],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.getTrigger(triggerID) { trigger, error -> Void in
            XCTAssertNil(trigger)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  404,
                  errorCode: errorCode,
                  errorMessage: errorMessage)
              ),
              error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTrigger_Target_not_available_error() throws {
        let expectation = self.expectation(
          description: "testGetTrigger_Target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.getTrigger(triggerID) { trigger, error -> Void in
            XCTAssertNil(trigger)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
