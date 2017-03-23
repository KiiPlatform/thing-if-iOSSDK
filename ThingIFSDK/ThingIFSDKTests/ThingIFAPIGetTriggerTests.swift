//
//  ThingIFAPIGetTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/23.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

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

        let testCases: [TriggerClause & ToJsonObject] =
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

        for (index, testCase) in testCases.enumerated() {
            try getTriggerSuccess(
              "testGetTrigger_success_predicates\(index)",
              testCase: testCase,
              triggersWhen: .conditionFalseToTrue,
              setting: setting)
        }
    }

    func getTriggerSuccess(
      _ tag: String,
      testCase: TriggerClause & ToJsonObject,
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
            Condition(testCase),
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
            XCTAssertEqual(request.httpMethod, "GET")
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
              request.allHTTPHeaderFields!)
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
            XCTAssertNil(error)
            XCTAssertEqual(expectedTrigger, trigger)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

}
