//
//  PostNewTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct TestCase {
        var clause: Clause?
        var expectedClauseDict: Dictionary<String, Any>?
        var triggersWhen: TriggersWhen?
        var expectedTriggersWhenString: String?
        var expectedScheduleAt : Date? = nil
        // State predicate
        init(clause: Clause , expectedClauseDict: Dictionary<String, Any>?, triggersWhen: TriggersWhen,
             expectedTriggersWhenString: String?){
            self.clause = clause
            self.expectedClauseDict = expectedClauseDict
            self.triggersWhen = triggersWhen
            self.expectedTriggersWhenString = expectedTriggersWhenString
        }
        init(expectedScheduleAt: Date?){
            self.expectedScheduleAt = expectedScheduleAt
        }
    }

    func testPostNewTrigger_success() {


        func postNewTriggerSuccess(_ tag: String, testcase: TestCase, setting:TestSetting) {
            let expectation = self.expectation(description: tag)

            do{
                let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
                let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

                let predicate : Predicate
                let expectedPredicateDict : Dictionary<String, Any>
                if testcase.clause != nil {
                    let expectedClause = testcase.expectedClauseDict!
                    let expectedEventSource = "STATES"
                    let expectedTriggerWhen = testcase.expectedTriggersWhenString!
                    let condition = Condition(clause: testcase.clause!)
                    predicate = StatePredicate(condition: condition, triggersWhen: testcase.triggersWhen!)
                    expectedPredicateDict = ["eventSource":expectedEventSource,
                                             "triggersWhen":expectedTriggerWhen,
                                             "condition":expectedClause]
                }else{
                    predicate = ScheduleOncePredicate(scheduleAt: testcase.expectedScheduleAt!)
                    let dateMilis = Int64(testcase.expectedScheduleAt!.timeIntervalSince1970 * 1000)
                    expectedPredicateDict = ["eventSource":EventSource.ScheduleOnce.rawValue,
                                             "scheduleAt":NSNumber(value: dateMilis as Int64)]

                }

                let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

                // mock response
                let dict = ["triggerID": expectedTriggerID]
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)

                // verify request
                let requestVerifier: ((URLRequest) -> Void) = {(request) in
                    XCTAssertEqual(request.httpMethod, "POST")
                    //verify header
                    let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                    for (key, value) in expectedHeader {
                        XCTAssertEqual(value, request.value(forHTTPHeaderField: key), tag)
                    }
                    //verify body

                    let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":setting.owner.typedID.toString(), "target": setting.target.typedID.toString(), "schema": setting.schema, "schemaVersion": setting.schemaVersion,"actions":expectedActions, "triggersWhat":"COMMAND"]]
                    do {
                        let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let actualBodyData = request.httpBody
                        XCTAssertTrue(expectedBodyData.count == actualBodyData!.count, tag)
                    }catch(_){
                        XCTFail(tag)
                    }

                    XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers")
                }
                sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
                sharedMockSession.requestVerifier = requestVerifier
                iotSession = MockSession.self

                setting.api.postNewTrigger(setting.schema, schemaVersion: setting.schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                    if error == nil{
                        XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                        XCTAssertEqual(trigger!.targetID, setting.target.typedID, tag)
                        XCTAssertEqual(trigger!.enabled, true, tag)
                        XCTAssertNotNil(trigger!.predicate, tag)
                        XCTAssertEqual(trigger!.command!.commandID, "", tag)
                    }else {
                        XCTFail("should success for \(tag)")
                    }
                    expectation.fulfill()
                })
            }catch(let e){
                print(e)
            }
            self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
                if error != nil {
                    XCTFail("execution timeout for \(tag)")
                }
            }
        }

        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        // perform onboarding
        api._target = target

        let orClauseClause = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]] as [String : Any]
        let andClauseClause = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]] as [String : Any]
        let complexExpectedClauses:[Dictionary<String, Any>] = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseClause]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseClause]]
        ]

        let testsCases: [TestCase] = [
            // simple clause
            TestCase(clause: EqualsClause(field: "color", intValue: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: EqualsClause(field: "power", boolValue: true), expectedClauseDict: ["type":"eq","field":"power", "value": true], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: NotEqualsClause(field: "power", boolValue: true), expectedClauseDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", upperLimitInt: 255, upperIncluded:true), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", upperLimitInt: 200, upperIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", upperLimitDouble: 200.345, upperIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 200.345, "upperIncluded": false], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimitInt: 1, lowerIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimitInt: 1, lowerIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimitDouble: 1.345, lowerIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1.345, "lowerIncluded": false], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimitInt: 1, lowerIncluded: true, upperLimit: 345, upperIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true, "upperLimit": 345, "upperIncluded": true], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimitDouble: 1.1, lowerIncluded: true, upperLimit: 345.3, upperIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1.1, "lowerIncluded": true, "upperLimit": 345.3, "upperIncluded": true], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: AndClause(clauses: EqualsClause(field: "color", intValue: 0), NotEqualsClause(field: "power", boolValue: true)), expectedClauseDict: ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: OrClause(clauses: EqualsClause(field: "color", intValue: 0), NotEqualsClause(field: "color", boolValue: true)), expectedClauseDict: ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            // complex clauses
            TestCase(clause: AndClause(clauses: EqualsClause(field: "brightness", intValue: 50), OrClause(clauses: EqualsClause(field: "color", intValue:  0), NotEqualsClause(field: "power", boolValue: true))), expectedClauseDict: complexExpectedClauses[0], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: OrClause(clauses: EqualsClause(field: "brightness", intValue: 50),AndClause(clauses: EqualsClause(field: "color", intValue: 0), NotEqualsClause(field: "power", boolValue: true))), expectedClauseDict: complexExpectedClauses[1], triggersWhen: TriggersWhen.conditionFalseToTrue, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            // test triggersWhen
            TestCase(clause: EqualsClause(field: "color", intValue: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.conditionChanged, expectedTriggersWhenString: "CONDITION_CHANGED"),
            TestCase(clause: EqualsClause(field: "color", intValue: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.conditionTrue, expectedTriggersWhenString: "CONDITION_TRUE"),
            //scheduledOnce
            TestCase(expectedScheduleAt: Date(timeIntervalSinceNow: 10))

        ]
        for (index,testCase) in testsCases.enumerated() {
            postNewTriggerSuccess("testPostNewTrigger_success_\(index)", testcase: testCase, setting: setting)
        }

    }


    func testPostNewTrigger_http_404() {
        let expectation = self.expectation(description: "postNewTrigger404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api._target = target

        do{
            let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let clause = EqualsClause(field: "color", intValue: 0)
            let condition = Condition(clause: clause)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.conditionFalseToTrue)

            let expectedClause = ["type":"eq","filed":"color", "value": 0] as [String : Any]
            let expectedEventSource = "STATES"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause] as [String : Any]

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":owner.typedID.toString(), "target": target.typedID.toString(), "schema": schema, "schemaVersion": schemaVersion,"actions":actions, "triggersWhat":"COMMAND"]]
                do {
                    let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
                }catch(_){
                    XCTFail()
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .error_RESPONSE(let actualErrorResponse):
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

    func testPostNewTrigger_http_400() {
        let expectation = self.expectation(description: "postNewTrigger400Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api._target = target

        do{
            let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let clause = EqualsClause(field: "color", intValue: 0)
            let condition = Condition(clause: clause)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.conditionFalseToTrue)

            let expectedClause = ["type":"eq","filed":"color", "value": 0] as [String : Any]
            let expectedEventSource = "STATES"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause] as [String : Any]

            // mock response
            let responsedDict = ["errorCode" : "BAD_REQUEST",
                                 "message" : "Passed Trigger is not valid"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 400, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":owner.typedID.toString(), "target": target.typedID.toString(), "schema": schema, "schemaVersion": schemaVersion,"actions":actions, "triggersWhat":"COMMAND"]]
                do {
                    let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
                }catch(_){
                    XCTFail()
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .error_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
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

    func testPostNewTrigger_http_400_invalidTimestamp() {
        let expectation = self.expectation(description: "postNewTrigger400Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api._target = target

        do{
            let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

            let scheduleDate = Date()
            let predicate = ScheduleOncePredicate(scheduleAt: scheduleDate)
            let dateMilis = Int64(scheduleDate.timeIntervalSince1970 * 1000)
            let expectedPredicateDict: [String : Any] = ["eventSource":EventSource.ScheduleOnce.rawValue,
                                     "scheduleAt":dateMilis]            // mock response
            let responsedDict = ["errorCode" : "Time stamp not valid",
                                 "message" : "Passed Trigger's timestamp is not valid"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 400, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":owner.typedID.toString(), "target": target.typedID.toString(), "schema": schema, "schemaVersion": schemaVersion,"actions":actions, "triggersWhat":"COMMAND"]]
                do {
                    let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
                }catch(_){
                    XCTFail()
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .error_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
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
    
    func testPostTrigger_target_not_available_error() {
        let expectation = self.expectation(description: "testPostTrigger_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", intValue: 0)), triggersWhen: TriggersWhen.conditionFalseToTrue)

        api.postNewTrigger(schema, schemaVersion: schemaVersion, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .target_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE")
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
