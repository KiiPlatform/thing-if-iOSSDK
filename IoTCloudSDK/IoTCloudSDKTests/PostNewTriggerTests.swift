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

    //TODO: verify the possible predicate

    func testPostNewTriggerSuccess() {
        let expectation = self.expectationWithDescription("postNewTriggerSuccess")

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let target = Target(targetType: TypedID(type: "thing", id: expectedTriggerID))
            let actions: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let statement = Equals(field: "color", value: 0)
            let condition = Condition(statement: statement)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

            let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedStatement = ["type":"eq","filed":"color", "value": 0]
            let expectedEventSource = "states"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
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
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":self.owner.ownerID.toString(), "target": target.targetType.toString(), "schema": self.schema.name, "schemaVersion": self.schema.version,"actions":expectedActions]]
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
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                    XCTAssertEqual(trigger!.targetID.toString(), target.targetType.toString())
                    XCTAssertEqual(trigger!.enabled, true)
                    XCTAssertNotNil(trigger!.predicate)
                    XCTAssertEqual(trigger!.command.commandID, "")
                }else {
                    XCTFail("should success")
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
