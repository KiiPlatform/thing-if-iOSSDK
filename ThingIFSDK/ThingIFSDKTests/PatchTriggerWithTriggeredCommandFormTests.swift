//
//  PatchTriggerWithTriggeredCommandFormTest.swift
//  ThingIFSDK
//
//  Created on 2016/10/06.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PatchTriggerWithTriggeredCommandFormTest: SmallTestBase {

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

        return [ "triggersWhat": TriggersWhat.COMMAND.rawValue,
                 "command" : command ]
    }

    func testSuccess() {
        let actions: [Dictionary<String, AnyObject>] =
            [["actions-key" : "actions-value"]]
        let command_metadata: Dictionary<String, AnyObject> =
            ["command_metadata-key" : "command_metadata-value"]
        let targetID = TypedID(type: "THING", id: "thing-id")
        let forms: [TriggeredCommandForm] = [
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

        for form_index in 0..<forms.count {
            let form: TriggeredCommandForm = forms[form_index]

            let expectedThingID = form.targetID ?? setting.api.target!.typedID
            let error_message =
              "form: \(form_index)"
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
                            dictionary: self.createSuccessRequestBody(
                              form,
                              setting: setting)),
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
                              "actions" : actions,
                              "target" : expectedThingID.toString(),
                              "issuer" : setting.owner.typedID.toString(),
                              "title" : "command title",
                              "description" : "command description",
                              "metadata" : command_metadata
                            ],
                          "predicate" :
                            [
                              "eventSource" : "SCHEDULE",
                              "schedule" : "1 * * * *"
                            ],
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
                triggeredCommandForm: form,
                predicate: nil,
                options: nil,
                completionHandler: {
                    (trigger, error) -> Void in
                    if let tgr = trigger {
                        XCTAssertEqual(
                          tgr.triggerID, "triggerID", error_message)
                        XCTAssertEqual(
                          tgr.targetID.toString(),
                          setting.api.target?.typedID.toString(),
                          error_message)
                        XCTAssertTrue(tgr.enabled, error_message)
                        XCTAssertEqual(tgr.predicate.toNSDictionary(),
                                       NSDictionary(
                                         dictionary:
                                           [
                                             "eventSource" : "SCHEDULE",
                                             "schedule" : "1 * * * *"
                         ]))
                        if let command = tgr.command {
                            XCTAssertEqual(command.targetID.toString(),
                                           expectedThingID.toString(),
                                           error_message)
                            XCTAssertEqual(command.issuerID.toString(),
                                           setting.owner.typedID.toString(),
                                           error_message)
                            XCTAssertEqual(command.schemaName, "name",
                                           error_message)
                            XCTAssertEqual(command.schemaVersion, 1,
                                           error_message)
                            for i in 0..<command.actions.count {
                                XCTAssertEqual(
                                  NSDictionary(
                                    dictionary: command.actions[i]),
                                  NSDictionary(dictionary: actions[i]),
                                  error_message)
                            }
                            XCTAssertEqual(command.title!, "command title",
                                           error_message)
                            XCTAssertEqual(command.commandDescription!,
                                           "command description",
                                           error_message)
                            XCTAssertEqual(
                              NSDictionary(dictionary: command.metadata!),
                              NSDictionary(dictionary: command_metadata),
                              error_message)
                        } else {
                            XCTFail(error_message)
                        }

                    } else {
                        XCTFail(error_message)
                    }
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
