//
//  PatchServerCodeTriggeWIthTriggerOptions.swift
//  ThingIFSDK
//
//  Created on 2016/10/07.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PatchServerCodeTriggeWIthTriggerOptions: SmallTestBase {

    private func getResonseData(
      triggerID: String,
      serverCode: ServerCode,
      predicate: Predicate,
      options: TriggerOptions?) -> Dictionary<String, AnyObject>
    {
        var retval: Dictionary<String, AnyObject> = [
          "triggerID" : triggerID,
          "triggersWhat" : "SERVER_CODE",
          "serverCode" : serverCode.toNSDictionary(),
          "predicate" : predicate.toNSDictionary(),
          "disabled" : false
        ]
        retval["title"] = options?.title
        retval["description"] = options?.triggerDescription
        retval["metadata"] = options?.metadata
        return retval;
    }

    private func expectedRequestBody(
      serverCode: ServerCode?,
      predicate: Predicate?,
      options: TriggerOptions?) -> Dictionary<String, AnyObject>
    {
        var retval: Dictionary<String, AnyObject> = [
          "triggersWhat" : "SERVER_CODE"
        ]
        retval["serverCode"] = serverCode?.toNSDictionary()
        retval["predicate"] = predicate?.toNSDictionary()
        retval["title"] = options?.title
        retval["description"] = options?.triggerDescription
        retval["metadata"] = options?.metadata
        return retval;
    }

    func testSuccess() {
        let metadata: Dictionary<String, AnyObject> = [
          "key" : "value"
        ]
        let optionsArray: [TriggerOptions?] = [
          nil,
          TriggerOptions(),
          TriggerOptions(title: "title"),
          TriggerOptions(triggerDescription: "trigger description"),
          TriggerOptions(metadata: metadata),
          TriggerOptions(
            title: "title",
            triggerDescription: "trigger description"),
          TriggerOptions(
            title: "title",
            metadata: metadata),
          TriggerOptions(
            title: "title",
            triggerDescription: "trigger description",
            metadata: metadata),
          TriggerOptions(
            triggerDescription: "trigger description",
            metadata: metadata)
        ]

        let setting = TestSetting()
        setting.api._target = setting.target
        let serverCode =  ServerCode(endpoint: "my_function",
                                     executorAccessToken: "executorAccessToken",
                                     targetAppID: "targetAppID",
                                     parameters: [
                                       "param key" : "param value"
                                     ])
        let predicate = SchedulePredicate(schedule: "1 * * * *")

        for options_index in 0..<optionsArray.count {
            let options: TriggerOptions? = optionsArray[options_index]
            let error_message = "options: \(options_index)"

            weak var expectation : XCTestExpectation!
            defer {
                expectation = nil
            }
            expectation = self.expectationWithDescription(error_message)

            sharedMockMultipleSession.responsePairs = [
              (
                (data: try! NSJSONSerialization.dataWithJSONObject(
                   ["triggerID", "triggerID"],
                   options: .PrettyPrinted),
                 urlResponse: NSHTTPURLResponse(
                   URL: NSURL(string:setting.app.baseURL)!,
                   statusCode: 200,
                   HTTPVersion: nil,
                   headerFields: nil)!,
                 error: nil),
                { (request) in
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
                    XCTAssertEqual(
                      NSDictionary(
                        dictionary: try! NSJSONSerialization.JSONObjectWithData(
                         request.HTTPBody!,
                         options: .MutableContainers)
                          as! Dictionary<String, AnyObject>),
                      NSDictionary(dictionary: self.expectedRequestBody(
                                     serverCode,
                                     predicate: predicate,
                                     options: options)),
                      error_message)
                }
              ),
              (
                (data: try! NSJSONSerialization.dataWithJSONObject(
                   NSDictionary(dictionary: self.getResonseData(
                                  "triggerID",
                                  serverCode: serverCode,
                                  predicate: predicate,
                                  options: options)),
                   options: .PrettyPrinted),
                 urlResponse: NSHTTPURLResponse(
                   URL: NSURL(string:setting.app.baseURL)!,
                   statusCode: 200,
                   HTTPVersion: nil,
                   headerFields: nil)!,
                 error: nil),
                { (request) in
                    XCTAssertEqual(request.HTTPMethod, "GET")

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
                }
              )
            ]
            iotSession = MockMultipleSession.self
            setting.api.patchTrigger(
              "triggerID",
              serverCode: serverCode,
              predicate: predicate,
              options: options,
              completionHandler: {
                  (trigger, error) -> Void in

                  XCTAssertEqual(trigger?.triggerID, "triggerID", error_message)
                  XCTAssertEqual(trigger?.targetID.toString(),
                                 setting.target.typedID.toString(),
                                 error_message)
                  XCTAssertEqual(trigger?.enabled, Bool(true), error_message)
                  XCTAssertEqual(trigger?.predicate.toNSDictionary(),
                                 predicate.toNSDictionary(),
                                 error_message)
                  XCTAssertNil(trigger?.command, error_message)
                  XCTAssertEqual(trigger?.serverCode!.toNSDictionary(),
                                 serverCode.toNSDictionary(),
                                 error_message)
                  XCTAssertEqual(trigger?.title, options?.title, error_message)
                  XCTAssertEqual(trigger?.triggerDescription,
                                 options?.triggerDescription,
                                 error_message)
                  if let expectedMetadata = options?.metadata {
                      XCTAssertEqual(
                        NSDictionary(dictionary: (trigger?.metadata!)!),
                        NSDictionary(dictionary: expectedMetadata),
                        error_message)
                  } else {
                      XCTAssertNil(trigger?.metadata)
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
