//
//  PatchTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PatchTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    struct TestCase {
        let target: Target
        let issuerID: TypedID

        let schemaName: String
        let schemaVersion: Int
        let actions: [Dictionary<String, Any>]

        let predicate: Predicate?
        let expectedStatementDict: Dictionary<String, Any>?
        let expectedTriggersWhenString: String?
        let success: Bool

        func getExpectedCommandDict() -> Dictionary<String, Any>? {

            var commandDict: Dictionary<String, Any> = ["issuer":issuerID.toString()]
            commandDict["schema"] = schemaName
            commandDict["schemaVersion"] = schemaVersion
            commandDict["actions"] = actions
            commandDict["target"] = target.typedID.toString()
            return commandDict
        }

        func hasPredicateDict() -> Bool {
            return predicate != nil
        }

        func getExpectedPredictDict() -> Dictionary<String, Any>? {
            if predicate == nil {
                return nil
            }
            return predicate?.makeDictionary()
        }
    }

    func testPatchTrigger() {

        let expectedActions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api.target = setting.target

        let testsCases: [TestCase] = [
            //
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: StatePredicate(condition: Condition(clause: EqualsClause(field: "color", intValue: 0)), triggersWhen: TriggersWhen.conditionFalseToTrue), expectedStatementDict: ["type":"eq","field":"color", "value": 0], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: StatePredicate(condition: Condition(clause: NotEqualsClause(field: "power", boolValue: true)), triggersWhen: TriggersWhen.conditionFalseToTrue), expectedStatementDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: ScheduleOncePredicate(scheduleAt: Date(timeIntervalSinceNow: 1000)), expectedStatementDict: ["type":"eq","field":"color", "value": 0], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
        ]
        for (index,testCase) in testsCases.enumerated() {
            patchTrigger("testPatchTrigger_\(index)", testcase: testCase)
        }
    }

    func patchTrigger(_ tag: String, testcase: TestCase) {
        let expectation : XCTestExpectation! = self.expectation(description: tag)
        
        let setting = TestSetting()
        let api = setting.api

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify patch request
        var expectedBodyDict = Dictionary<String, Any>()
        expectedBodyDict["triggersWhat"] = "COMMAND"
        if let expectedCommandDict = testcase.getExpectedCommandDict(){
            expectedBodyDict["command"] = expectedCommandDict
        }
        if let expectedPredicateDict = testcase.getExpectedPredictDict() {
            expectedBodyDict["predicate"] = expectedPredicateDict
        }
        let patchRequestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PATCH")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key), tag)
            }
            //verify body
            self.verifyDict(expectedBodyDict,
                           actualDict: try! JSONSerialization.jsonObject(
                             with: request.httpBody!,
                             options: .mutableContainers) as! [String : Any],
                           errorMessage: tag)

            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
        }

        //verify get request
        let getRequestVerifier: ((URLRequest) -> Void) = {(request) in}

        // mock patch success response
        let mockResponse1 = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: nil)
        // mock get response
        let commandDict: [String : Any] = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]]
        let dict: [String : Any] = ["triggerID": expectedTriggerID, "predicate": ["eventSource":"STATES", "triggersWhen":"CONDITION_FALSE_TO_TRUE", "condition": ["type":"eq","field":"color", "value": 0]], "command": commandDict, "disabled": false]
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }catch(_){
            XCTFail(tag)
        }
        let mockResponse2 = HTTPURLResponse(url: URL(string: setting.app.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)

        // mock patch 400 error response
        let mockResponse3 = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 400, httpVersion: nil, headerFields: nil)

        if testcase.success {
            iotSession = MockMultipleSession.self
            sharedMockMultipleSession.responsePairs = [
                ((data: nil, urlResponse: mockResponse1, error: nil),patchRequestVerifier),
                ((data: jsonData!, urlResponse: mockResponse2, error: nil),getRequestVerifier)
            ]
        }else {
            do {
                jsonData = try JSONSerialization.data(withJSONObject: ["errorCode" : "WRONG_COMMAND","message" : "Schema is required"], options: .prettyPrinted)
            }catch(_){
                XCTFail(tag)
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: mockResponse3, error: nil)
            sharedMockSession.requestVerifier = patchRequestVerifier
            iotSession = MockSession.self
        }


        api.target = setting.target
        api.patchTrigger(
          expectedTriggerID,
          triggeredCommandForm: TriggeredCommandForm(
            schemaName: testcase.schemaName,
            schemaVersion: testcase.schemaVersion,
            actions: testcase.actions),
          predicate: testcase.predicate,
          completionHandler: { (trigger, error) -> Void in
            if testcase.success {
                if error == nil{
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                    XCTAssertEqual(trigger!.enabled, true, tag)
                    XCTAssertNotNil(trigger!.predicate, tag)
                    XCTAssertEqual(trigger!.command!.commandID, "", tag)
                }else {
                    XCTFail("should success for \(tag)")
                }
            }else {
                if error == nil{
                    XCTFail("should fail for \(tag)")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error for \(tag)")
                    case .errorResponse(let actualErrorResponse):
                        XCTAssertEqual(400, actualErrorResponse.httpStatusCode, tag)
                    default:
                        break
                    }
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPatchTrigger_target_not_available_error() {
        let expectation : XCTestExpectation! = self.expectation(description: "testPatchTrigger_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.patchTrigger(
          expectedTriggerID,
          triggeredCommandForm: nil,
          predicate: nil) { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .targetNotAvailable:
                    break
                default:
                    XCTFail("should be targetNotAvailable")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testPatchTrigger_unsupportedError() {
        let expectation : XCTestExpectation! = self.expectation(description: "testPatchTrigger_unsupportedError")
        let setting = TestSetting()
        let api = setting.api

        api.target = setting.target

        api.patchTrigger(
          "0267251d9d60-1858-5e11-3dc3-00f3f0b5",
          triggeredCommandForm: nil,
          predicate: nil) { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .unsupportedError:
                    break
                default:
                    XCTFail("should be unsupportedError")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
