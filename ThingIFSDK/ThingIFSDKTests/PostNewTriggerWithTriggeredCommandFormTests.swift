//
//  PostNewTriggerWithTriggeredCommandFormTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/05.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewTriggerWithTriggeredCommandFormTests: SmallTestBase {

    fileprivate func createSuccessRequestBody(
      _ form: TriggeredCommandForm,
      setting: TestSetting) -> Dictionary<String, Any>
    {
        let targetID = form.targetID ?? setting.api.target!.typedID
        var command: Dictionary<String, Any> = [
          "schema" : form.schemaName,
          "schemaVersion" : form.schemaVersion,
          "actions" : form.actions,
          "issuer" : setting.owner.typedID.toString(),
          "target" : targetID.toString()
        ]
        command["title"] = form.title
        command["description"] = form.commandDescription
        command["metadata"] = form.metadata

        return [ "command" : command,
                 "predicate" : [ "eventSource" : "SCHEDULE",
                                 "schedule" : "1 * * * *" ],
                 "triggersWhat": TriggersWhat.command.rawValue ]
    }

    func testSuccess () {
        let actions: [Dictionary<String, Any>] =
            [["actions-key" : "actions-value"]]
        let command_metadata: Dictionary<String, Any> =
            ["command_metadata-key" : "command_metadata-value"]
        let targetID = TypedID(type: "THING", id: "thing-id")

        // TriggeredCommandForm instances below are used as inputs and
        // expected outputs of this test. It is little bit lazy but
        // TriggeredCommandForm class is tested by
        // TriggeredCommandFormTests.swift. So TriggeredCommandForm
        // instance can be adequate as expected output of this tests.
        let forms = [
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 title: "command title"),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 commandDescription: "command description"),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 metadata: command_metadata),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID,
                                 title: "command title"),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID,
                                 commandDescription: "command description"),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID,
                                 metadata: command_metadata),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID,
                                 title: "command title",
                                 commandDescription: "command description"),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID,
                                 title: "command title",
                                 metadata: command_metadata),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 targetID: targetID,
                                 title: "command title",
                                 commandDescription: "command description",
                                 metadata: command_metadata),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 title: "command title",
                                 commandDescription: "command description"),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 title: "command title",
                                 metadata: command_metadata),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 title: "command title",
                                 commandDescription: "command description",
                                 metadata: command_metadata),
            TriggeredCommandForm(schemaName: "name",
                                 schemaVersion: 1,
                                 actions: actions,
                                 commandDescription: "command description",
                                 metadata: command_metadata)
        ]

        let setting = TestSetting()
        setting.api._target = setting.target

        for index in 0..<forms.count {
            let form = forms[index]
            let error_message = "form: \(index)"

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
                      form, setting: setting)),
                  error_message)
            }
            iotSession = MockSession.self

            setting.api.postNewTrigger(
              form,
              predicate: SchedulePredicate(schedule: "1 * * * *"),
              options: nil,
              completionHandler: {
                  (trigger, error) -> Void in
                  XCTAssertNotNil(trigger)
                  let actual = trigger!
                  XCTAssertEqual(actual.triggerID, "triggerID", error_message)
                  XCTAssertEqual(actual.targetID,
                                 setting.target.typedID,
                                 error_message)
                  XCTAssertEqual(actual.enabled, Bool(true), error_message)

                  XCTAssertEqual(actual.predicate.toNSDictionary(),
                                 SchedulePredicate(
                                   schedule: "1 * * * *").toNSDictionary(),
                                 error_message)
                  let actualcmd = actual.command!
                  XCTAssertEqual(actualcmd.commandID, "", error_message)

                  XCTAssertEqual(actualcmd.targetID,
                                form.targetID ?? setting.target.typedID,
                                error_message)
                  XCTAssertEqual(actualcmd.issuerID, setting.owner.typedID,
                                 error_message)
                  XCTAssertEqual(actualcmd.schemaName, form.schemaName,
                                 error_message)
                  XCTAssertEqual(actualcmd.schemaVersion, form.schemaVersion,
                                 error_message)
                  XCTAssertEqual(actualcmd.actions.count, form.actions.count,
                                 error_message)
                  for i in 0..<actualcmd.actions.count {
                      XCTAssertEqual(
                        NSDictionary(
                          dictionary: actualcmd.actions[i]),
                        NSDictionary(dictionary: form.actions[i]),
                        error_message)
                  }
                  XCTAssertEqual(actualcmd.title, form.title,
                                 error_message)
                  XCTAssertEqual(actualcmd.commandDescription,
                                 form.commandDescription,
                                 error_message)
                  if let expectedMetadata = form.metadata {
                      XCTAssertNotNil(actualcmd.metadata, error_message)
                      XCTAssertEqual(
                        NSDictionary(dictionary: actualcmd.metadata!),
                        NSDictionary(dictionary: expectedMetadata),
                        error_message)
                  } else {
                      // If input metadata is nil, then output
                      // metadata must be nil.
                      XCTAssertNil(actualcmd.metadata, error_message)
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
