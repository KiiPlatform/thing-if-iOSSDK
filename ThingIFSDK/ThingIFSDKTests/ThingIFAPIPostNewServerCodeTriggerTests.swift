//
//  ThingIFAPIPostNewServerCodeTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/28.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIPostNewServerCodeTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let serverCode: ServerCode
        let predicate: Predicate & ToJsonObject
        let options: TriggerOptions?

        init(
          _ serverCode: ServerCode = ServerCode("endpoint"),
          predicate: Predicate & ToJsonObject = ScheduleOncePredicate(Date()),
          options: TriggerOptions? = nil)
        {
            self.serverCode = serverCode
            self.predicate = predicate
            self.options = options
        }
    }

    func testPostNewServerCodeTriggerSuccess() throws -> Void {
        let setting = TestSetting()

        let serverCodeParameters: [String : Any] = [
          "string" : "str",
          "int" : 1234,
          "float" : 0.12345,
          "bool" : false
        ]
        let triggerMetadata = ["triggerMetadataKey" : "triggerMetadataValue"]

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

        let testcases = [
          // Server code tests.
          TestCase(ServerCode("endpoint")),
          TestCase(ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken")),
          TestCase(ServerCode("endpoint", targetAppID: "targetAppID")),
          TestCase(ServerCode("endpoint", parameters: serverCodeParameters)),
          TestCase(ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              targetAppID: "targetAppID")),
          TestCase(ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              parameters: serverCodeParameters)),
          TestCase(ServerCode("endpoint",
                              targetAppID: "targetAppID",
                              parameters: serverCodeParameters)),
          TestCase(ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              targetAppID: "targetAppID",
                              parameters: serverCodeParameters)),
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
          // Schedule once
          TestCase(
            predicate: ScheduleOncePredicate(Date(timeIntervalSinceNow: 10))),
          // Schedule
          TestCase(predicate: SchedulePredicate("00 * * * *")),
          // state predicate
          TestCase(predicate: StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(equalPowerTrue),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(NotEqualsClauseInTrigger(equalPowerTrue)),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(lessThanOrEqualColor255),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(lessThanColor200),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(lessThanColor200_345),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(greaterThanOrEqualColor1),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(greaterThanColor1),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(greaterThanColor1_345),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(rangeInclude1ToInclude345),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(rangeInclude1_1ToInclude345_3),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(
                       AndClauseInTrigger(
                         equalColor0,
                         NotEqualsClauseInTrigger(equalPowerTrue))),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(
                       OrClauseInTrigger(
                         equalColor0,
                         NotEqualsClauseInTrigger(equalPowerTrue))),
                     triggersWhen: .conditionFalseToTrue)),
          // triggersWhen tests
          TestCase(predicate: StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionChanged)),
          TestCase(predicate: StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(equalColor0),
                     triggersWhen: .conditionFalseToTrue)),
          // complex clauses tests
          TestCase(predicate: StatePredicate(
                     Condition(
                       AndClauseInTrigger(
                         equalBrightness50,
                         OrClauseInTrigger(
                           equalColor0,
                           NotEqualsClauseInTrigger(equalPowerTrue)))),
                     triggersWhen: .conditionFalseToTrue)),
          TestCase(predicate: StatePredicate(
                     Condition(
                       OrClauseInTrigger(
                         equalBrightness50,
                         AndClauseInTrigger(
                           equalColor0,
                           NotEqualsClauseInTrigger(equalPowerTrue)))),
                     triggersWhen: .conditionFalseToTrue)),
          // complex tests
          TestCase(ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              targetAppID: "targetAppID",
                              parameters: serverCodeParameters),
                   predicate: StatePredicate(
                     Condition(
                       AndClauseInTrigger(
                         equalBrightness50,
                         OrClauseInTrigger(
                           equalColor0,
                           NotEqualsClauseInTrigger(equalPowerTrue)))),
                     triggersWhen: .conditionFalseToTrue),
                   options: TriggerOptions(
                     "trigger title",
                     triggerDescription: "trigger description",
                     metadata: triggerMetadata))
        ]

        for (index, testcase) in testcases.enumerated() {
            try postNewServerCodeTrigger(
              testcase,
              setting: setting,
              tag: "testPostNewServerCodeTriggerSuccess\(index)")
        }
    }

    func postNewServerCodeTrigger(
      _ testcase: TestCase,
      setting:TestSetting,
      tag: String) throws -> Void
    {
        let expectation = self.expectation(description: tag)

        let predicate = testcase.predicate
        let options = testcase.options
        let serverCode = testcase.serverCode

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: predicate,
          serverCode: serverCode
        )

        // perform onboarding.
        let api = setting.api
        api.target = setting.target

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
                XCTAssertEqual(
                  ([
                     "predicate" : predicate.makeJsonObject(),
                     "serverCode" : serverCode.makeJsonObject(),
                     "triggersWhat" : TriggersWhat.serverCode.rawValue
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

        api.postNewTrigger(
          serverCode,
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
}
