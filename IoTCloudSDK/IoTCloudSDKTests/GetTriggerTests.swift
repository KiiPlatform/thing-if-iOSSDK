//
//  GetTriggerTests.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class GetTriggerTests: XCTestCase {

    let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

    let schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)

    let baseURLString = "https://small-tests.internal.kii.com"

    var api:IoTCloudAPI!

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

    func testGetTrigger_success_predicates() {

        // perform onboarding
        api._target = target

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
            getTriggerSuccess("testGetTrigger_success_predicates", statementToTest: simpleStatement, triggersWhen: "CONDITION_FALSE_TO_TRUE")
        }

        let orClauseStatement = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let andClauseStatement = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let complexStatementsToTest = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseStatement]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseStatement]]
        ]
        for complextStatement in complexStatementsToTest {
            getTriggerSuccess("getTriggerSuccess", statementToTest: complextStatement as! Dictionary<String, AnyObject>, triggersWhen: "CONDITION_FALSE_TO_TRUE")
        }

    }

    func testGetTrigger_success_triggersWhens() {

        // perform onboarding
        api._target = target

        let triggersWhensToTest = ["CONDITION_TRUE", "CONDITION_FALSE_TO_TRUE", "CONDITION_CHANGED"]
        for triggersWhen in triggersWhensToTest {
            getTriggerSuccess("testGetTrigger_success_triggersWhens", statementToTest: ["type":"eq","field":"color", "value": 0], triggersWhen: triggersWhen)
        }

    }

    func getTriggerSuccess(tag: String, statementToTest: Dictionary<String, AnyObject>, triggersWhen: String) {
        let expectation = self.expectationWithDescription(tag)

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let expectedActionsDict: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedCommandObject = Command(commandID: nil, targetID: self.target.targetType, issuerID: self.owner.ownerID, schemaName: self.schema.name, schemaVersion: self.schema.version, actions: expectedActionsDict, actionResults: nil, commandState: nil)
            let eventSource = "states"
            let expectedPredicateDict = ["eventSource":eventSource, "triggersWhen":triggersWhen, "condition":statementToTest]

            // mock response
            let commandDict = ["schema": self.schema.name, "schemaVersion": self.schema.version, "target": self.target.targetType.toString(), "issuer": self.owner.ownerID.toString(), "actions": expectedActionsDict]
            let dict = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "command": commandDict, "disabled": false]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:self.baseURLString)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

             }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.getTrigger(expectedTriggerID, completionHandler: { (trigger, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                    XCTAssertTrue(trigger!.enabled == true)
                    XCTAssertTrue(trigger!.command == expectedCommandObject)

                    do {
                        let expectedActionsData = try NSJSONSerialization.dataWithJSONObject(expectedActionsDict, options: NSJSONWritingOptions(rawValue: 0))
                        let actualActionsData = try NSJSONSerialization.dataWithJSONObject(trigger!.command.actions, options: NSJSONWritingOptions(rawValue: 0))
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetTrigger_404_error() {
        let expectation = self.expectationWithDescription("getTrigger403Error")

        // perform onboarding
        api._target = target

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.targetType.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetTrigger_Target_not_available_error() {
        let expectation = self.expectationWithDescription("testGetTrigger_Target_not_available_error")

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.targetType.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
    }
}