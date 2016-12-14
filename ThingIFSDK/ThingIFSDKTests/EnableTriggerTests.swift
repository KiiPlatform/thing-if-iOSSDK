//
//  EnableTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class EnableTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testEnableTrigger_success() {
        let setting:TestSetting = TestSetting()
        let api:ThingIFAPI = setting.api
        let expectation = self.expectation(description: "enableTriggerTests")

        // perform onboarding
        api._target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify put request
        let putRequestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            // check X-Kii-SDK header. (Just randomly choosed this test for checking this header.)
            let p = "sn=it;sv=\\d*\\.\\d*\\.\\d*;pv=\\d*\\.\\d*"
            do {
                let regexp:NSRegularExpression? = try NSRegularExpression(pattern: p, options: NSRegularExpression.Options.anchorsMatchLines)
                let sdkHeader:String = request.value(forHTTPHeaderField: "X-Kii-SDK")!
                print ("header: \(sdkHeader)")
                let matches = regexp?.matches(in: sdkHeader, options: [], range: NSMakeRange(0, sdkHeader.utf8.count))
                XCTAssertEqual(1, matches!.count)
            } catch(_) {
                XCTFail()
            }

            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)/enable")
        }

        //verify get request
        let getRequestVerifier: ((URLRequest) -> Void) = {(request) in}

        // mock patch success response
        let mockResponse1 = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: nil)
        // mock get response
        let commandDict: [String : Any] = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]]
        let dict: [String : Any] = ["triggerID": expectedTriggerID, "predicate": ["eventSource":"STATES", "triggersWhen":"CONDITION_FALSE_TO_TRUE", "condition": ["type":"eq","field":"color", "value": 0]], "command": commandDict, "disabled": false]

        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }catch(_){
            XCTFail()
        }
        let mockResponse2 = HTTPURLResponse(url: URL(string: setting.app.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
            ((data: nil, urlResponse: mockResponse1, error: nil),putRequestVerifier),
            ((data: jsonData!, urlResponse: mockResponse2, error: nil),getRequestVerifier)
        ]

        api.enableTrigger(expectedTriggerID, enable: true) { (trigger, error) -> Void in
            if error == nil{
                XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                XCTAssertEqual(trigger!.enabled, true)
                XCTAssertNotNil(trigger!.predicate)
                XCTAssertEqual(trigger!.command!.commandID, "")
            }else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func testDisableTrigger_success() {
        let setting:TestSetting = TestSetting()
        let api:ThingIFAPI = setting.api
        let expectation = self.expectation(description: "enableTriggerTests")
        
        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        
        // verify put request
        let putRequestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)/disable")
        }
        
        //verify get request
        let getRequestVerifier: ((URLRequest) -> Void) = {(request) in}
        
        // mock patch success response
        let mockResponse1 = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: nil)
        // mock get response
        let commandDict: [String : Any] = ["schema": setting.schema, "schemaVersion": setting.schemaVersion, "target": setting.target.typedID.toString(), "issuer": setting.owner.typedID.toString(), "actions": [["turnPower":["power":true]],["setBrightness":["bribhtness":90]]]]
        let dict: [String : Any] = ["triggerID": expectedTriggerID, "predicate": ["eventSource":"STATES", "triggersWhen":"CONDITION_FALSE_TO_TRUE", "condition": ["type":"eq","field":"color", "value": 0]], "command": commandDict, "disabled": false]
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }catch(_){
            XCTFail()
        }
        let mockResponse2 = HTTPURLResponse(url: URL(string: setting.app.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
            ((data: nil, urlResponse: mockResponse1, error: nil),putRequestVerifier),
            ((data: jsonData!, urlResponse: mockResponse2, error: nil),getRequestVerifier)
        ]
        
        api._target = setting.target
        api.enableTrigger(expectedTriggerID, enable: false) { (trigger, error) -> Void in
            if error == nil{
                XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                XCTAssertEqual(trigger!.enabled, true)
                XCTAssertNotNil(trigger!.predicate)
                XCTAssertEqual(trigger!.command!.commandID, "")
            }else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEnableTrigger_404_error() {
        let expectation = self.expectation(description: "enableTrigger404Error")
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
                XCTAssertEqual(request.httpMethod, "PUT")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)/disable")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.enableTrigger(triggerID, enable: false, completionHandler: { (trigger, error) -> Void in
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

    func testEnableTrigger_trigger_not_available_error() {
        let expectation = self.expectation(description: "testEnableTrigger_trigger_not_available_error")
        let setting = TestSetting()
        let api = setting.api
        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.enableTrigger(triggerID, enable: true, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .targetNotAvailable:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE error")
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
