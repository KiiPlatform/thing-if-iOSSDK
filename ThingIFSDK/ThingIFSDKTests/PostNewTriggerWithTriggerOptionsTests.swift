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
      options: TriggerOptions,
      setting: TestSetting) -> Dictionary<String, AnyObject>
    {
        var trigger: Dictionary<String, AnyObject> =
          [
            "command" : [
              "schema" : "name",
              "schemaVersion" : 1,
              "actions" : [[ "actions-key" : "actions-value"]],
              "issuer" : setting.owner.typedID.toString(),
              "target" : setting.api.target!.typedID.toString()],
            "predicate" : [ "eventSource" : "SCHEDULE",
                            "schedule" : "1 * * * *" ],
            "triggersWhat": TriggersWhat.COMMAND.rawValue
          ]
        trigger["title"] = options.title
        trigger["description"] = options.triggerDescription
        trigger["metadata"] = options.metadata
        return trigger;
    }

    func testSuccess () {
        let trigger_metadata: Dictionary<String, AnyObject> =
            ["trigger_metadata-key" : "trigger_metadata-value"]
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
            expectation = self.expectationWithDescription(error_message)

            sharedMockSession.mockResponse = MockResponse(
                try! NSJSONSerialization.dataWithJSONObject(
                    ["triggerID": "triggerID"],
                    options: .PrettyPrinted),
                urlResponse: NSHTTPURLResponse(
                    URL: NSURL(string:setting.app.baseURL)!,
                    statusCode: 201,
                    HTTPVersion: nil,
                    headerFields: nil)!,
                error: nil)
            sharedMockSession.requestVerifier = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST", error_message)
                XCTAssertEqual(request.URL!.absoluteString,
                               "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers",
                               error_message)
                var requestHeaders = request.allHTTPHeaderFields!;
                // X-Kii-SDK header is not required to check because
                // this is SDK version dependent.
                requestHeaders["X-Kii-SDK"] = nil
                // verify request header.
                XCTAssertEqual(
                  requestHeaders,
                  [
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                  ],
                  error_message);

                // verify body.
                XCTAssertEqual(
                  NSDictionary(
                    dictionary: try! NSJSONSerialization.JSONObjectWithData(
                      request.HTTPBody!,
                      options: .MutableContainers)
                      as! Dictionary<String, AnyObject>),
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
                  if actual.metadata == nil {
                      // If actual.metadata is nil, then options.metadata must
                      // be nil
                      XCTAssertNil(options.metadata, error_message)
                  } else  {
                      XCTAssertEqual(
                        NSDictionary(dictionary: actual.metadata!),
                        NSDictionary(dictionary: options.metadata!),
                        error_message)
                  }
                  expectation.fulfill()
              })
            self.waitForExpectationsWithTimeout(TEST_TIMEOUT)
                { (error) -> Void in
                    if error != nil {
                        XCTFail("execution timeout for \(error_message)")
                    }
                }
        }
    }
}
