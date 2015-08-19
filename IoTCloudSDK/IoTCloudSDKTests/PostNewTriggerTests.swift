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
        let statement: Statement
        let expectedStatementDict: Dictionary<String, AnyObject>
        let triggersWhen: TriggersWhen
        let expectedTriggersWhenString: String
    }

    func testPostNewTrigger_success() {

        let orClauseStatement = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let andClauseStatement = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
        let complexExpectedStatements:[Dictionary<String, AnyObject>] = [
            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseStatement]],
            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseStatement]]
        ]

        let testsCases: [TestCase] = [
            // simple statement
            TestCase(statement: Equals(field: "color", value: 0), expectedStatementDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: Equals(field: "power", value: true), expectedStatementDict: ["type":"eq","field":"power", "value": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: NotEquals(field: "power", value: true), expectedStatementDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: NotGreaterThan(field: "color", upperLimit: 255), expectedStatementDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: LessThan(field: "color", upperLimit: 200), expectedStatementDict: ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: NotLessThan(field: "color", lowerLimit: 1), expectedStatementDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: GreaterThan(field: "color", lowerLimit: 1), expectedStatementDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: And(statements: Equals(field: "color", value: 0), NotEquals(field: "power", value: true)), expectedStatementDict: ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: Or(statements: Equals(field: "color", value: 0), NotEquals(field: "color", value: true)), expectedStatementDict: ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            // complex statements
            TestCase(statement: And(statements: Equals(field: "brightness", value: 50), Or(statements: Equals(field: "color", value: 0), NotEquals(field: "power", value: true))), expectedStatementDict: complexExpectedStatements[0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            TestCase(statement: Or(statements: Equals(field: "brightness", value: 50),And(statements: Equals(field: "color", value: 0), NotEquals(field: "power", value: true))), expectedStatementDict: complexExpectedStatements[1], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
            // test triggersWhen
            TestCase(statement: Equals(field: "color", value: 0), expectedStatementDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_CHANGED, expectedTriggersWhenString: "CONDITION_CHANGED"),
            TestCase(statement: Equals(field: "color", value: 0), expectedStatementDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_TRUE, expectedTriggersWhenString: "CONDITION_TRUE")

        ]
        for (index,testCase) in testsCases.enumerate() {
            postNewTriggerSuccess("testPostNewTrigger_success_\(index)", testcase: testCase)
        }

    }

    func postNewTriggerSuccess(tag: String, testcase: TestCase) {
        let expectation = self.expectationWithDescription(tag)

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let target = Target(targetType: TypedID(type: "thing", id: expectedTriggerID))
            let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let condition = Condition(statement: testcase.statement)
            let predicate = StatePredicate(condition: condition, triggersWhen: testcase.triggersWhen)

            let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedStatement = testcase.expectedStatementDict
            let expectedEventSource = "states"
            let expectedTriggerWhen = testcase.expectedTriggersWhenString
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedStatement]

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

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":self.owner.ownerID.toString(), "target": target.targetType.toString(), "schema": self.schema.name, "schemaVersion": self.schema.version,"actions":expectedActions]]
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

            api.postNewTrigger(target, schemaName: schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                    XCTAssertEqual(trigger!.targetID.toString(), target.targetType.toString(), tag)
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

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let target = Target(targetType: TypedID(type: "thing", id: expectedTriggerID))
            let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let statement = Equals(field: "color", value: 0)
            let condition = Condition(statement: statement)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

            let expectedStatement = ["type":"eq","filed":"color", "value": 0]
            let expectedEventSource = "states"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedStatement]

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

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":self.owner.ownerID.toString(), "target": target.targetType.toString(), "schema": self.schema.name, "schemaVersion": self.schema.version,"actions":actions]]
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

            api.postNewTrigger(target, schemaName: schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let target = Target(targetType: TypedID(type: "thing", id: expectedTriggerID))
        let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
        let predicate = SchedulePredicate(schedule: "'*/15 * * * *")

        api.postNewTrigger(target, schemaName: schema.name, schemaVersion: schema.version, actions: actions, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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

}
