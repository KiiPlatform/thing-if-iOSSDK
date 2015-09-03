//
//  PatchTriggerTests.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class PatchTriggerTests: XCTestCase {

    let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

    let schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)

    let baseURLString = "https://small-tests.internal.kii.com"

    var api: IoTCloudAPI!

    let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()
        api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://small-tests.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
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
            return commandDict
        }

        func hasPredicateDict() -> Bool {
            return predicate != nil
        }

        func getExpectedPredictDict() -> Dictionary<String, AnyObject>? {
            if predicate == nil {
                return nil
            }
            return ["eventSource":"states", "triggersWhen":expectedTriggersWhenString!, "condition":expectedStatementDict!]
        }
    }

    func testPatchTrigger() {

        let expectedActions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

        // perform onboarding
        api._target = target

        let testsCases: [TestCase] = [
            //
            TestCase(target: target, issuerID: owner.ownerID, schemaName: schema.name, schemaVersion: schema.version, actions: expectedActions, predicate: StatePredicate(condition: Condition(clause: EqualsClause(field: "color", value: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type":"eq","field":"color", "value": 0], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.ownerID, schemaName: schema.name, schemaVersion: schema.version, actions: expectedActions, predicate: StatePredicate(condition: Condition(clause: NotEqualsClause(field: "power", value: true)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.ownerID, schemaName: nil, schemaVersion: nil, actions: nil, predicate: StatePredicate(condition: Condition(clause: RangeClause(field: "color", upperLimit: 255, upperIncluded:true)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE", success: true),
            TestCase(target: target, issuerID: owner.ownerID, schemaName: schema.name, schemaVersion: schema.version, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            TestCase(target: target, issuerID: owner.ownerID, schemaName: nil, schemaVersion: schema.version, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            TestCase(target: target, issuerID: owner.ownerID, schemaName: schema.name, schemaVersion: nil, actions: expectedActions, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false),
            TestCase(target: target, issuerID: owner.ownerID, schemaName: schema.name, schemaVersion: schema.version, actions: nil, predicate: nil, expectedStatementDict: nil, expectedTriggersWhenString: nil, success: false)
        ]
        for (index,testCase) in testsCases.enumerate() {
            patchTrigger("testPatchTrigger_\(index)", testcase: testCase)
        }
    }

    func patchTrigger(tag: String, testcase: TestCase) {
        let expectation = self.expectationWithDescription(tag)

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify patch request
        var expectedBodyDict = Dictionary<String, AnyObject>()
        if let expectedCommandDict = testcase.getExpectedCommandDict(){
            expectedBodyDict["command"] = expectedCommandDict
        }
        if let expectedPredicateDict = testcase.getExpectedPredictDict() {
            expectedBodyDict["predicate"] = expectedPredicateDict
        }
        let patchRequestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PATCH")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
            }
            //verify body
            do {
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBodyDict, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
            }catch(_){
                XCTFail(tag)
            }
        }

        //verify get request
        let getRequestVerifier: ((NSURLRequest) -> Void) = {(request) in}

        // mock patch success response
        let mockResponse1 = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 204, HTTPVersion: nil, headerFields: nil)
        // mock get response
        let commandDict = ["schema": self.schema.name, "schemaVersion": self.schema.version, "target": self.target.targetType.toString(), "issuer": self.owner.ownerID.toString(), "actions": [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]]
        let dict = ["triggerID": expectedTriggerID, "predicate": ["eventSource":"states", "triggersWhen":"CONDITION_FALSE_TO_TRUE", "condition": ["type":"eq","field":"color", "value": 0]], "command": commandDict, "disabled": false]
        var jsonData: NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
        }catch(_){
            XCTFail(tag)
        }
        let mockResponse2 = NSHTTPURLResponse(URL: NSURL(string: self.baseURLString)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

        // mock patch 400 error response
        let mockResponse3 = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 400, HTTPVersion: nil, headerFields: nil)

        if testcase.success {
            iotSession = MockMultipleSession.self
            MockMultipleSession.responsePairs = [
                ((data: nil, urlResponse: mockResponse1, error: nil),patchRequestVerifier),
                ((data: jsonData!, urlResponse: mockResponse2, error: nil),getRequestVerifier)
            ]
        }else {
            do {
                jsonData = try NSJSONSerialization.dataWithJSONObject(["errorCode" : "WRONG_COMMAND","message" : "Schema is required"], options: .PrettyPrinted)
            }catch(_){
                XCTFail(tag)
            }
            iotSession = MockSession.self
            MockSession.mockResponse = (jsonData, urlResponse: mockResponse3, error: nil)
            MockSession.requestVerifier = patchRequestVerifier
        }


        api.patchTrigger(expectedTriggerID, schemaName: testcase.schemaName, schemaVersion: testcase.schemaVersion, actions: testcase.actions, predicate: testcase.predicate, completionHandler: { (trigger, error) -> Void in
            if testcase.success {
                if error == nil{
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                    XCTAssertEqual(trigger!.targetID.toString(), self.target.targetType.toString(), tag)
                    XCTAssertEqual(trigger!.enabled, true, tag)
                    XCTAssertNotNil(trigger!.predicate, tag)
                    XCTAssertEqual(trigger!.command.commandID, "", tag)
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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPatchTrigger_UnsupportError() {
        let expectation = self.expectationWithDescription("patchTriggerUnsupportError")

        // perform onboarding
        api._target = target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let predicate = SchedulePredicate(schedule: "'*/15 * * * *")
        api.patchTrigger(expectedTriggerID, schemaName: nil, schemaVersion: nil, actions: nil, predicate: predicate) { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
                default:
                    XCTFail("should be unsupport error")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    func testPatchTrigger_target_not_available_error() {
        let expectation = self.expectationWithDescription("testPatchTrigger_target_not_available_error")

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", value: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}