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

    let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
        baseURL: "https://small-tests.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()

    let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

        func getExpectedCommandDict() -> Dictionary<String, AnyObject>? {

            if schemaName == nil && schemaVersion == nil && actions == nil {
                return nil
            }

            var commandDict: Dictionary<String, AnyObject> = ["issuer":issuerID.toString(), "target":target.targetType.toString()]
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

    func testPatchTrigger_success() {

        let expectedActions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

//        let orClauseStatement = ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
//        let andClauseStatement = ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]]
//        let complexExpectedStatements:[Dictionary<String, AnyObject>] = [
//            ["type": "and", "clauses": [["type":"eq","field":"brightness", "value": 50], orClauseStatement]],
//            ["type": "or", "clauses": [["type":"eq","field":"brightness", "value": 50], andClauseStatement]]
//        ]

        let testsCases: [TestCase] = [
            // simple statement
            TestCase(target: target, issuerID: owner.ownerID, schemaName: self.schema.name, schemaVersion: self.schema.version, actions: expectedActions, predicate: StatePredicate(condition: Condition(statement: Equals(field: "color", value: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE), expectedStatementDict: ["type":"eq","field":"color", "value": 0], expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE")
//            TestCase(statement: Equals(field: "color", value: 0), expectedStatementDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: Equals(field: "power", value: true), expectedStatementDict: ["type":"eq","field":"power", "value": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: NotEquals(field: "power", value: true), expectedStatementDict: ["type": "not", "clause": ["type":"eq","field":"power", "value": true]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: NotGreaterThan(field: "color", upperLimit: 255), expectedStatementDict: ["type": "range", "field": "color", "upperLimit": 255, "upperIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: LessThan(field: "color", upperLimit: 200), expectedStatementDict: ["type": "range", "field": "color", "upperLimit": 200, "upperIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: NotLessThan(field: "color", lowerLimit: 1), expectedStatementDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": true], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: GreaterThan(field: "color", lowerLimit: 1), expectedStatementDict: ["type": "range", "field": "color", "lowerLimit": 1, "lowerIncluded": false], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: And(statements: Equals(field: "color", value: 0), NotEquals(field: "power", value: true)), expectedStatementDict: ["type": "and", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: Or(statements: Equals(field: "color", value: 0), NotEquals(field: "color", value: true)), expectedStatementDict: ["type": "or", "clauses": [["type":"eq","field":"color", "value": 0], ["type": "not", "clause": ["type":"eq","field":"power", "value": true]] ]], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            // complex statements
//            TestCase(statement: And(statements: Equals(field: "brightness", value: 50), Or(statements: Equals(field: "color", value: 0), NotEquals(field: "power", value: true))), expectedStatementDict: complexExpectedStatements[0], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            TestCase(statement: Or(statements: Equals(field: "brightness", value: 50),And(statements: Equals(field: "color", value: 0), NotEquals(field: "power", value: true))), expectedStatementDict: complexExpectedStatements[1], triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE, expectedTriggersWhenString: "CONDITION_FALSE_TO_TRUE"),
//            // test triggersWhen
//            TestCase(statement: Equals(field: "color", value: 0), expectedStatementDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_CHANGED, expectedTriggersWhenString: "CONDITION_CHANGED"),
//            TestCase(statement: Equals(field: "color", value: 0), expectedStatementDict: ["type":"eq","field":"color", "value": 0], triggersWhen: TriggersWhen.CONDITION_TRUE, expectedTriggersWhenString: "CONDITION_TRUE")

        ]
        for (index,testCase) in testsCases.enumerate() {
            patchTriggerSuccess("testPatchTrigger_success_\(index)", testcase: testCase)
        }
    }

    func patchTriggerSuccess(tag: String, testcase: TestCase) {
        let expectation = self.expectationWithDescription(tag)

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let target = Target(targetType: TypedID(type: "thing", id: expectedTriggerID))

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 204, HTTPVersion: nil, headerFields: nil)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PATCH")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
            }
            //verify body
            var expectedBodyDict = Dictionary<String, AnyObject>()
            if let expectedCommandDict = testcase.getExpectedCommandDict(){
                expectedBodyDict["command"] = expectedCommandDict
            }
            if let expectedPredicateDict = testcase.getExpectedPredictDict() {
                expectedBodyDict["predicate"] = expectedPredicateDict
            }
            do {
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBodyDict, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
            }catch(_){
                XCTFail(tag)
            }
        }
        MockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        MockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.patchTrigger(target, triggerID: expectedTriggerID, schemaName: testcase.schemaName, schemaVersion: testcase.schemaVersion, actions: testcase.actions, predicate: testcase.predicate, completionHandler: { (trigger, error) -> Void in
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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewTrigger_http_403() {
        //TODO: implementations
    }
    func testPostNewTrigger_http_404() {
        //TODO: implementations
    }
    func testPostNewTrigger_http_503() {
        //TODO: implementations
    }
}