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

    private func createSuccessRequestBody(
      form: TriggeredCommandForm,
      setting: TestSetting) -> Dictionary<String, AnyObject>
    {
        let targetID = form.targetID ?? setting.api.target!.typedID
        var command: Dictionary<String, AnyObject> = [
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
                 "triggersWhat": TriggersWhat.COMMAND.rawValue ]
    }

    func testSuccess () {
        let actions: [Dictionary<String, AnyObject>] =
            [["actions-key" : "actions-value"]]
        let command_metadata: Dictionary<String, AnyObject> =
            ["command_metadata-key" : "command_metadata-value"]
        let targetID = TypedID(type: "THING", id: "thing-id")
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
                    dictionary: try! NSJSONSerialization.JSONObjectWithData(
                      request.HTTPBody!,
                      options: .MutableContainers)
                      as! Dictionary<String, AnyObject>),
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
                  if actualcmd.metadata == nil {
                      // If actual.metadata is nil, then options.metadata must
                      // be nil
                      XCTAssertNil(form.metadata, error_message)
                  } else {
                      XCTAssertEqual(
                        NSDictionary(dictionary: actualcmd.metadata!),
                        NSDictionary(dictionary: form.metadata!),
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
