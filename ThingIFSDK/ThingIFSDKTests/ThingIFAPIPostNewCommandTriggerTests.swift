//
//  ThingIFAPIPostNewCommandTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIPostNewCommandTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let predicate: Predicate & ToJsonObject
        let triggeredCommandForm: TriggeredCommandForm
        let options: TriggerOptions?

        init(
          _ predicate:
            Predicate & ToJsonObject = SchedulePredicate("00 * * * *"),
          triggeredCommandForm:
            TriggeredCommandForm = TriggeredCommandForm(
              [
                AliasAction(
                  "alias1",
                  actions: [
                    Action("turnPower", value: true),
                    Action("setBrightness", value: 90)
                  ]
                )
              ]),
          options: TriggerOptions? = nil)
        {
            self.predicate = predicate
            self.triggeredCommandForm = triggeredCommandForm
            self.options = options
        }
    }

    func testPostNewTrigger_success() throws {
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        // perform onboarding
        api.target = target

        let equalColor0 =
          EqualsClauseInTrigger("alias1", field: "color", intValue: 0)
        let equalPowerTrue =
          EqualsClauseInTrigger("alias1", field: "power", boolValue: true)
        let equalBrightness50 =
          EqualsClauseInTrigger("alias1", field: "brightness", intValue: 50)
        let lessThanOrEqualColor255 = RangeClauseInTrigger.lessThanOrEqualTo(
          "alias1",
          field: "color",
          limit: 255)
        let lessThanColor200 =
          RangeClauseInTrigger.lessThan("alias1", field: "color", limit: 200)
        let lessThanColor200_345 =
          RangeClauseInTrigger.lessThan(
            "alias1",
            field: "color",
            limit: 200.345)
        let greaterThanOrEqualColor1 =
          RangeClauseInTrigger.greaterThanOrEqualTo(
            "alias1",
            field: "color",
            limit: 1)
        let greaterThanColor1 = RangeClauseInTrigger.greaterThan(
          "alias1",
          field: "color",
          limit: 1)
        let greaterThanColor1_345 = RangeClauseInTrigger.greaterThan(
          "alias1",
          field: "color",
          limit: 1.345)
        let rangeInclude1ToInclude345 =
          RangeClauseInTrigger.range(
            "alias1",
            field: "color",
            lowerLimit: 1,
            lowerIncluded: true,
            upperLimit: 345,
            upperIncluded: true)
        let rangeInclude1_1ToInclude345_3 =
          RangeClauseInTrigger.range(
            "alias1",
            field: "color",
            lowerLimit: 1.1,
            lowerIncluded: true,
            upperLimit: 345.3,
            upperIncluded: true)
        let triggerMetadata = ["triggerMetadataKey" : "triggerMetadataValue"]
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action("turnPower", value: true),
              Action("setBrightness", value: 90)
            ]
          )
        ]
        let commandMetadata = ["commandMetadataKey" : "commandMetadataValue"]
        let targetID = target.typedID

        let testcases: [TestCase] = [
          // Schedule once
          TestCase(ScheduleOncePredicate(Date(timeIntervalSinceNow: 10))),
          // Schedule
          TestCase(SchedulePredicate("00 * * * *")),
          // state predicate
          TestCase(StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(equalPowerTrue),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(NotEqualsClauseInTrigger(equalPowerTrue)),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(lessThanOrEqualColor255),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(lessThanColor200),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(lessThanColor200_345),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(greaterThanOrEqualColor1),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(greaterThanColor1),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(greaterThanColor1_345),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(rangeInclude1ToInclude345),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(rangeInclude1_1ToInclude345_3),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(
                       AndClauseInTrigger(
                         equalColor0,
                         NotEqualsClauseInTrigger(equalPowerTrue))),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(
                       OrClauseInTrigger(
                         equalColor0,
                         NotEqualsClauseInTrigger(equalPowerTrue))),
                     triggersWhen: .conditionFalseToTrue)),
          // complex clauses
          TestCase(StatePredicate(
                     Condition(
                       AndClauseInTrigger(
                         equalBrightness50,
                         OrClauseInTrigger(
                           equalColor0,
                           NotEqualsClauseInTrigger(equalPowerTrue)))),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(StatePredicate(
                     Condition(
                       OrClauseInTrigger(
                         equalBrightness50,
                         AndClauseInTrigger(
                           equalColor0,
                           NotEqualsClauseInTrigger(equalPowerTrue)))),
                     triggersWhen: .conditionFalseToTrue)),
          // test triggersWhen
          TestCase(StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionChanged)),
          TestCase(StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionTrue)),
          // trigger options
          TestCase(options: TriggerOptions("trigger title")),
          TestCase(options: TriggerOptions(
                     triggerDescription: "trigger description")),
          TestCase(options: TriggerOptions(metadata: triggerMetadata)),
          TestCase(options: TriggerOptions(
                     "trigger title",
                     triggerDescription: "trigger description")),
          TestCase(options: TriggerOptions(
                     "trigger title",
                     metadata: triggerMetadata)),
          TestCase(options: TriggerOptions(
                     triggerDescription: "trigger description",
                     metadata: triggerMetadata)),
          TestCase(options: TriggerOptions(
                     "trigger title",
                     triggerDescription: "trigger description",
                     metadata: triggerMetadata)),
          // triggered command form.
          TestCase(triggeredCommandForm: TriggeredCommandForm(aliasActions)),
          TestCase(triggeredCommandForm:
                     TriggeredCommandForm(aliasActions, targetID: targetID)),
          TestCase(
            triggeredCommandForm:
              TriggeredCommandForm(aliasActions, title: "command title")),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     commandDescription: "command description")),
          TestCase(triggeredCommandForm:
                     TriggeredCommandForm(
                       aliasActions,
                       metadata: commandMetadata)),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     targetID: targetID,
                     title: "command title")),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     targetID: targetID,
                     commandDescription: "command description")),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     targetID: targetID,
                     metadata: commandMetadata)),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     targetID: targetID,
                     title: "command title",
                     commandDescription: "command description")),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     targetID: targetID,
                     title: "command title",
                     metadata: commandMetadata)),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     targetID: targetID,
                     title: "command title",
                     commandDescription: "command description",
                     metadata: commandMetadata)),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     title: "command title",
                     commandDescription: "command description")),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     title: "command title",
                     metadata: commandMetadata)),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     title: "command title",
                     commandDescription: "command description",
                     metadata: commandMetadata)),
          TestCase(triggeredCommandForm: TriggeredCommandForm(
                     aliasActions,
                     commandDescription: "command description",
                     metadata: commandMetadata))
        ]

        for (index, testcase) in testcases.enumerated() {
            try postNewTriggerSuccess(
              "testPostNewTrigger_success_\(index)",
              testcase: testcase,
              setting: setting)
        }

    }

    func postNewTriggerSuccess(
      _ tag: String,
      testcase: TestCase,
      setting:TestSetting) throws -> Void
    {
        let expectation = self.expectation(description: tag)

        let predicate = testcase.predicate
        let options = testcase.options
        let triggeredCommandForm = testcase.triggeredCommandForm

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: predicate,
          command: Command(
            "dummyCommandID",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: triggeredCommandForm.aliasActions,
            commandState: .sending,
            created: Date()
          )
        )

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
          (
            (
              try JSONSerialization.data(
                withJSONObject:["triggerID": expectedTriggerID],
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

                XCTAssertEqual(
                  setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers",
                  request.url?.absoluteString)

                //verify header
                XCTAssertEqual(
                  [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                  ],
                  request.allHTTPHeaderFields!)

                //verify body
                var commandJson = triggeredCommandForm.makeJsonObject()
                commandJson["issuer"] = setting.owner.typedID.toString()
                if commandJson["target"] == nil {
                    commandJson["target"] = setting.target.typedID.toString()
                }
                XCTAssertEqual(
                  ([
                    "predicate" : predicate.makeJsonObject(),
                    "command" : commandJson,
                    "triggersWhat" : TriggersWhat.command.rawValue
                  ] + ( options?.makeJsonObject() ?? [ : ])) as NSDictionary,
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
                withJSONObject: expectedTrigger.makeJsonObject(),
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
              nil
            ),
            { request in
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
          )
        ]

        setting.api.postNewTrigger(
          triggeredCommandForm,
          predicate: predicate,
          options: options) { trigger, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(expectedTrigger, trigger)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, tag)
        }
    }

    func testPostNewTrigger_http_404() throws {
        let expectation =
          self.expectation(description: "testPostNewTrigger_http_404")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        let expectedTriggerdCommandForm =
          TriggeredCommandForm(
            [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ]
          )
        let expectedPredicate = StatePredicate(
          Condition(
            EqualsClauseInTrigger("alias1", field: "color", intValue: 0)),
          triggersWhen:. conditionFalseToTrue
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")

            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers",
              request.url?.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            var commandJson = expectedTriggerdCommandForm.makeJsonObject()
            commandJson["issuer"] = setting.owner.typedID.toString()
            if commandJson["target"] == nil {
                commandJson["target"] = setting.target.typedID.toString()
            }
            XCTAssertEqual(
              [
                "predicate" : expectedPredicate.makeJsonObject(),
                "command" : commandJson,
                "triggersWhat" : TriggersWhat.command.rawValue
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        let errorCode = "TARGET_NOT_FOUND"
        let errorMessage = "Target \(target.typedID.toString()) not found"
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

        api.postNewTrigger(
          expectedTriggerdCommandForm,
          predicate: expectedPredicate) { trigger, error -> Void in
            XCTAssertNil(trigger)
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
            XCTAssertNil(error)
        }
    }

    func testPostNewTrigger_http_400() throws {
        let expectation =
          self.expectation(description: "testPostNewTrigger_http_400")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        let expectedTriggerdCommandForm =
          TriggeredCommandForm(
            [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ]
          )
        let expectedPredicate = StatePredicate(
          Condition(
            EqualsClauseInTrigger("alias1", field: "color", intValue: 0)),
          triggersWhen:. conditionFalseToTrue
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")

            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers",
              request.url?.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            var commandJson = expectedTriggerdCommandForm.makeJsonObject()
            commandJson["issuer"] = setting.owner.typedID.toString()
            if commandJson["target"] == nil {
                commandJson["target"] = setting.target.typedID.toString()
            }
            XCTAssertEqual(
              [
                "predicate" : expectedPredicate.makeJsonObject(),
                "command" : commandJson,
                "triggersWhat" : TriggersWhat.command.rawValue
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        let errorCode = "BAD_REQUEST"
        let errorMessage = "Passed Trigger is not valid"
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

        api.postNewTrigger(
          expectedTriggerdCommandForm,
          predicate: expectedPredicate) { trigger, error -> Void in
            XCTAssertNil(trigger)
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
            XCTAssertNil(error)
        }
    }

    func testPostNewTrigger_http_400_invalidTimestamp() throws {
        let expectation = self.expectation(
          description: "testPostNewTrigger_http_400_invalidTimestamp")

        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api.target = target

        let expectedTriggerdCommandForm =
          TriggeredCommandForm(
            [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ]
          )
        let expectedPredicate = StatePredicate(
          Condition(
            EqualsClauseInTrigger("alias1", field: "color", intValue: 0)),
          triggersWhen:. conditionFalseToTrue
        )

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "POST")

            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers",
              request.url?.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            var commandJson = expectedTriggerdCommandForm.makeJsonObject()
            commandJson["issuer"] = setting.owner.typedID.toString()
            if commandJson["target"] == nil {
                commandJson["target"] = setting.target.typedID.toString()
            }
            XCTAssertEqual(
              [
                "predicate" : expectedPredicate.makeJsonObject(),
                "command" : commandJson,
                "triggersWhat" : TriggersWhat.command.rawValue
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary
            )
        }

        // mock response
        let errorCode = "Time stamp not valid"
        let errorMessage = "Passed Trigger's timestamp is not valid"
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

        api.postNewTrigger(
          expectedTriggerdCommandForm,
          predicate: expectedPredicate) { trigger, error -> Void in
            XCTAssertNil(trigger)
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
            XCTAssertNil(error)
        }
    }

    func testPostTrigger_target_not_available_error() {
        let expectation = self.expectation(
          description: "testPostTrigger_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.postNewTrigger(
          TriggeredCommandForm(
            [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ]
          ),
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger("alias1", field: "color", intValue: 0)),
            triggersWhen:. conditionFalseToTrue)) { trigger, error -> Void in
            XCTAssertNil(trigger)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

}
