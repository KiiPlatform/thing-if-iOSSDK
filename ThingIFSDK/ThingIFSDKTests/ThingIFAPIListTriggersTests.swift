//
//  ThingIFAPIListTriggersTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/24.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

class ThingIFAPIListTriggersTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testListTriggers_success_predicates() throws {
        let expectation =
          self.expectation(description: "testListTriggers_success_predicates")

        let setting = TestSetting()
        let api = setting.api
        let triggerIDPrifex = "0267251d9d60-1858-5e11-3dc3-00f3f0b"

        // perform onboarding
        api.target = setting.target

        let equalColor0 =
          EqualsClauseInTrigger("alias1", field: "color", intValue: 0)
        let equalPowerTrue =
          EqualsClauseInTrigger("alias1", field: "power", boolValue: true)
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
        let lessThanColor3_1415927 = RangeClauseInTrigger.lessThan(
          "alias1",
          field: "color",
          limit: 3.1415927)
        let lessThanColor1_345 = RangeClauseInTrigger.lessThan(
          "alias1",
          field: "color",
          limit: 1.345)
        let rangeColor2Included345NotIncluded = RangeClauseInTrigger.range(
          "alias1",
          field: "color",
          lowerLimit: 2,
          lowerIncluded: true,
          upperLimit: 345,
          upperIncluded: false)
        let rangeColor2_1Included345_3Included = RangeClauseInTrigger.range(
          "alias1",
          field: "color",
          lowerLimit: 2.1,
          lowerIncluded: true,
          upperLimit: 345.3,
          upperIncluded: true)

        let command = Command(
          "429251a0-46f7-11e5-a5eb-06d9d1527620",
          targetID: setting.target.typedID,
          issuerID: setting.owner.typedID,
          aliasActions: [
            AliasAction(
              "alias1",
              actions: [
                Action("turnPower", value: true),
                Action("setBrightness", value: 90)
              ]
            )
          ],
          commandState: .sending,
          created: Date())

