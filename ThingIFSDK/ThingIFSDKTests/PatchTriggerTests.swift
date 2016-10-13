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

        let schemaName: String?
        let schemaVersion: Int?
        let actions: [Dictionary<String, AnyObject>]?

        let predicate: Predicate?
        let expectedStatementDict: Dictionary<String, AnyObject>?
        let expectedTriggersWhenString: String?
        let success: Bool

        func getExpectedCommandDict() -> Dictionary<String, AnyObject>? {

            if schemaName == nil && schemaVersion == nil && actions == nil {
                return nil
            }

            var commandDict: Dictionary<String, AnyObject> = ["issuer":issuerID.toString()]
            if schemaName != nil {
                commandDict["schema"] = schemaName!
            }
            if schemaVersion != nil {
                commandDict["schemaVersion"] = schemaVersion!
            }
            if actions != nil {
                commandDict["actions"] = actions!
            }
            commandDict["target"] = target.typedID.toString()
            return commandDict
        }

        func hasPredicateDict() -> Bool {
            return predicate != nil
        }

        func getExpectedPredictDict() -> Dictionary<String, AnyObject>? {
            if predicate == nil {
                return nil
            }
            return predicate?.toNSDictionary() as? Dictionary<String, AnyObject>
        }
    }

    func testPatchTrigger() {

        let expectedActions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api._target = setting.target

        let testsCases: [TestCase] = [
            //
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: StatePredicate(condition: Condition(clause: EqualsClause(field: "color", intValue: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type":"eq","field":"color", "value": 0], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: StatePredicate(condition: Condition(clause: NotEqualsClause(field: "power", boolValue: true)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: nil, schemaVersion: nil, actions: nil, predicate: StatePredicate(condition: Condition(clause: RangeClause(field: "color", upperLimitInt: 255, upperIncluded:true)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: ScheduleOncePredicate(scheduleAt: NSDate(timeIntervalSinceNow: 1000)), expectedStatementDict: ["type":"eq","field":"color", "value": 0], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            TestCase(target: target, issuerID: owner.typedID, schemaName: nil, schemaVersion: schemaVersion, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: nil, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            TestCase(target: target, issuerID: owner.typedID, schemaName: schema, schemaVersion: schemaVersion, actions: nil, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            
        ]
        for (index,testCase) in testsCases.enumerate() {
            patchTrigger("testPatchTrigger_\(index)", testcase: testCase)
        }
    }

    func patchTrigger(tag: String, testcase: TestCase) {
        let expectation : XCTestExpectation! = self.expectationWithDescription(tag)
        
        let setting = TestSetting()
        let api = setting.api

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify patch request
        var expectedBodyDict = Dictionary<String, AnyObject>()
        expectedBodyDict["triggersWhat"] = "COMMAND"
        if let expectedCommandDict = testcase.getExpectedCommandDict(){
            expectedBodyDict["command"] = expectedCommandDict
        }
        if let expectedPredicateDict = testcase.getExpectedPredictDict() {
            expectedBodyDict["predicate"] = expectedPredicateDict
        }
        let patchRequestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PATCH")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
            }
            //verify body
            do {
                XCTAssertEqual(expectedBodyDict,
                               NSDictionary(
                                 dictionary: try! NSJSONSerialization.JSONObjectWithData(
                                   request.HTTPBody!,
                                   options: .MutableContainers)
                                   as! Dictionary<String, AnyObject>),
                               tag)

            }catch(_){
                XCTFail(tag)
            }
            XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
        }

        //verify get request
        let getRequestVerifier: ((NSURLRequest) -> Void) = {(request) in}

        // mock patch success response
        let mockResponse1 = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 204, HTTPVersion: nil, headerFields: nil)
        // mock get response
        let commandDict = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]]
        let dict = ["triggerID": expectedTriggerID, "predicate": ["eventSource":"STATES", "triggersWhen":"CONDITION_FALSE_TO_TRUE", "condition": ["type":"eq","field":"color", "value": 0]], "command": commandDict, "disabled": false]
        var jsonData: NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
        }catch(_){
            XCTFail(tag)
        }
        let mockResponse2 = NSHTTPURLResponse(URL: NSURL(string: setting.app.baseURL)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

        // mock patch 400 error response
        let mockResponse3 = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 400, HTTPVersion: nil, headerFields: nil)

        if testcase.success {
            iotSession = MockMultipleSession.self
            sharedMockMultipleSession.responsePairs = [
                ((data: nil, urlResponse: mockResponse1, error: nil),patchRequestVerifier),
                ((data: jsonData!, urlResponse: mockResponse2, error: nil),getRequestVerifier)
            ]
        }else {
            do {
                jsonData = try NSJSONSerialization.dataWithJSONObject(["errorCode" : "WRONG_COMMAND","message" : "Schema is required"], options: .PrettyPrinted)
            }catch(_){
                XCTFail(tag)
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: mockResponse3, error: nil)
            sharedMockSession.requestVerifier = patchRequestVerifier
            iotSession = MockSession.self
        }


        api._target = setting.target
        api.patchTrigger(expectedTriggerID, schemaName: testcase.schemaName, schemaVersion: testcase.schemaVersion, actions: testcase.actions, predicate: testcase.predicate, completionHandler: { (trigger, error) -> Void in
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
                    case .CONNECTION:
                        XCTFail("should not be connection error for \(tag)")
                    case .ERROR_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(400, actualErrorResponse.httpStatusCode, tag)
                    default:
                        break
                    }
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPatchTrigger_target_not_available_error() {
        let expectation : XCTestExpectation! = self.expectationWithDescription("testPatchTrigger_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", intValue: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

        api.patchTrigger(expectedTriggerID, schemaName: nil, schemaVersion: nil, actions: nil, predicate: predicate) { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
