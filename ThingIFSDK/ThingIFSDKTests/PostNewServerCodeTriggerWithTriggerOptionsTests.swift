//
//  PostNewServerCodeTriggerWithTriggerOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/07.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewServerCodeTriggerWithTriggerOptionsTests: SmallTestBase {

    private func createSuccessRequestBody(
      serverCode: ServerCode,
      predicate: Predicate,
      options: TriggerOptions?) -> Dictionary<String, AnyObject>
    {
        var retval: Dictionary<String, AnyObject> =
          [
            "serverCode" : serverCode.toNSDictionary(),
            "predicate" : predicate.toNSDictionary(),
            "triggersWhat": TriggersWhat.SERVER_CODE.rawValue
          ]
        if let triggerOptions = options {
            if let title = triggerOptions.title {
                retval["title"] = title
            }
            if let description = triggerOptions.triggerDescription {
                retval["description"] = description
            }
            if let metadata = triggerOptions.metadata {
                retval["metadata"] = metadata
            }
        }
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
                      serverCode,
                      predicate: predicate,
                      options: options)),
                  error_message)
            }
            iotSession = MockSession.self

            setting.api.postNewTrigger(
                serverCode,
                predicate: predicate,
                options: options,
              completionHandler: {
                  (trigger, error) -> Void in
                  if let actual = trigger {
                      XCTAssertEqual(actual.triggerID, "triggerID",
                                     error_message)
                      XCTAssertEqual(actual.targetID.toString(),
                                     setting.target.typedID.toString(),
                                     error_message)
                      XCTAssertEqual(actual.enabled, Bool(true), error_message)
                      XCTAssertEqual(actual.predicate.toNSDictionary(),
                                     predicate.toNSDictionary(),
                                     error_message)
                      XCTAssertNil(actual.command, error_message)
                      XCTAssertEqual(actual.serverCode!.toNSDictionary(),
                                     serverCode.toNSDictionary(),
                                     error_message)
                      if let expectedOptions = options {
                          XCTAssertEqual(actual.title, expectedOptions.title,
                                         error_message)
                          XCTAssertEqual(actual.triggerDescription,
                                         expectedOptions.triggerDescription,
                                         error_message)
                          if let expectedMetadata = expectedOptions.metadata {
                              XCTAssertEqual(
                                NSDictionary(dictionary: actual.metadata!),
                                NSDictionary(dictionary: expectedMetadata),
                                error_message)
                          } else {
                              XCTAssertNil(actual.metadata)
                          }
                      } else {
                          XCTAssertNil(actual.title)
                          XCTAssertNil(actual.triggerDescription)
                          XCTAssertNil(actual.metadata)
                      }
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
