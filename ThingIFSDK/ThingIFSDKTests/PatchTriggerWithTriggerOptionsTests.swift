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
      options: TriggerOptions) -> Dictionary<String, AnyObject>
    {
        var trigger: Dictionary<String, AnyObject> = [
            "triggersWhat": TriggersWhat.COMMAND.rawValue
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

        for options_index in 0..<optionsArray.count {
            let options: TriggerOptions = optionsArray[options_index]

            let error_message = "options: \(options_index)"
            weak var expectation : XCTestExpectation!
            defer {
                expectation = nil
            }
            expectation = self.expectationWithDescription(error_message)

            sharedMockMultipleSession.responsePairs =
                [
                  (
                    (
                      data: nil,
                      urlResponse: NSHTTPURLResponse(
                        URL: NSURL(string:setting.app.baseURL)!,
                        statusCode: 204,
                        HTTPVersion: nil,
                        headerFields: nil),
                      error: nil
                    ),
                    {(request) in
                        XCTAssertEqual(request.HTTPMethod, "PATCH")

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
                        XCTAssertEqual(
                          request.URL?.absoluteString,
                          setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID",
                          error_message)

                        // verify body.
                        XCTAssertEqual(
                          NSDictionary(
                            dictionary: try! NSJSONSerialization.JSONObjectWithData(
                              request.HTTPBody!,
                              options: .MutableContainers)
                              as! Dictionary<String, AnyObject>),
                          NSDictionary(
                            dictionary: self.createSuccessRequestBody(options)),
                          error_message)
                    }
                  ),
                  (
                    (
                      data: try! NSJSONSerialization.dataWithJSONObject(
                        [
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
                        options: .PrettyPrinted),
                      urlResponse: NSHTTPURLResponse(
                        URL: NSURL(string: setting.app.baseURL)!,
                        statusCode: 201,
                        HTTPVersion: nil,
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
            self.waitForExpectationsWithTimeout(TEST_TIMEOUT)
                { (error) -> Void in
                    if error != nil {
                        XCTFail(error_message)
                    }
                }
        }
    }

}
