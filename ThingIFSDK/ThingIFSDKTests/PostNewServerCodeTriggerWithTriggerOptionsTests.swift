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
      _ serverCode: ServerCode,
      predicate: Predicate,
      options: TriggerOptions?) -> Dictionary<String, Any>
    {
        var retval: Dictionary<String, Any> =
          [
            "serverCode" : serverCode.toNSDictionary(),
            "predicate" : predicate.toNSDictionary(),
            "triggersWhat": TriggersWhat.serverCode.rawValue
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
        let metadata: Dictionary<String, Any> = [
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
            self.waitForExpectations(timeout: TEST_TIMEOUT)
            { (error) -> Void in
                if error != nil {
                    XCTFail("execution timeout for \(error_message)")
                }
            }
        }
    }
}
