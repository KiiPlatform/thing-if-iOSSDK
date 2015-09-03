//
//  EnableTriggerTests.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class EnableTriggerTests: XCTestCase {
    let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

    let schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)

    let baseURLString = "https://small-tests.internal.kii.com"

    var api: IoTCloudAPI!

    let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()
        api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://small-tests.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testEnableTrigger_success() {
        let expectation = self.expectationWithDescription("enableTriggerTests")

        // perform onboarding
        api._target = target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify put request
        let putRequestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PUT")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        //verify get request
        let getRequestVerifier: ((NSURLRequest) -> Void) = {(request) in}

        // mock patch success response
        let mockResponse1 = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 204, HTTPVersion: nil, headerFields: nil)
        // mock get response
        let commandDict = ["schema": self.schema.name, "schemaVersion": self.schema.version, "target": self.target.targetType.toString(), "issuer": self.owner.ownerID.toString(), "actions": [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]]
        let dict = ["triggerID": expectedTriggerID, "predicate": ["eventSource":"states", "triggersWhen":"CONDITION_FALSE_TO_TRUE", "condition": ["type":"eq","field":"color", "value": 0]], "command": commandDict, "disabled": false]
        var jsonData: NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
        }catch(_){
            XCTFail()
        }
        let mockResponse2 = NSHTTPURLResponse(URL: NSURL(string: self.baseURLString)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

        iotSession = MockMultipleSession.self
        MockMultipleSession.responsePairs = [
            ((data: nil, urlResponse: mockResponse1, error: nil),putRequestVerifier),
            ((data: jsonData!, urlResponse: mockResponse2, error: nil),getRequestVerifier)
        ]

        api.enableTrigger(expectedTriggerID, enable: true) { (trigger, error) -> Void in
            if error == nil{
                XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                XCTAssertEqual(trigger!.targetID.toString(), self.target.targetType.toString())
                XCTAssertEqual(trigger!.enabled, true)
                XCTAssertNotNil(trigger!.predicate)
                XCTAssertEqual(trigger!.command.commandID, "")
            }else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEnableTrigger_404_error() {
        let expectation = self.expectationWithDescription("enableTrigger404Error")

        // perform onboarding
        api._target = target

        do{
            let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.targetType.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "PUT")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.enableTrigger(triggerID, enable: false, completionHandler: { (trigger, error) -> Void in
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

    func testEnableTrigger_trigger_not_available_error() {
        let expectation = self.expectationWithDescription("testEnableTrigger_trigger_not_available_error")

        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.enableTrigger(triggerID, enable: true, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE error")
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