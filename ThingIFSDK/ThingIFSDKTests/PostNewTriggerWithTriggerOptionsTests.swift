//
//  PostNewTriggerWithTriggerOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/21.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewTriggerWithTriggerOptionsTests: SmallTestBase {

    private func createSuccessRequestBody(
      _ options: TriggerOptions,
      setting: TestSetting) -> Dictionary<String, Any>
    {
        var trigger: Dictionary<String, Any> =
          [
            "command" : [
              "schema" : "name",
              "schemaVersion" : 1,
              "actions" : [[ "actions-key" : "actions-value"]],
              "issuer" : setting.owner.typedID.toString(),
              "target" : setting.api.target!.typedID.toString()],
            "predicate" : [ "eventSource" : "SCHEDULE",
                            "schedule" : "1 * * * *" ],
            "triggersWhat": TriggersWhat.command.rawValue
          ]
        trigger["title"] = options.title
        trigger["description"] = options.triggerDescription
        trigger["metadata"] = options.metadata
        return trigger;
    }

    func testSuccess () {
        let trigger_metadata: Dictionary<String, Any> =
            ["trigger_metadata-key" : "trigger_metadata-value"]

        // TriggerOptions instances below are used as inputs and
        // expected outputs of this test. It is little bit lazy but
        // TriggerOptions class is tested by
        // TriggerOptionsTests.swift. So TriggerOptions instance can
        // be adequate as expected output of this tests.
        let optionsArray: [TriggerOptions] = [
            TriggerOptions(title: "trigger title"),
            TriggerOptions(triggerDescription: "trigger description"),
            TriggerOptions(metadata: trigger_metadata),
            TriggerOptions(
                title: "trigger title",
                triggerDescription: "trigger description"),
            TriggerOptions(
                title: "trigger title",
                metadata: trigger_metadata),
            TriggerOptions(
                triggerDescription: "trigger description",
                metadata: trigger_metadata),
            TriggerOptions(
                title: "trigger title",
                triggerDescription: "trigger description",
                metadata: trigger_metadata)
        ]

        let setting = TestSetting()
        setting.api._target = setting.target

        for index in 0..<optionsArray.count {
            let options = optionsArray[index]
            let error_message = "options: \(index)"
            weak var expectation : XCTestExpectation!
            defer {
                expectation = nil
            }
            expectation = self.expectation(description: error_message)

            sharedMockSession.mockResponse = MockResponse(
                try! JSONSerialization.data(
                    withJSONObject: ["triggerID": "triggerID"],
                    options: .prettyPrinted),
                urlResponse: HTTPURLResponse(
                    url: URL(string:setting.app.baseURL)!,
                    statusCode: 201,
                    httpVersion: nil,
                    headerFields: nil)!,
                error: nil)
            sharedMockSession.requestVerifier = {(request) in
                XCTAssertEqual(request.httpMethod, "POST", error_message)
                XCTAssertEqual(request.url!.absoluteString,
                               "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers",
                               error_message)
                let requestHeaders = request.allHTTPHeaderFields!;
                // verify request header.
                XCTAssertEqual(
                  requestHeaders,
                  [
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json",
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader!
                  ],
                  error_message);

                // verify body.
                XCTAssertEqual(
                  NSDictionary(
                    dictionary: try! JSONSerialization.jsonObject(
                      with: request.httpBody!,
                      options: .mutableContainers)
                      as! Dictionary<String, Any>),
                  NSDictionary(
                    dictionary: self.createSuccessRequestBody(
                      options, setting: setting)),
                  error_message)
            }
            iotSession = MockSession.self

            setting.api.postNewTrigger(
              TriggeredCommandForm(schemaName: "name",
                                   schemaVersion: 1,
                                   actions:
                                     [[ "actions-key" : "actions-value"]]),
              predicate: SchedulePredicate(schedule: "1 * * * *"),
              options: options,
              completionHandler: {
                  (trigger, error) -> Void in
                  XCTAssertNotNil(trigger)
                  let actual = trigger!
                  XCTAssertEqual(actual.triggerID, "triggerID", error_message)
                  XCTAssertEqual(actual.targetID, setting.target.typedID,
                                 error_message)
                  XCTAssertEqual(actual.enabled, Bool(true), error_message)
                  XCTAssertEqual(actual.predicate.toNSDictionary(),
                                 NSDictionary(
                                   dictionary:
                                     [ "eventSource" : "SCHEDULE",
                                       "schedule" : "1 * * * *" ]),
                                 error_message)

                  let actualcmd = actual.command!
                  XCTAssertEqual(actualcmd.commandID, "", error_message)

                  XCTAssertEqual(actualcmd.targetID,
                                 setting.api.target!.typedID,
                                 error_message)
                  XCTAssertEqual(actualcmd.issuerID,
                                 setting.owner.typedID,
                                 error_message)
                  XCTAssertEqual(actualcmd.schemaName, "name", error_message)
                  XCTAssertEqual(actualcmd.schemaVersion, 1, error_message)
                  XCTAssertEqual(actualcmd.actions.count, 1, error_message)
                  XCTAssertEqual(NSDictionary(
                                   dictionary: actualcmd.actions[0]),
                                 NSDictionary(
                                   dictionary:
                                     [ "actions-key" : "actions-value"]),
                                 error_message)

                  XCTAssertEqual(actual.title, options.title, error_message)
                  XCTAssertEqual(actual.triggerDescription,
                                 options.triggerDescription,
                                 error_message)
                  if let expectedMetadata = options.metadata {
                      XCTAssertNotNil(actual.metadata, error_message)
                      XCTAssertEqual(
                        NSDictionary(dictionary: actual.metadata!),
                        NSDictionary(dictionary: expectedMetadata),
                        error_message)
                  } else  {
                      // If input metadata is nil, then output
                      // metadata must be nil.
                      XCTAssertNil(actual.metadata, error_message)
                  }
                  expectation.fulfill()
              })
            self.waitForExpectations(timeout: TEST_TIMEOUT)
                { (error) -> Void in
                    if error != nil {
                        XCTFail("execution timeout for \(error_message)")
                    }
                }
        }
    }
}
