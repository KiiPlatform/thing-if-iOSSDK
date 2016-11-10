//
//  PostNewTriggerForScheduleTests.swift
//  ThingIFSDK
//
//  Created on 2016/05/12.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

protocol RequestVerifier: class {
    var verifier: ((URLRequest) -> Void) { get }
    var tag: String { get }
}

class TriggerRequestVerifier: NSObject, RequestVerifier {
    private let expectedHeader: Dictionary<String, String>
    private let expectedBody: Dictionary<String, Any>
    private let url: String
    let tag: String

    init (expectedHeader: Dictionary<String, String>,
          expectedBody: Dictionary<String, Any>,
          url: String,
          tag: String) {
        self.expectedHeader = expectedHeader
        self.expectedBody = expectedBody
        self.url = url
        self.tag = tag
    }

    var verifier: ((URLRequest) -> Void) {
        get {
            return { (request) in
                       // verify request method.
                       XCTAssertEqual(request.httpMethod, "POST")

                       let requestHeaders = request.allHTTPHeaderFields!;
                       // verify request header.
                       XCTAssertEqual(self.expectedHeader,
                                      requestHeaders,
                                      self.tag);

                       // verify request body.
                       let actualBody =
                           try! JSONSerialization.jsonObject(
                               with: request.httpBody!,
                               options: .mutableContainers)
                           as! Dictionary<String, Any>
                       XCTAssertEqual(
                           NSDictionary(dictionary: self.expectedBody),
                           NSDictionary(dictionary:actualBody),
                           self.tag)

                       // verify URL.
                       XCTAssertEqual(request.url!.absoluteString,
                                      self.url,
                                      self.tag);
                   }
        }
    }

}

protocol CallbackVerifier: class {
    var verifier: ((Trigger?, ThingIFError?) -> Void) { get }
    var tag: String { get }
}

class TriggerSuccessCallbackVerifier: NSObject, CallbackVerifier {
    let triggerID: String
    let enabled: Bool
    let predicate: Predicate
    let commandID: String
    let tag: String

    var verifier: ((Trigger?, ThingIFError?) -> Void) {
        get {
            return { (trigger, error) in
                       if error == nil {
                           XCTAssertEqual(trigger!.triggerID,
                                          self.triggerID,
                                          self.tag)
                           XCTAssertEqual(trigger!.enabled,
                                          self.enabled,
                                          self.tag)
                           XCTAssertEqual(trigger!.predicate.toNSDictionary(),
                                          self.predicate.toNSDictionary(),
                                          self.tag)
                           XCTAssertEqual(trigger!.command!.commandID,
                                          self.commandID,
                                          self.tag)
                       } else {
                           XCTFail(self.tag)
                       }
                   }
        }
    }

    init(triggerID: String,
         enabled: Bool,
         predicate: Predicate,
         commandID: String,
         tag:String) {
        self.triggerID = triggerID
        self.enabled = enabled
        self.predicate = predicate
        self.commandID = commandID
        self.tag = tag
    }
}

class WrongFormatCallbackVerifier: CallbackVerifier {
    let tag: String
    var verifier: ((Trigger?, ThingIFError?) -> Void) {
        get {
            return { (trigger, error) in
                       switch error! {
                       case .connection:
                           XCTFail(self.tag + ": should not be connection")
                       case .errorResponse(let actualErrorResponse):
                           XCTAssertEqual(400,
                                          actualErrorResponse.httpStatusCode,
                                          self.tag)
                       default:
                           XCTFail(self.tag)
                       }
                   }
        }
    }

    init(tag: String) {
        self.tag = tag
    }
}

struct Verifier {
    let requestVerifier: RequestVerifier
    let callbackVerifier: CallbackVerifier
}

struct Parameter {
    let schemaName: String
    let schemaVersion: Int
    let actions: [Dictionary<String, Any>]
    let predicate: Predicate
}

struct TestCase {
    let parameter: Parameter
    let verifier: Verifier
    let mockResponse: MockResponse
}

class PostNewTriggerForScheduleTests: SmallTestBase {

    static func createSuccessTestCase(
        _ predicate: Predicate,
        actions: [Dictionary<String, Any>],
        tag: String,
        setting: TestSetting) -> TestCase
    {
        return PostNewTriggerForScheduleTests.createTestCase(
                predicate,
                actions:actions,
                callbackVerifier: TriggerSuccessCallbackVerifier(
                                    triggerID: "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
                                    enabled: Bool(true),
                                    predicate: predicate,
                                    commandID:"",
                                    tag: tag),
                mockResponse: MockResponse(
                                try! JSONSerialization.data(
                                    withJSONObject: ["triggerID": "0267251d9d60-1858-5e11-3dc3-00f3f0b5"],
                                    options: .prettyPrinted),
                                urlResponse: HTTPURLResponse(
                                               url: URL(string:setting.app.baseURL)!,
                                               statusCode: 201,
                                               httpVersion: nil,
                                               headerFields: nil)!,
                                error: nil),
                tag: tag,
                setting:setting)
    }