        let expectedTriggers: [Trigger] = [
          Trigger("\(triggerIDPrifex)1",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(equalColor0),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)2",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(equalPowerTrue),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)3",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(NotEqualsClauseInTrigger(equalPowerTrue)),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)4",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(lessThanOrEqualColor255),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)5",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(lessThanColor200),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)6",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(greaterThanOrEqualColor1),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)7",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(greaterThanColor1),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)8",
                  targetID: setting.target.typedID,
                  enabled: false,
                  predicate: StatePredicate(
                    Condition(
                      AndClauseInTrigger(
                        equalColor0,
                        NotEqualsClauseInTrigger(equalPowerTrue))),
                    triggersWhen: .conditionChanged),
                  command: command),
          Trigger("\(triggerIDPrifex)9",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(
                      OrClauseInTrigger(
                        equalColor0,
                        NotEqualsClauseInTrigger(equalPowerTrue))),
                    triggersWhen: .conditionFalseToTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)10",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(lessThanColor3_1415927),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)11",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(lessThanColor1_345),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)10",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(rangeColor2Included345NotIncluded),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)10",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: StatePredicate(
                    Condition(rangeColor2_1Included345_3Included),
                    triggersWhen: .conditionTrue),
                  command: command),
          Trigger("\(triggerIDPrifex)11",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: SchedulePredicate("00 * * * *"),
                  command: command),
          Trigger("\(triggerIDPrifex)12",
                  targetID: setting.target.typedID,
                  enabled: true,
                  predicate: ScheduleOncePredicate(Date()),
                  command: command)
        ]


        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers",
              request.url?.absoluteString)
        }
        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["triggers" : expectedTriggers.map { $0.makeJsonObject() }],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.listTriggers { triggers, nextPaginationKey, error -> Void in
            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(expectedTriggers, triggers!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testListTriggers_404_error() throws {
        let expectation = self.expectation(description: "getTrigger403Error")
        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        // mock response
        let errorCode = "TARGET_NOT_FOUND"
        let errorMessage =
          "Target \(setting.target.typedID.toString()) not found"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier { request in
            XCTAssertEqual(request.httpMethod, "GET")
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
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["errorCode" : errorCode, "message" : errorMessage],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self
        api.listTriggers {
            triggers, nextPaginationKey, error -> Void in
            XCTAssertNil(triggers)
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
            XCTAssertNil(error)
        }
    }

    func testListTriggers_target_not_available_error() {
        let expectation = self.expectation(
          description: "testListTriggers_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.listTriggers { triggers, nextPaginationKey, error -> Void in
            XCTAssertNil(triggers)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testListTriggersBestEffortLimit() throws {
        let expectation =
          self.expectation(description: "testListTriggersBestEffortLimit")

        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        let expectedBestEffortLimit = 2

        let expectedTrigger = Trigger(
          "dymmyTriggerID",
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)),
            triggersWhen: .conditionTrue),
          command: Command(
            "dummyCommandID",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ],
            commandState: .sending,
            created: Date()))

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers?bestEffortLimit=\(expectedBestEffortLimit)",
              request.url?.absoluteString)
        }
        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["triggers" : [expectedTrigger.makeJsonObject()]],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.listTriggers(expectedBestEffortLimit) {
            triggers, nextPaginationKey, error -> Void in

            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual([expectedTrigger], triggers!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testListTriggersPaginationKey() throws {
        let expectation =
          self.expectation(description: "testListTriggersPaginationKey")

        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        let expectedPaginationKey = "200/2"

        let expectedTrigger = Trigger(
          "dymmyTriggerID",
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)),
            triggersWhen: .conditionTrue),
          command: Command(
            "dummyCommandID",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ],
            commandState: .sending,
            created: Date()))

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers?paginationKey=\(expectedPaginationKey)",
              request.url?.absoluteString)
        }
        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["triggers" : [expectedTrigger.makeJsonObject()]],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.listTriggers(paginationKey: expectedPaginationKey) {
            triggers, nextPaginationKey, error -> Void in

            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual([expectedTrigger], triggers!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testListTriggersBestEffortLimitAndPaginationKey() throws {
        let expectation = self.expectation(
          description: "testListTriggersBestEffortLimitAndPaginationKey")

        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        let expectedBestEffortLimit = 2
        let expectedPaginationKey = "200/2"

        let expectedTrigger = Trigger(
          "dymmyTriggerID",
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)),
            triggersWhen: .conditionTrue),
          command: Command(
            "dummyCommandID",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ],
            commandState: .sending,
            created: Date()))

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers?paginationKey=\(expectedPaginationKey)&bestEffortLimit=\(expectedBestEffortLimit)",
              request.url?.absoluteString)
        }
        // mock response
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              ["triggers" : [expectedTrigger.makeJsonObject()]],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.listTriggers(
          expectedBestEffortLimit,
          paginationKey: expectedPaginationKey) {
            triggers, nextPaginationKey, error -> Void in

            XCTAssertNil(error)
            XCTAssertNil(nextPaginationKey)
            XCTAssertEqual([expectedTrigger], triggers!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testListTriggersNextPaginationKey() throws {
        let expectation = self.expectation(
          description: "testListTriggersNextPaginationKey")

        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api.target = setting.target

        let expectedBestEffortLimit = 2
        let expectedPaginationKey = "200/2"

        let expectedTrigger = Trigger(
          "dymmyTriggerID",
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)),
            triggersWhen: .conditionTrue),
          command: Command(
            "dummyCommandID",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ],
            commandState: .sending,
            created: Date()))

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers?paginationKey=\(expectedPaginationKey)&bestEffortLimit=\(expectedBestEffortLimit)",
              request.url?.absoluteString)
        }
        // mock response
        let expectedNextPaginationKey = "300/2"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject:
              [
                "triggers" : [expectedTrigger.makeJsonObject()],
                "nextPaginationKey" : expectedNextPaginationKey
              ],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.listTriggers(
          expectedBestEffortLimit,
          paginationKey: expectedPaginationKey) {
            triggers, nextPaginationKey, error -> Void in

            XCTAssertNil(error)
            XCTAssertEqual(expectedNextPaginationKey, nextPaginationKey)
            XCTAssertEqual([expectedTrigger], triggers!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
