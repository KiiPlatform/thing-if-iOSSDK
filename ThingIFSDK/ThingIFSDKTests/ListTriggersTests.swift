//
//  ListTriggersTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ListTriggersTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct ExpectedTriggerStruct {
        let statement: Dictionary<String, Any>
        let triggerID: String
        let triggersWhenString: String
        let enabled: Bool

        func getPredicateDict() -> Dictionary<String, Any> {
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


        let expectation = self.expectation(description: "testListTriggers_success_predicates")

        do{
            let expectedActionsDict: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedCommandObject = Command(commandID: nil, targetID: setting.target.typedID, issuerID: setting.owner.typedID, schemaName: setting.schema, schemaVersion: setting.schemaVersion, actions: expectedActionsDict, actionResults: nil, commandState: nil)
            let eventSource = "STATES"

            // mock response
            let commandDict: [String : Any] = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": expectedActionsDict]

            var expectedTriggerDicts = [Dictionary<String, Any>]()
            for expectedTriggerStruct in expectedTriggerStructs {
                expectedTriggerDicts.append(["triggerID": expectedTriggerStruct.triggerID, "predicate": ["eventSource":eventSource, "triggersWhen":expectedTriggerStruct.triggersWhenString, "condition":expectedTriggerStruct.statement], "command": commandDict, "disabled": !(expectedTriggerStruct.enabled)])
            }
            let jsonData = try JSONSerialization.data(withJSONObject: ["triggers":expectedTriggerDicts], options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.listTriggers(nil, paginationKey: nil, completionHandler: { (triggers, paginationKey, error) -> Void in

                if(error != nil) {
                    XCTFail("should success")
                }else {
                    if triggers != nil {
                        XCTAssertEqual(triggers!.count, expectedTriggerStructs.count)
                        for (index,trigger) in triggers!.enumerated() {
                            XCTAssertEqual(trigger.triggerID, expectedTriggerStructs[index].triggerID)
                            XCTAssertTrue(trigger.enabled == expectedTriggerStructs[index].enabled)
                            XCTAssertTrue(trigger.command == expectedCommandObject)

                            do {
                                // verify actions dictionary
                                let expectedActionsData = try JSONSerialization.data(withJSONObject: expectedActionsDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                                let actualActionsData = try JSONSerialization.data(withJSONObject: trigger.command!.actions, options: JSONSerialization.WritingOptions(rawValue: 0))
                                XCTAssertTrue(expectedActionsData == actualActionsData)

                                // verify predicate
                                let expectedPredicteData = try JSONSerialization.data(withJSONObject: expectedTriggerStructs[index].getPredicateDict(), options: JSONSerialization.WritingOptions(rawValue: 0))
                                let actualPredicateDict = trigger.predicate.toNSDictionary()
                                let actualBodyData = try JSONSerialization.data(withJSONObject: actualPredicateDict, options: JSONSerialization.WritingOptions(rawValue: 0))
                                XCTAssertTrue(expectedPredicteData.count == actualBodyData.count)
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
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func testListTriggers_404_error() {
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

    func testListTriggers_target_not_available_error() {
        let expectation = self.expectation(description: "testListTriggers_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.listTriggers(nil, paginationKey: nil, completionHandler: { (commands, paginationKey, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                XCTAssertNil(commands)
                XCTAssertNil(paginationKey)
                switch error! {
                case .targetNotAvailable:
                    break
                default:
                    XCTFail("error should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
