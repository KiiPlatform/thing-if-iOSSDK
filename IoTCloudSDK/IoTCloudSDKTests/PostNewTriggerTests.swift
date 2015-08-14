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
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostNewTriggerSuccess() {

        let expectation = self.expectationWithDescription("postNewTrigger")

        let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
        let schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)
        let baseURLString = "https://small-tests.internal.kii.com"
        let api = IoTCloudAPIBuilder(appID: "dummyID", appKey: "dummyKey",
            baseURL: baseURLString, owner: owner).addSchema(schema).build()

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let target = Target(targetType: TypedID(type: "thing", id: expectedTriggerID))
            let actions: [Dictionary<String, Any>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let statement = Equals(field: "color", value: 0)
            let condition = Condition(statement: statement)
            let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

            let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedStatement = ["=":["filed":"color", "value": 0]]
            let expectedEventSource = "states"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedStatement]

            // mock response
            let dict = ["triggerID": expectedTriggerID]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                //verify body

                let expectedBody = ["predicate": expectedPredicateDict, "command":["issuer":owner.ownerID.toString(), "target": target.targetType.toString(), "schema": schema.name, "schemaVersion": schema.version,"actions":expectedActions]]
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
}
