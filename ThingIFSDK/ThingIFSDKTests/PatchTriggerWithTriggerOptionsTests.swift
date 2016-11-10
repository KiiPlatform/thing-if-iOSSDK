//
//  PatchTriggerWithTriggerOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/21.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

import XCTest
@testable import ThingIFSDK

class PatchTriggerWithTriggerOptionsTests: SmallTestBase {

    private func createSuccessRequestBody(
      _ options: TriggerOptions) -> Dictionary<String, Any>
    {
        var trigger: Dictionary<String, Any> = [
            "triggersWhat": TriggersWhat.command.rawValue
          ]

        if let title = options.title {
            trigger["title"] = title
        }
        if let description = options.triggerDescription {
            trigger["description"] = description
        }
        if let metadata = options.metadata {
            trigger["metadata"] = metadata
        }
        return trigger;
    }

    func testSuccess() {
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

        for options_index in 0..<optionsArray.count {
            let options: TriggerOptions = optionsArray[options_index]

            let error_message = "options: \(options_index)"
            weak var expectation : XCTestExpectation!
            defer {
                expectation = nil
            }
            expectation = self.expectation(description: error_message)

            sharedMockMultipleSession.responsePairs =
                [
                  (
                    (
                      data: nil,
                      urlResponse: HTTPURLResponse(
                        url: URL(string:setting.app.baseURL)!,
                        statusCode: 204,
                        httpVersion: nil,
                        headerFields: nil),
                      error: nil
                    ),
                    {(request) in
                        XCTAssertEqual(request.httpMethod, "PATCH")

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
                        XCTAssertEqual(
                          request.url?.absoluteString,
                          setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID",
                          error_message)

                        // verify body.
                        XCTAssertEqual(
                          NSDictionary(
                            dictionary: try! JSONSerialization.jsonObject(
                              with: request.httpBody!,
                              options: .mutableContainers)
                              as! Dictionary<String, Any>),
                          NSDictionary(
                            dictionary: self.createSuccessRequestBody(options)),
                          error_message)
                    }
                  ),
                  (
                    (
                      data: try! JSONSerialization.data(
                        withJSONObject: [
                          "triggerID" : "triggerID",
                          "command" :
                            [
                              "schema" : "name",
                              "schemaVersion" : 1,
                              "actions" : [["actions-key" : "actions-value"]],
                              "target" : "THING:target",
                              "issuer" : setting.owner.typedID.toString(),
                              "title" : "command title",
                              "description" : "command description",
                              "metadata" :
                                ["command_metadata-key" :
                                   "command_metadata-value"]
                            ],
                          "predicate" :
                            [
                              "eventSource" : "SCHEDULE",
                              "schedule" : "1 * * * *"
                            ],
                          "title" : "trigger title",
                          "description" : "trigger description",
                          "metadata" : trigger_metadata,
                          "disabled": false
                        ],
                        options: .prettyPrinted),
                      urlResponse: HTTPURLResponse(
                        url: URL(string: setting.app.baseURL)!,
                        statusCode: 201,
                        httpVersion: nil,
                        headerFields: nil),
                      error: nil
                    ),
                    {(request) in
                    }
                  )
                ]
            iotSession = MockMultipleSession.self

            setting.api.patchTrigger(
                "triggerID",
                triggeredCommandForm: nil,
                predicate: nil,
                options: options,
                completionHandler: {
                    (trigger, error) -> Void in
                    XCTAssertNotNil(trigger)
                    let tgr = trigger!
                    XCTAssertEqual(tgr.triggerID, "triggerID", error_message)
                    XCTAssertEqual(tgr.targetID.toString(),
                                   setting.api.target?.typedID.toString(),
                                   error_message)
                    XCTAssertTrue(tgr.enabled, error_message)
                    XCTAssertEqual(tgr.predicate.toNSDictionary(),
                                   NSDictionary(dictionary:
                                                  [
                                                    "eventSource" : "SCHEDULE",
                                                    "schedule" : "1 * * * *"
                                                  ]))
                    XCTAssertEqual(tgr.title, "trigger title", error_message)
                    XCTAssertEqual(tgr.triggerDescription,
                                   "trigger description", error_message)
                    XCTAssertEqual(NSDictionary(dictionary: tgr.metadata!),
                                   NSDictionary(dictionary: trigger_metadata),
                                   error_message)
                    let command = tgr.command!
                     XCTAssertEqual(command.targetID.toString(),
                                    "thing:target", error_message)
                     XCTAssertEqual(command.issuerID.toString(),
                                    setting.owner.typedID.toString(),
                                    error_message)
                     XCTAssertEqual(command.schemaName, "name", error_message)
                     XCTAssertEqual(command.schemaVersion, 1, error_message)
                     XCTAssertEqual(command.actions.count, 1, error_message)
                     XCTAssertEqual(
                       NSDictionary(
                         dictionary: command.actions[0]),
                       NSDictionary(
                         dictionary: ["actions-key" : "actions-value"]),
                       error_message)
                     XCTAssertEqual(command.title!, "command title",
                                    error_message)
                     XCTAssertEqual(command.commandDescription!,
                                    "command description",
                                    error_message)
                     XCTAssertEqual(
                       NSDictionary(dictionary: command.metadata!),
                       NSDictionary(
                         dictionary: ["command_metadata-key" :
                                        "command_metadata-value"]),
                       error_message)
                    expectation.fulfill()
                })
            self.waitForExpectations(timeout: TEST_TIMEOUT)
                { (error) -> Void in
                    if error != nil {
                        XCTFail(error_message)
                    }
                }
        }
    }

}
