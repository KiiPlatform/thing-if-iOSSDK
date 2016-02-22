//
//  ListTriggersTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ListTriggersTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct ExpectedTriggerStruct {
        let statement: Dictionary<String, AnyObject>
        let triggerID: String
        let triggersWhenString: String
        let enabled: Bool

        func getPredicateDict() -> Dictionary<String, AnyObject> {
            return ["eventSource":"STATES", "triggersWhen":triggersWhenString, "condition":statement]
        }

    }

    func testListTriggers_success_predicates() {
        let setting = TestSetting()
        let api = setting.api
        let triggerIDPrifex = "0267251d9d60-1858-5e11-3dc3-00f3f0b"

        // perform onboarding
        api._target = setting.target

        var expectedTriggerStructs: [ExpectedTriggerStruct] = [
            ExpectedTriggerStruct(statement: ["type":"eq","field":"color", "value": 0], triggerID: "\(triggerIDPrifex)1", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type":"eq","field":"power", "value": true], triggerID: "\(triggerIDPrifex)2", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], triggerID: "\(triggerIDPrifex)3", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], triggerID: "\(triggerIDPrifex)4", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false], triggerID: "\(triggerIDPrifex)5", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true], triggerID: "\(triggerIDPrifex)6", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false], triggerID: "\(triggerIDPrifex)7", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggerID: "\(triggerIDPrifex)8", triggersWhenString: "CONDITION_CHANGED", enabled: false),
            ExpectedTriggerStruct(statement: ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggerID: "\(triggerIDPrifex)9", triggersWhenString: "CONDITION_FALSE_TO_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "upperLimit": 3.1415927, "upperIncluded": false], triggerID: "\(triggerIDPrifex)10", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "lowerLimit": 1.345, "lowerIncluded": false], triggerID: "\(triggerIDPrifex)11", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "upperLimit": 345, "upperIncluded": false, "lowerLimit": 2, "lowerIncluded": true], triggerID: "\(triggerIDPrifex)10", triggersWhenString: "CONDITION_TRUE", enabled: true),
            ExpectedTriggerStruct(statement: ["type": "range", "field": "color", "upperLimit": 345.3, "upperIncluded": true, "lowerLimit": 2.1, "lowerIncluded": true], triggerID: "\(triggerIDPrifex)10", triggersWhenString: "CONDITION_TRUE", enabled: true)
        ]


        let expectation = self.expectationWithDescription("testListTriggers_success_predicates")

        do{
            let expectedActionsDict: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedCommandObject = Command(commandID: nil, targetID: setting.target.typedID, issuerID: setting.owner.typedID, schemaName: setting.schema, schemaVersion: setting.schemaVersion, actions: expectedActionsDict, actionResults: nil, commandState: nil)
            let eventSource = "STATES"

            // mock response
            let commandDict = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": expectedActionsDict]

            var expectedTriggerDicts = [Dictionary<String, AnyObject>]()
            for expectedTriggerStruct in expectedTriggerStructs {
                expectedTriggerDicts.append(["triggerID": expectedTriggerStruct.triggerID, "predicate": ["eventSource":eventSource, "triggersWhen":expectedTriggerStruct.triggersWhenString, "condition":expectedTriggerStruct.statement], "command": commandDict, "disabled": !(expectedTriggerStruct.enabled)])
            }
            let jsonData = try NSJSONSerialization.dataWithJSONObject(["triggers":expectedTriggerDicts], options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers")
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.listTriggers(nil, paginationKey: nil, completionHandler: { (triggers, paginationKey, error) -> Void in

                if(error != nil) {
                    XCTFail("should success")
                }else {
                    if triggers != nil {
                        XCTAssertEqual(triggers!.count, expectedTriggerStructs.count)
                        for (index,trigger) in triggers!.enumerate() {
                            XCTAssertEqual(trigger.triggerID, expectedTriggerStructs[index].triggerID)
                            XCTAssertTrue(trigger.enabled == expectedTriggerStructs[index].enabled)
                            XCTAssertTrue(trigger.command == expectedCommandObject)

                            do {
                                // verify actions dictionary
                                let expectedActionsData = try NSJSONSerialization.dataWithJSONObject(expectedActionsDict, options: NSJSONWritingOptions(rawValue: 0))
                                let actualActionsData = try NSJSONSerialization.dataWithJSONObject(trigger.command!.actions, options: NSJSONWritingOptions(rawValue: 0))
                                XCTAssertTrue(expectedActionsData == actualActionsData)

                                // verify predicate
                                let expectedPredicteData = try NSJSONSerialization.dataWithJSONObject(expectedTriggerStructs[index].getPredicateDict(), options: NSJSONWritingOptions(rawValue: 0))
                                let actualPredicateDict = trigger.predicate.toNSDictionary()
                                let actualBodyData = try NSJSONSerialization.dataWithJSONObject(actualPredicateDict, options: NSJSONWritingOptions(rawValue: 0))
                                XCTAssertTrue(expectedPredicteData.length == actualBodyData.length)
                            }catch(_){
                                XCTFail()
                            }
                        }
                    }else {
                        XCTFail("triggers should not be empty")
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
    
    func testListTriggers_404_error() {
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

    func testListTriggers_target_not_available_error() {
        let expectation = self.expectationWithDescription("testListTriggers_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.listTriggers(nil, paginationKey: nil, completionHandler: { (commands, paginationKey, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                XCTAssertNil(commands)
                XCTAssertNil(paginationKey)
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("error should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}