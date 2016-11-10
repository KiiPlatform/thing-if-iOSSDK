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

        let orClauseStatement = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]] as [String : Any]
        let andClauseStatement = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]] as [String : Any]
        let complexStatementsToTest = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseStatement]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseStatement]]
        ]
        for complextStatement in complexStatementsToTest {
            getTriggerSuccess("getTriggerSuccess", statementToTest: complextStatement, triggersWhen: "CONDITION_FALSE_TO_TRUE", setting: setting)
        }

    }

    func testGetTrigger_success_triggersWhens() {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        api._target = setting.target

        let triggersWhensToTest = ["CONDITION_TRUE", "CONDITION_FALSE_TO_TRUE", "CONDITION_CHANGED"]
        for triggersWhen in triggersWhensToTest {
            getTriggerSuccess("testGetTrigger_success_triggersWhens", statementToTest: ["type":"eq", "field": "color", "value": 0], triggersWhen: triggersWhen, setting: setting)
        }

    }

    func getTriggerSuccess(_ tag: String, statementToTest: Dictionary<String, Any>, triggersWhen: String, setting:TestSetting) {

        let expectation : XCTestExpectation! = self.expectation(description: tag)

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let expectedActionsDict: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedCommandObject = Command(commandID: nil, targetID: setting.target.typedID, issuerID: setting.owner.typedID, schemaName: setting.schema, schemaVersion: setting.schemaVersion, actions: expectedActionsDict, actionResults: nil, commandState: nil)
            let eventSource = "STATES"
            let expectedPredicateDict = ["eventSource":eventSource, "triggersWhen":triggersWhen, "condition":statementToTest] as [String : Any]

            // mock response
            let commandDict: [String : Any] = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": expectedActionsDict]
            let dict: [String : Any] = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "command": commandDict, "disabled": false]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
             }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.getTrigger(expectedTriggerID, completionHandler: { (trigger, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                    XCTAssertTrue(trigger!.enabled == true)
                    XCTAssertTrue(trigger!.command == expectedCommandObject)

                    do {
                        let expectedActionsData = try JSONSerialization.data(withJSONObject: expectedActionsDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let actualActionsData = try JSONSerialization.data(withJSONObject: trigger!.command!.actions, options: JSONSerialization.WritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedActionsData == actualActionsData)

                        let expectedPredicteData = try JSONSerialization.data(withJSONObject: expectedPredicateDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let actualPredicateDict = trigger!.predicate.toNSDictionary()
                        let actualBodyData = try JSONSerialization.data(withJSONObject: actualPredicateDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedPredicteData.count == actualBodyData.count)
                    }catch(_){
                        XCTFail()
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetServerCodeTrigger_success() {
        let setting = TestSetting()
        let api = setting.api
        // perform onboarding
        let expectation = self.expectation(description: "testGetServerCodeTrigger_success")
        
        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let expectedEndpoint = "my_function"
            let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
            let expectedTargetAppID = "app000001"
            var expectedParameters = Dictionary<String, Any>()
            expectedParameters["arg1"] = "abcd"
            expectedParameters["arg2"] = 1234
            expectedParameters["arg3"] = 0.12345
            expectedParameters["arg4"] = false
            let expectedServerCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)
            let serverCodeDict = expectedServerCode.toNSDictionary()
            let eventSource = "STATES"
            let condition: Dictionary<String, Any> = ["type":"eq", "field":"color", "value": 0]
            let expectedPredicateDict: [String : Any] = ["eventSource":eventSource, "triggersWhen":TriggersWhen.conditionFalseToTrue.rawValue, "condition": condition]
            
            // mock response
            let dict: [String : Any] = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "serverCode": serverCodeDict, "disabled": false]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
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
                        let expectedPredicteData = try JSONSerialization.data(withJSONObject: expectedPredicateDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let actualPredicateDict = trigger!.predicate.toNSDictionary()
                        let actualBodyData = try JSONSerialization.data(withJSONObject: actualPredicateDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedPredicteData.count == actualBodyData.count)
                    }catch(_){
                        XCTFail()
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    
    func testGetTrigger_404_error() {
        let expectation = self.expectation(description: "getTrigger403Error")
        let setting = TestSetting()
        let api = setting.api

        // perform onboarding
        api._target = setting.target

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                    XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)")
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.getTrigger(triggerID, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .errorResponse(let actualErrorResponse):
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
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetTrigger_Target_not_available_error() {
        let expectation = self.expectation(description: "testGetTrigger_Target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.getTrigger(triggerID, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .errorResponse(let actualErrorResponse):
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
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
    }
}
