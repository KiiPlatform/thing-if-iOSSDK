//
//  ThingIFAPIPatchServerCodeTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/28.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIPatchServerCodeTriggerTests: SmallTestBase {

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

    static let DEFAULT_SERVERCODE = ServerCode("endpoint")

    static let defaultTrigger = Trigger(
      "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
      targetID: TestSetting().target.typedID,
      enabled: true,
      predicate: StatePredicate(
        Condition(
          EqualsClauseInTrigger(
            "alias1",
            field: "color",
            intValue: 0)),
        triggersWhen: .conditionFalseToTrue),
      serverCode: DEFAULT_SERVERCODE
    )

    struct TestCase {
        let input: (ServerCode?, Predicate?, TriggerOptions?)?
        let output: Trigger

        init(
          _ input: (ServerCode?, Predicate?, TriggerOptions?)? =
            (nil, nil, TriggerOptions("title")),
          output: Trigger = defaultTrigger
        )
        {
            self.input = input
            self.output = output
        }
    }

    func testPatchTrigger() throws {

        let setting = TestSetting()

        let serverCode =
          ThingIFAPIPatchServerCodeTriggerTests.DEFAULT_SERVERCODE
        let serverCodeParameters: [String : Any] = [
          "string" : "str",
          "int" : 1234,
          "float" : 0.12345,
          "bool" : false
        ]

        let optionsMetadata = ["option-key" : "option-value"]

        let testsCases: [TestCase] = [
          // ServerCode tests.
          TestCase((ServerCode("endpoint"), nil, nil)),
          TestCase((ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken"),
                   nil,
                   nil
                   )),
          TestCase((ServerCode("endpoint", targetAppID: "targetAppID"),
                   nil,
                   nil
                   )),
          TestCase((ServerCode("endpoint", parameters: serverCodeParameters),
                   nil,
                   nil
                   )),
          TestCase((ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              targetAppID: "targetAppID"),
                   nil,
                   nil
                   )),
          TestCase((ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              parameters: serverCodeParameters),
                   nil,
                   nil
                   )),
          TestCase((ServerCode("endpoint",
                              targetAppID: "targetAppID",
                              parameters: serverCodeParameters),
                   nil,
                   nil
                   )),
          TestCase((ServerCode("endpoint",
                              executorAccessToken: "executorAccessToken",
                              targetAppID: "targetAppID",
                              parameters: serverCodeParameters),
                   nil,
                   nil
                   )),

          // TriggerOptions tests
          TestCase((nil, nil, TriggerOptions("title"))),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(triggerDescription: "trigger description")
            )
          ),
          TestCase((nil, nil, TriggerOptions(metadata: optionsMetadata))),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(
                "title",
                triggerDescription: "trigger description")

            )
          ),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(
                "title",
                metadata: optionsMetadata)
            )
          ),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(
                "title",
                triggerDescription: "trigger description",
                metadata: optionsMetadata)
            )
          ),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(
                triggerDescription: "trigger description",
                metadata: optionsMetadata)
            )
          ),

          // Predicate tests
          TestCase(
            (nil, ScheduleOncePredicate(Date(timeIntervalSinceNow: 10)), nil)
          ),
          TestCase((nil, SchedulePredicate("00 * * * *"), nil)),
          TestCase((nil, SchedulePredicate("1 * * * *"), nil)),
          TestCase((nil, SchedulePredicate("1 1 * * *"), nil)),
          TestCase((nil, SchedulePredicate("1 1 1 * *"), nil)),
          TestCase((nil, SchedulePredicate("1 1 1 1 *"), nil)),
          TestCase((nil, SchedulePredicate("1 1 1 1 1"), nil)),
          TestCase(
            (
              nil,
              StatePredicate(
                Condition(
                  EqualsClauseInTrigger("alias1", field: "color", intValue: 0)),
                triggersWhen: .conditionFalseToTrue),
              nil)
          ),

          // Response tests
          TestCase(
            output: Trigger(
              "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
              targetID: setting.target.typedID,
              enabled: true,
              predicate: StatePredicate(
                Condition(
                  EqualsClauseInTrigger(
                    "alias1",
                    field: "color",
                    intValue: 0)),
                triggersWhen: .conditionFalseToTrue),
              serverCode: serverCode)),
          TestCase(
            output: Trigger(
              "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
              targetID: setting.target.typedID,
              enabled: true,
              predicate: StatePredicate(
                Condition(
                  NotEqualsClauseInTrigger(
                    EqualsClauseInTrigger(
                      "alias1",
                      field: "power",
                      boolValue: true))),
                triggersWhen: .conditionFalseToTrue),
              serverCode: serverCode)),
          TestCase(
            output: Trigger(
              "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
              targetID: setting.target.typedID,
              enabled: true,
              predicate: SchedulePredicate("00 * * * *"),
              serverCode: serverCode)),
          TestCase(
            output: Trigger(
              "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
              targetID: setting.target.typedID,
              enabled: true,
              predicate: ScheduleOncePredicate(
                Date(timeIntervalSinceNow: 1000)),
              serverCode: serverCode))
        ]

        for (index,testCase) in testsCases.enumerated() {
            try patchTrigger(
              "testPatchTrigger_\(index)",
              testcase: testCase,
              setting: setting)
        }
    }

    func patchTrigger(
      _ tag: String,
      testcase: TestCase,
      setting: TestSetting) throws -> Void
    {
        let expectation : XCTestExpectation! =
          self.expectation(description: tag)

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
          // Patch request and response
          (
            (
              nil,
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 204,
                httpVersion: nil,
                headerFields: nil),
              nil
            ),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "PATCH")
                XCTAssertEqual(
                  setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(testcase.output.triggerID)",
                  request.url?.absoluteString,
                  tag)
                //verify header
                XCTAssertEqual(
                  [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                  ],
                  request.allHTTPHeaderFields!,
                  tag)
                //verify body
                if let requestBody = self.makePatchRequestBody(
                     testcase.input,
                     setting: setting) {
                    XCTAssertEqual(
                      requestBody as NSDictionary,
                      try JSONSerialization.jsonObject(
                        with: request.httpBody!,
                        options: .mutableContainers) as? NSDictionary,
                      tag)
                } else {
                    XCTAssertNil(request.httpBody)
                }
            }
          ),
          // Get reqeust and response
          (
            (
              try JSONSerialization.data(
                withJSONObject: testcase.output.makeJsonObject(),
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil),
              nil
            ),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "GET", tag)
                //verify header
                XCTAssertEqual(
                  setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(testcase.output.triggerID)",
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

        // perform onboarding.
        let api = setting.api
        api.target = setting.target

        api.patchTrigger(
          testcase.output.triggerID,
          serverCode: testcase.input?.0,
          predicate: testcase.input?.1,
          options: testcase.input?.2) { trigger, error -> Void in

            XCTAssertNil(error)
            XCTAssertEqual(testcase.output, trigger)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error, tag)
        }
    }

    private func makePatchRequestBody(
      _ input: (
        serverCode: ServerCode?,
        predicate: Predicate?,
        options: TriggerOptions?)?,
      setting: TestSetting) -> [String : Any]?
    {
        guard let input = input else {
            return nil
        }

        var retval = input.options?.makeJsonObject() ?? [ : ]
        retval["predicate"] =
          (input.predicate as? ToJsonObject)?.makeJsonObject()
        if let serverCode = input.serverCode {
            retval["serverCode"] = serverCode.makeJsonObject()
            retval["triggersWhat"] = TriggersWhat.serverCode.rawValue
        }
        return retval.isEmpty ? nil : retval
    }

    func testPatchTrigger_404() throws {
        let expectation : XCTestExpectation! =
          self.expectation(description: "testPatchTrigger_404")

        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        // perform onboarding
        api.target = target

        let options = TriggerOptions("title")
        let triggerID = "dummyTriggerID"

        sharedMockSession.requestVerifier = makeRequestVerifier()  { request in
            XCTAssertEqual(request.httpMethod, "PATCH")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)",
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
              self.makePatchRequestBody(
                (nil, nil, options),
                setting: setting)! as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: .mutableContainers) as? NSDictionary)
        }
        let errorCode = "TRIGGER_NOT_FOUND"
        let errorMessage = "Trigger not found"
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

        api.patchTrigger(
          triggerID,
          serverCode: nil,
          options: options)
        {
            trigger, error -> Void in

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

    func testPatchTrigger_target_not_available_error() {
        let expectation = self.expectation(
          description: "testPatchTrigger_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.patchTrigger(
          expectedTriggerID,
          serverCode: nil,
          predicate: nil) { trigger, error -> Void in
            XCTAssertNil(trigger)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testPatchTrigger_unsupportedError() {
        let expectation =
          self.expectation(description: "testPatchTrigger_unsupportedError")
        let setting = TestSetting()
        let api = setting.api

        api.target = setting.target

        api.patchTrigger(
          "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
          serverCode: nil,
          predicate: nil) { (trigger, error) -> Void in
            XCTAssertNil(trigger)
            XCTAssertEqual(
              ThingIFError.invalidArgument(
                message: "nothing to send as patch trigger"),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testPatchTrigger_withEmptyOptions_unsupportedError() {
        let expectation = self.expectation(
          description: "testPatchTrigger_withEmptyOptions_unsupportedError")
        let setting = TestSetting()
        let api = setting.api

        api.target = setting.target

        api.patchTrigger(
          "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
          serverCode: nil,
          predicate: nil,
          options: TriggerOptions()) { (trigger, error) -> Void in
            XCTAssertNil(trigger)
            XCTAssertEqual(
              ThingIFError.invalidArgument(
                message: "nothing to send as patch trigger"),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
