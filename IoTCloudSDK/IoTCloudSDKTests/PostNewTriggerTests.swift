//
//  PostNewTriggerTests.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class PostNewTriggerTests: XCTestCase {

    var owner: Owner!
    var schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)
    let baseURLString = "https://small-tests.internal.kii.com"
    var api: IoTCloudAPI!
    let target = Target(targetType: TypedID(type: "thing", id: "0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()

        owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

        api = IoTCloudAPIBuilder(appID: "dummyID", appKey: "dummyKey",
            baseURL: self.baseURLString, owner: owner).build()

    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct TestCase {
        let clause: Clause
        let expectedClauseDict: Dictionary<String, AnyObject>
        let triggersWhen: TriggersWhen
        let expectedTriggersWhenString: String
    }

    func testPostNewTrigger_success() {

        // perform onboarding
        api._target = target

        let orClauseClause = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let andClauseClause = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let complexExpectedClauses:[Dictionary<String, AnyObject>] = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseClause]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseClause]]
        ]

        let testsCases: [TestCase] = [
            // simple clause
            TestCase(clause: EqualsClause(field: "color", value: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: EqualsClause(field: "power", value: true), expectedClauseDict: ["type":"eq","field":"power", "value": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: NotEqualsClause(field: "power", value: true), expectedClauseDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", upperLimit: 255, upperIncluded:true), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", upperLimit: 200, upperIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", upperLimit: 200.345, upperIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "upperLimit": 200.345, "upperIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimit: 1, lowerIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimit: 1, lowerIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimit: 1.345, lowerIncluded: false), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1.345, "lowerIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimit: 1, lowerIncluded: true, upperLimit: 345, upperIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true, "upperLimit": 345, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: RangeClause(field: "color", lowerLimit: 1.1, lowerIncluded: true, upperLimit: 345.3, upperIncluded: true), expectedClauseDict: ["type": "range", "field": "color", "lowerLimit": 1.1, "lowerIncluded": true, "upperLimit": 345.3, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: AndClause(clauses: EqualsClause(field: "color", value: 0), NotEqualsClause(field: "power", value: true)), expectedClauseDict: ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: OrClause(clauses: EqualsClause(field: "color", value: 0), NotEqualsClause(field: "color", value: true)), expectedClauseDict: ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            // complex clauses
            TestCase(clause: AndClause(clauses: EqualsClause(field: "brightness", value: 50), OrClause(clauses: EqualsClause(field: "color", value: 0), NotEqualsClause(field: "power", value: true))), expectedClauseDict: complexExpectedClauses[0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(clause: OrClause(clauses: EqualsClause(field: "brightness", value: 50),AndClause(clauses: EqualsClause(field: "color", value: 0), NotEqualsClause(field: "power", value: true))), expectedClauseDict: complexExpectedClauses[1], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            // test triggersWhen
            TestCase(clause: EqualsClause(field: "color", value: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_CHANGED, expectedTriggersWhenString: "CONDITION_CHANGED"),
            TestCase(clause: EqualsClause(field: "color", value: 0), expectedClauseDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_TRUE, expectedTriggersWhenString: "CONDITION_TRUE")

        ]
        for (index,testCase) in testsCases.enumerate() {
            postNewTriggerSuccess("testPostNewTrigger_success_\(index)", testcase: testCase)
        }

    }

    func postNewTriggerSuccess(tag: String, testcase: TestCase) {
        let expectation = self.expectationWithDescription(tag)

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let condition = Condition(clause: testcase.clause)
            let predicate = StatePredicate(condition: condition, triggersWhen: testcase.triggersWhen)

            let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedClause = testcase.expectedClauseDict
            let expectedEventSource = "states"
            let expectedTriggerWhen = testcase.expectedTriggersWhenString
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause]

            // mock response
            let dict = ["triggerID": expectedTriggerID]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":self.owner.ownerID.toString(), "target": self.target.targetType.toString(), "schema": self.schema.name, "schemaVersion": self.schema.version,"actions":expectedActions]]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
                }catch(_){
                    XCTFail(tag)
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewTrigger(schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                    XCTAssertEqual(trigger!.targetID.toString(), self.target.targetType.toString(), tag)
                    XCTAssertEqual(trigger!.enabled, true, tag)
                    XCTAssertNotNil(trigger!.predicate, tag)
                    XCTAssertEqual(trigger!.command.commandID, "", tag)
                }else {
                    XCTFail("should success for \(tag)")
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewTrigger_http_404() {
        let expectation = self.expectationWithDescription("postNewTrigger404Error")

        // perform onboarding
        api._target = target

        do{
            let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let clause = EqualsClause(field: "color", value: 0)
            let condition = Condition(clause: clause)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

            let expectedClause = ["type":"eq","filed":"color", "value": 0]
            let expectedEventSource = "states"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedClause]

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.targetType.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":self.owner.ownerID.toString(), "target": self.target.targetType.toString(), "schema": self.schema.name, "schemaVersion": self.schema.version,"actions":actions]]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
                }catch(_){
                    XCTFail()
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewTrigger(schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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

    func testPostNewTrigger_UnsupportError() {
        let expectation = self.expectationWithDescription("postNewTriggerUnsupportError")

        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let predicate = SchedulePredicate(schedule: "'*/15 * * * *")

        api.postNewTrigger(schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func testPostTrigger_target_not_available_error() {
        let expectation = self.expectationWithDescription("testPostTrigger_target_not_available_error")

        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", value: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

        api.postNewTrigger(schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