    static func createTestCase(
        _ predicate: Predicate,
        actions: [Dictionary<String, Any>],
        callbackVerifier: CallbackVerifier,
        mockResponse: MockResponse,
        tag: String,
        setting: TestSetting) -> TestCase
    {
        return TestCase(
                parameter: Parameter(
                             schemaName:setting.schema,
                             schemaVersion: setting.schemaVersion,
                             actions:actions,
                             predicate: predicate),
                verifier: Verifier(
                            requestVerifier: TriggerRequestVerifier(
                                               expectedHeader: [
                                                     "Authorization": "Bearer \(setting.owner.accessToken)",
                                                     "Content-Type": "application/json",
                                                     "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader!
                                                 ],
                                               expectedBody: [
                                                   "predicate": predicate.toNSDictionary() as Dictionary,
                                                   "command": [
                                                       "actions": actions,
                                                       "schema": setting.schema,
                                                       "schemaVersion": setting.schemaVersion,
                                                       "issuer": setting.owner.typedID.toString(),
                                                       "target": setting.target.typedID.toString()
                                                   ],
                                                   "triggersWhat": "COMMAND"
                                               ],
                                               url: setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers",
                                               tag: tag),
                            callbackVerifier: callbackVerifier),
                mockResponse: mockResponse)
    }

    static func createTestCases(
            _ predicates: [Predicate],
            setting: TestSetting) -> [TestCase]
    {
        var retval: [TestCase] = []
        let actions: [Dictionary<String, Any>] =
            [
                ["turnPower":["power":true]],
                ["setBrightness":["bribhtness":90]]
            ]

        for (index, predicate) in predicates.enumerated() {
            retval.append(PostNewTriggerForScheduleTests.createSuccessTestCase(
                              predicate,
                              actions: actions,
                              tag: "testPostNewTrigger_success_\(index)",
                              setting: setting))
        }
        return retval;
    }

    func postNewTrigger(_ testCase: TestCase, setting: TestSetting) {
        weak var expectation : XCTestExpectation!
        defer {
            expectation = nil
        }
        expectation = self.expectation(
                          description: testCase.verifier.requestVerifier.tag)

        sharedMockSession.requestVerifier =
            testCase.verifier.requestVerifier.verifier
        sharedMockSession.mockResponse = testCase.mockResponse
        iotSession = MockSession.self

        setting.api._target = setting.target

        setting.api.postNewTrigger(
            testCase.parameter.schemaName,
            schemaVersion: testCase.parameter.schemaVersion,
            actions: testCase.parameter.actions,
            predicate: testCase.parameter.predicate,
            completionHandler: { (trigger, error) -> Void in
                testCase.verifier.callbackVerifier.verifier(trigger, error)
                expectation.fulfill()
            })
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(testCase.verifier.requestVerifier.tag)")
            }
        }
    }

    func testPostNewTrigger_success() {
        let setting = TestSetting()

        let predicates: [Predicate] = [
            SchedulePredicate(schedule: "1 * * * *"),
            SchedulePredicate(schedule: "1 1 * * *"),
            SchedulePredicate(schedule: "1 1 1 * *"),
            SchedulePredicate(schedule: "1 1 1 1 *"),
            SchedulePredicate(schedule: "1 1 1 1 1")
        ]

        let testCases: [TestCase] =
            PostNewTriggerForScheduleTests.createTestCases(
                predicates,
                setting:setting)

        for testCase in testCases {
            postNewTrigger(testCase, setting: setting)
        }
    }

    func testPostNewTrigger_wrongScheduleString() {
        let setting = TestSetting()

        let predicate = SchedulePredicate(schedule: "wrong format")
        let actions: [Dictionary<String, Any>] =
            [
                ["turnPower":["power":true]],
                ["setBrightness":["bribhtness":90]]
            ]

        postNewTrigger(
            PostNewTriggerForScheduleTests.createTestCase(
                predicate,
                actions: actions,
                callbackVerifier: WrongFormatCallbackVerifier(tag: "wrong format test"),
                mockResponse: MockResponse(
                                nil,
                                urlResponse:HTTPURLResponse(
                                               url: URL(string: setting.app.baseURL)!,
                                               statusCode: 400,
                                               httpVersion: nil,
                                               headerFields: nil),
                                error: nil),
                tag: "wrong format test",
                setting: setting),
            setting:setting)
    }

}
