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

    func testGetTriggerSuccess() {
        let expectation = self.expectationWithDescription("getTriggerSuccess")

        do{
            let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
            let expectedActions = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]
            let expectedStatement = ["type":"eq","field":"color", "value": 0]
            let expectedEventSource = "states"
            let expectedTriggerWhen = "CONDITION_FALSE_TO_TRUE"
            let expectedPredicateDict = ["eventSource":expectedEventSource, "triggersWhen":expectedTriggerWhen, "condition":expectedStatement]
            let expectedCommandDict = ["schema": self.schema.name, "schemaVersion": self.schema.version, "target": self.target.targetType.toString(), "issuer": self.owner.ownerID.toString(), "actions": expectedActions]

            let expectedActionsDict: [Dictionary<String, AnyObject>] = [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]

            let expectedCommandObject = Command(commandID: nil, targetID: self.target.targetType, issuerID: self.owner.ownerID, schemaName: self.schema.name, schemaVersion: self.schema.version, actions: expectedActionsDict, actionResults: nil, commandState: nil)

            // mock response
            let dict = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "command": expectedCommandDict, "disabled": false]

            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:self.baseURLString)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

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

            api.getTrigger(self.target, triggerID: expectedTriggerID, completionHandler: { (trigger, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                    XCTAssertTrue(trigger!.enabled == true)
                    XCTAssertTrue(trigger!.command == expectedCommandObject)

                    do {
                        let expectedActionsData = try NSJSONSerialization.dataWithJSONObject(expectedActions, options: NSJSONWritingOptions(rawValue: 0))
                        let actualActionsData = try NSJSONSerialization.dataWithJSONObject(trigger!.command.actions, options: NSJSONWritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedActionsData == actualActionsData)

                        let expectedPredicteData = try NSJSONSerialization.dataWithJSONObject(expectedPredicateDict, options: NSJSONWritingOptions(rawValue: 0))
                        let actualBodyData = try NSJSONSerialization.dataWithJSONObject(trigger!.predicate.toNSDictionary(), options: NSJSONWritingOptions(rawValue: 0))
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
}