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
      serverCode: ServerCode? = nil,
      predicate: Predicate? = nil,
      options: TriggerOptions? = nil) -> Dictionary<String, AnyObject>
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


    func testServerCodeAndOption() {
        let metadata: Dictionary<String, AnyObject> = [
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
        expectation = self.expectationWithDescription("error")

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
                  ]);
                XCTAssertEqual(
                  request.URL?.absoluteString,
                  setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID")
                XCTAssertEqual(
                  NSDictionary(
                    dictionary: try! NSJSONSerialization.JSONObjectWithData(
                      request.HTTPBody!,
                      options: .MutableContainers)
                      as! Dictionary<String, AnyObject>),
                  NSDictionary(dictionary: self.expectedRequestBody(
                                 serverCode,
                                 options: options)))
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
                  ]);
                XCTAssertEqual(
                  request.URL?.absoluteString,
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
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT)
        { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testPredicateAndOption() {
        let metadata: Dictionary<String, AnyObject> = [
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
        expectation = self.expectationWithDescription("error")

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
                  ]);
                XCTAssertEqual(
                  request.URL?.absoluteString,
                  setting.app.baseURL + "/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/triggers/triggerID")
                XCTAssertEqual(
                  NSDictionary(
                    dictionary: try! NSJSONSerialization.JSONObjectWithData(
                      request.HTTPBody!,
                      options: .MutableContainers)
                      as! Dictionary<String, AnyObject>),
                  NSDictionary(dictionary: self.expectedRequestBody(
                    predicate: predicate,
                                 options: options)))
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
                  ]);
                XCTAssertEqual(
                  request.URL?.absoluteString,
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
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT)
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
              case ThingIFError.UNSUPPORTED_ERROR:
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
