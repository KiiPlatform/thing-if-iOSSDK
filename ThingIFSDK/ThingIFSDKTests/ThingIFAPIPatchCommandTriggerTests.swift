//
//  ThingIFAPIPatchCommandTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIPatchCommandTriggerTests: SmallTestBase {

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

    static let DEFAULT_COMMAND = Command(
      "429251a0-46f7-11e5-a5eb-06d9d1527620",
      targetID: TestSetting().target.typedID,
      issuerID: TestSetting().owner.typedID,
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
      created: Date()
    )

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
      command: DEFAULT_COMMAND
    )

    struct TestCase {
        let input: (TriggeredCommandForm?, Predicate?, TriggerOptions?)?
        let output: Trigger

        init(
          _ input: (TriggeredCommandForm?, Predicate?, TriggerOptions?)? =
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

        let command = ThingIFAPIPatchCommandTriggerTests.DEFAULT_COMMAND
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action("turnPower", value: true),
              Action("setBrightness", value: 90)
            ]
          )
        ]

        let optionsMetadata = ["option-key" : "option-value"]

        let testsCases: [TestCase] = [
          // TriggeredCommandForm tests.
          TestCase(
            (
              TriggeredCommandForm(aliasActions),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID")
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                title: "title"
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                commandDescription: "description"
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID"),
                title: "title"
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID"),
                commandDescription: "description"
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID"),
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                title: "title",
                commandDescription: "description"
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                title: "title",
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID"),
                title: "title",
                commandDescription: "description"
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID"),
                title: "title",
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                commandDescription: "description",
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                title: "title",
                commandDescription: "description",
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          TestCase(
            (
              TriggeredCommandForm(
                aliasActions,
                targetID: TypedID(.thing, id: "dummyCommandID"),
                title: "title",
                commandDescription: "description",
                metadata: ["key" : "value"]
              ),
              nil,
              nil
            )
          ),
          // TriggerOptions tests
          TestCase(
            (
              nil,
              nil,
              TriggerOptions("title")
            )
          ),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(triggerDescription: "trigger description")
            )
          ),
          TestCase(
            (
              nil,
              nil,
              TriggerOptions(metadata: optionsMetadata)
            )
          ),
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
              command: command)),
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
              command: command)),
          TestCase(
            output: Trigger(
              "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
              targetID: setting.target.typedID,
              enabled: true,
              predicate: SchedulePredicate("00 * * * *"),
              command: command)),
          TestCase(
            output: Trigger(
              "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
              targetID: setting.target.typedID,
              enabled: true,
              predicate: ScheduleOncePredicate(
                Date(timeIntervalSinceNow: 1000)),
              command: command))
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
          triggeredCommandForm: testcase.input?.0,
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
        form: TriggeredCommandForm?,
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
        if let form = input.form {
            var commandJson = form.makeJsonObject()
            commandJson["issuer"] = setting.owner.typedID.toString()
            if commandJson["target"] == nil {
                commandJson["target"] = setting.target.typedID.toString()
            }
            retval["command"] = commandJson
            retval["triggersWhat"] = TriggersWhat.command.rawValue
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
          triggeredCommandForm: nil,
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
          triggeredCommandForm: nil,
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
          triggeredCommandForm: nil,
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
          triggeredCommandForm: nil,
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
