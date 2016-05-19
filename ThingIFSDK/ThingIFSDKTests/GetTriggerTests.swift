//
//  GetTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GetTriggerTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetTrigger_success_predicates() {
        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api._target = setting.target

        let simpleStatementsToTest = [
            ["type":"eq","field":"color", "value": 0],
            ["type":"eq","field":"power", "value": true],
            ["type": "not", "clause": ["type":"eq","field":"power", "value": true]],
            ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true],
            ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false],
            ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true],
            ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false],
            ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]],
            ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        ]
        for simpleStatement in simpleStatementsToTest {
            getTriggerSuccess("testGetTrigger_success_predicates", statementToTest: simpleStatement, triggersWhen: "CONDITION_FALSE_TO_TRUE", setting: setting)
        }

        let orClauseStatement = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let andClauseStatement = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let complexStatementsToTest = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseStatement]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseStatement]]
        ]
        for complextStatement in complexStatementsToTest {
            getTriggerSuccess("getTriggerSuccess", statementToTest: complextStatement as! Dictionary<String, AnyObject>, triggersWhen: "CONDITION_FALSE_TO_TRUE", setting: setting)
        }

    }

    func testGetTrigger_success_triggersWhens() {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        api._target = setting.target

        let triggersWhensToTest = ["CONDITION_TRUE", "CONDITION_FALSE_TO_TRUE", "CONDITION_CHANGED"]
        for triggersWhen in triggersWhensToTest {
            getTriggerSuccess("testGetTrigger_success_triggersWhens", statementToTest: ["type":"eq","field":"color", "value": 0], triggersWhen: triggersWhen, setting: setting)
        }

    }

    func getTriggerSuccess(tag: String, statementToTest: Dictionary<String, AnyObject>, triggersWhen: String, setting:TestSetting) {

        let expectation : XCTestExpectation! = self.expectationWithDescription(tag)

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let expectedActionsDict: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedCommandObject = Command(commandID: nil, targetID: setting.target.typedID, issuerID: setting.owner.typedID, schemaName: setting.schema, schemaVersion: setting.schemaVersion, actions: expectedActionsDict, actionResults: nil, commandState: nil)
            let eventSource = "STATES"
            let expectedPredicateDict = ["eventSource":eventSource, "triggersWhen":triggersWhen, "condition":statementToTest]

            // mock response
            let commandDict = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": expectedActionsDict]
            let dict = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "command": commandDict, "disabled": false]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
             }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.getTrigger(expectedTriggerID, completionHandler: { (trigger, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                    XCTAssertTrue(trigger!.enabled == true)
                    XCTAssertTrue(trigger!.command == expectedCommandObject)

                    do {
                        let expectedActionsData = try NSJSONSerialization.dataWithJSONObject(expectedActionsDict, options: NSJSONWritingOptions(rawValue: 0))
                        let actualActionsData = try NSJSONSerialization.dataWithJSONObject(trigger!.command!.actions, options: NSJSONWritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedActionsData == actualActionsData)

                        let expectedPredicteData = try NSJSONSerialization.dataWithJSONObject(expectedPredicateDict, options: NSJSONWritingOptions(rawValue: 0))
                        let actualPredicateDict = trigger!.predicate.toNSDictionary()
                        let actualBodyData = try NSJSONSerialization.dataWithJSONObject(actualPredicateDict, options: NSJSONWritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedPredicteData.length == actualBodyData.length)
                    }catch(_){
                        XCTFail()
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetServerCodeTrigger_success() {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        let expectation = self.expectationWithDescription("testGetServerCodeTrigger_success")
        
        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let expectedEndpoint = "my_function"
            let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
            let expectedTargetAppID = "app000001"
            var expectedParameters = Dictionary<String, AnyObject>()
            expectedParameters["arg1"] = "abcd"
            expectedParameters["arg2"] = 1234
            expectedParameters["arg3"] = 0.12345
            expectedParameters["arg4"] = false
            let expectedServerCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)
            let serverCodeDict = expectedServerCode.toNSDictionary()
            let eventSource = "STATES"
            let condition: Dictionary<String, AnyObject> = ["type":"eq","field":"color", "value": 0]
            let expectedPredicateDict = ["eventSource":eventSource, "triggersWhen":TriggersWhen.CONDITION_FALSE_TO_TRUE.rawValue, "condition": condition]
            
            // mock response
            let dict = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "serverCode": serverCodeDict, "disabled": false]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api._target = setting.target
            api.getTrigger(expectedTriggerID, completionHandler: { (trigger, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                    XCTAssertTrue(trigger!.enabled == true)
                    XCTAssertTrue(trigger!.serverCode == expectedServerCode)
                    XCTAssertNil(trigger!.command)
                    
                    do {
                        let expectedPredicteData = try NSJSONSerialization.dataWithJSONObject(expectedPredicateDict, options: NSJSONWritingOptions(rawValue: 0))
                        let actualPredicateDict = trigger!.predicate.toNSDictionary()
                        let actualBodyData = try NSJSONSerialization.dataWithJSONObject(actualPredicateDict, options: NSJSONWritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedPredicteData.length == actualBodyData.length)
                    }catch(_){
                        XCTFail()
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    
    func testGetTrigger_404_error() {
        let expectation = self.expectationWithDescription("getTrigger403Error")
        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api._target = setting.target

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                    XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)")
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.getTrigger(triggerID, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .CONNECTION:
                        XCTFail("should not be connection error")
                    case .ERROR_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                        XCTAssertEqual(responsedDict["errorCode"]!, actualErrorResponse.errorCode)
                        XCTAssertEqual(responsedDict["message"]!, actualErrorResponse.errorMessage)
                    default:
                        break
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetTrigger_Target_not_available_error() {
        let expectation = self.expectationWithDescription("testGetTrigger_Target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.getTrigger(triggerID, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .CONNECTION:
                        XCTFail("should not be connection error")
                    case .ERROR_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                        XCTAssertEqual(responsedDict["errorCode"]!, actualErrorResponse.errorCode)
                        XCTAssertEqual(responsedDict["message"]!, actualErrorResponse.errorMessage)
                    default:
                        break
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
    }
}