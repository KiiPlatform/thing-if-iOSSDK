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

    func testPostNewTrigger_http_404() {
        let expectation = self.expectation(description: "postNewTrigger404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api.target = target

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

            api.postNewTrigger(
              TriggeredCommandForm(
                schemaName: schema,
                schemaVersion: schemaVersion,
                actions: actions),
              predicate: predicate,
              completionHandler: { (trigger, error) -> Void in
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

    func testPostNewTrigger_http_400() {
        let expectation = self.expectation(description: "postNewTrigger400Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion

        // perform onboarding
        api.target = target

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

            api.postNewTrigger(
              TriggeredCommandForm(
                schemaName: schema,
                schemaVersion: schemaVersion,
                actions: actions),
              predicate: predicate,
              completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .errorResponse(let actualErrorResponse):
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
        api.target = target

        do{
            let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

            let scheduleDate = Date()
            let predicate = ScheduleOncePredicate(scheduleAt: scheduleDate)
            let dateMilis = Int64(scheduleDate.timeIntervalSince1970 * 1000)
            let expectedPredicateDict: [String : Any] = ["eventSource":EventSource.scheduleOnce.rawValue,
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

            api.postNewTrigger(
              TriggeredCommandForm(
                schemaName: schema,
                schemaVersion: schemaVersion,
                actions: actions),
              predicate: predicate,
              completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .errorResponse(let actualErrorResponse):
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

        api.postNewTrigger(
          TriggeredCommandForm(
            schemaName: schema,
            schemaVersion: schemaVersion,
            actions: actions),
          predicate: predicate,
          completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .targetNotAvailable:
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
