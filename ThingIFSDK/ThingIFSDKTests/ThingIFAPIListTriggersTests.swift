//
//  ThingIFAPIListTriggersTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/24.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIListTriggersTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testListTriggers_success_predicates() throws {
        let expectation = self.expectation(description: "testListTriggers_success_predicates")

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
                  command: command)
        ]


        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() { request in
            XCTAssertEqual(request.httpMethod, "GET")
            //verify header
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

        api.listTriggers(nil, paginationKey: nil) {
            triggers, paginationKey, error -> Void in

            XCTAssertNil(error)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(expectedTriggers, triggers!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
