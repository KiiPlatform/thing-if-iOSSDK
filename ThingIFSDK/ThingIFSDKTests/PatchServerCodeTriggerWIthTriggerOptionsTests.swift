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
      _ triggerID: String,
      serverCode: ServerCode,
      predicate: Predicate,
      options: TriggerOptions?) -> Dictionary<String, Any>
    {
        var retval: Dictionary<String, Any> = [
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
      _ serverCode: ServerCode? = nil,
      predicate: Predicate? = nil,
      options: TriggerOptions? = nil) -> Dictionary<String, Any>
    {
        var retval: Dictionary<String, Any> = [
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

            sharedMockMultipleSession.responsePairs = [
              (
                (data: try! JSONSerialization.data(
                   withJSONObject: ["triggerID", "triggerID"],
                   options: .prettyPrinted),
                 urlResponse: HTTPURLResponse(
                   url: URL(string:setting.app.baseURL)!,
                   statusCode: 200,
                   httpVersion: nil,
                   headerFields: nil)!,
                 error: nil),
                { (request) in
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
                    XCTAssertEqual(
                      NSDictionary(
                        dictionary: try! JSONSerialization.jsonObject(
                         with: request.httpBody!,
                         options: .mutableContainers)
                          as! Dictionary<String, Any>),
                      NSDictionary(dictionary: self.expectedRequestBody(
                                     serverCode,
                                     predicate: predicate,
                                     options: options)),
                      error_message)
                }
              ),
              (
                (data: try! JSONSerialization.data(
                   withJSONObject: NSDictionary(dictionary: self.getResonseData(
                                  "triggerID",
                                  serverCode: serverCode,
                                  predicate: predicate,
                                  options: options)),
                   options: .prettyPrinted),
                 urlResponse: HTTPURLResponse(
                   url: URL(string:setting.app.baseURL)!,
                   statusCode: 200,
                   httpVersion: nil,
                   headerFields: nil)!,
                 error: nil),
                { (request) in
                    XCTAssertEqual(request.httpMethod, "GET")

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
            self.waitForExpectations(timeout: TEST_TIMEOUT)
            { (error) -> Void in
                if error != nil {
                    XCTFail("execution timeout for \(error_message)")
                }
            }
        }
    }


    func testServerCodeAndOption() {
        let metadata: Dictionary<String, Any> = [
          "key" : "value"
        ]
        let options = TriggerOptions(title: "title",
                                     triggerDescription: "trigger description",
                                     metadata: metadata)
        let serverCode =  ServerCode(endpoint: "my_function",
                                     executorAccessToken: "executorAccessToken",
                                     targetAppID: "targetAppID",
                                     parameters: ["param key" : "param value"])
        let predicate = SchedulePredicate(schedule: "1 * * * *")

        let setting = TestSetting()
        setting.api._target = setting.target


        weak var expectation : XCTestExpectation!
        defer {
            expectation = nil
        }
        expectation = self.expectation(description: "error")

        sharedMockMultipleSession.responsePairs = [
          (
            (data: try! JSONSerialization.data(
               withJSONObject: ["triggerID", "triggerID"],
               options: .prettyPrinted),
             urlResponse: HTTPURLResponse(
               url: URL(string:setting.app.baseURL)!,
               statusCode: 200,
               httpVersion: nil,
               headerFields: nil)!,
             error: nil),
            { (request) in
                XCTAssertEqual(request.httpMethod, "PATCH")

                let requestHeaders = request.allHTTPHeaderFields!;
                // verify request header.
                XCTAssertEqual(
                  requestHeaders,
                  [
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json",
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader!
                  ]);
                XCTAssertEqual(
                  request.url?.absoluteString,
                  setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID")
                XCTAssertEqual(
                  NSDictionary(
                    dictionary: try! JSONSerialization.jsonObject(
                      with: request.httpBody!,
                      options: .mutableContainers)
                      as! Dictionary<String, Any>),
                  NSDictionary(dictionary: self.expectedRequestBody(
                                 serverCode,
                                 options: options)))
            }
          ),
          (
            (data: try! JSONSerialization.data(
               withJSONObject: NSDictionary(dictionary: self.getResonseData(
                              "triggerID",
                              serverCode: serverCode,
                              predicate: predicate,
                              options: options)),
               options: .prettyPrinted),
             urlResponse: HTTPURLResponse(
               url: URL(string:setting.app.baseURL)!,
               statusCode: 200,
               httpVersion: nil,
               headerFields: nil)!,
             error: nil),
            { (request) in
                XCTAssertEqual(request.httpMethod, "GET")

                let requestHeaders = request.allHTTPHeaderFields!;
                // verify request header.
                XCTAssertEqual(
                  requestHeaders,
                  [
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json",
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader!
                  ]);
                XCTAssertEqual(
                  request.url?.absoluteString,
                  setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID")
            }
          )
        ]
        iotSession = MockMultipleSession.self
        setting.api.patchTrigger(
          "triggerID",
          serverCode: serverCode,
          options: options,
          completionHandler: {
              (trigger, error) -> Void in

              XCTAssertEqual(trigger?.triggerID, "triggerID")
              XCTAssertEqual(trigger?.targetID.toString(),
                             setting.target.typedID.toString())
              XCTAssertEqual(trigger?.enabled, Bool(true))
              XCTAssertEqual(trigger?.predicate.toNSDictionary(),
                             predicate.toNSDictionary())
              XCTAssertNil(trigger?.command)
              XCTAssertEqual(trigger?.serverCode!.toNSDictionary(),
                             serverCode.toNSDictionary())
              XCTAssertEqual(trigger?.title, options.title)
              XCTAssertEqual(trigger?.triggerDescription,
                             options.triggerDescription)
              if let expectedMetadata = options.metadata {
                  XCTAssertEqual(
                    NSDictionary(dictionary: (trigger?.metadata!)!),
                    NSDictionary(dictionary: expectedMetadata))
              } else {
                  XCTAssertNil(trigger?.metadata)
              }
              expectation.fulfill()
          })
        self.waitForExpectations(timeout: TEST_TIMEOUT)
        { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testPredicateAndOption() {
        let metadata: Dictionary<String, Any> = [
          "key" : "value"
        ]
        let options = TriggerOptions(title: "title",
                                     triggerDescription: "trigger description",
                                     metadata: metadata)
        let serverCode =  ServerCode(endpoint: "my_function",
                                     executorAccessToken: "executorAccessToken",
                                     targetAppID: "targetAppID",
                                     parameters: ["param key" : "param value"])
        let predicate = SchedulePredicate(schedule: "1 * * * *")

        let setting = TestSetting()
        setting.api._target = setting.target

        weak var expectation : XCTestExpectation!
        defer {
            expectation = nil
        }
        expectation = self.expectation(description: "error")

        sharedMockMultipleSession.responsePairs = [
          (
            (data: try! JSONSerialization.data(
               withJSONObject: ["triggerID", "triggerID"],
               options: .prettyPrinted),
             urlResponse: HTTPURLResponse(
               url: URL(string:setting.app.baseURL)!,
               statusCode: 200,
               httpVersion: nil,
               headerFields: nil)!,
             error: nil),
            { (request) in
                XCTAssertEqual(request.httpMethod, "PATCH")

                let requestHeaders = request.allHTTPHeaderFields!;
                // verify request header.
                XCTAssertEqual(
                  requestHeaders,
                  [
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json",
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader!
                  ]);
                XCTAssertEqual(
                  request.url?.absoluteString,
                  setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID")
                XCTAssertEqual(
                  NSDictionary(
                    dictionary: try! JSONSerialization.jsonObject(
                      with: request.httpBody!,
                      options: .mutableContainers)
                      as! Dictionary<String, Any>),
                  NSDictionary(dictionary: self.expectedRequestBody(
                    predicate: predicate,
                                 options: options)))
            }
          ),
          (
            (data: try! JSONSerialization.data(
               withJSONObject: NSDictionary(dictionary: self.getResonseData(
                              "triggerID",
                              serverCode: serverCode,
                              predicate: predicate,
                              options: options)),
               options: .prettyPrinted),
             urlResponse: HTTPURLResponse(
               url: URL(string:setting.app.baseURL)!,
               statusCode: 200,
               httpVersion: nil,
               headerFields: nil)!,
             error: nil),
            { (request) in
                XCTAssertEqual(request.httpMethod, "GET")

                let requestHeaders = request.allHTTPHeaderFields!;
                // verify request header.
                XCTAssertEqual(
                  requestHeaders,
                  [
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json",
                    "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader!
                  ]);
                XCTAssertEqual(
                  request.url?.absoluteString,
                  setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID")
            }
          )
        ]
        iotSession = MockMultipleSession.self
        setting.api.patchTrigger(
          "triggerID",
          serverCode: nil,
          predicate: predicate,
          options: options,
          completionHandler: {
              (trigger, error) -> Void in

              XCTAssertEqual(trigger?.triggerID, "triggerID")
              XCTAssertEqual(trigger?.targetID.toString(),
                             setting.target.typedID.toString())
              XCTAssertEqual(trigger?.enabled, Bool(true))
              XCTAssertEqual(trigger?.predicate.toNSDictionary(),
                             predicate.toNSDictionary())
              XCTAssertNil(trigger?.command)
              XCTAssertEqual(trigger?.serverCode!.toNSDictionary(),
                             serverCode.toNSDictionary())
              XCTAssertEqual(trigger?.title, options.title)
              XCTAssertEqual(trigger?.triggerDescription,
                             options.triggerDescription)
              if let expectedMetadata = options.metadata {
                  XCTAssertEqual(
                    NSDictionary(dictionary: (trigger?.metadata!)!),
                    NSDictionary(dictionary: expectedMetadata))
              } else {
                  XCTAssertNil(trigger?.metadata)
              }
              expectation.fulfill()
          })
        self.waitForExpectations(timeout: TEST_TIMEOUT)
        { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testNoOptionalArgument() {
        let setting = TestSetting()
        setting.api._target = setting.target
        var executed: Bool = false;

        setting.api.patchTrigger(
          "triggerID",
          serverCode: nil,
          predicate: nil,
          options: nil,
          completionHandler: {
              (trigger, error) -> Void in
              switch(error!) {
              case ThingIFError.unsupportedError:
                  break
              default:
                  XCTFail("invalid error")
                  break
              }

              executed = true;
          })
        XCTAssertTrue(executed)
    }
}
