//
//  GetStateTests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GetStateTests: XCTestCase {

    let deviceToken = "dummyDeviceToken"

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func onboard(setting:TestSetting){
        let expectation = self.expectationWithDescription("onboardWithVendorThingID")

        do{
            let thingProperties:Dictionary<String, AnyObject> = ["key1":"value1", "key2":"value2"]
            let thingType = "LED"
            let vendorThingID = "th.abcd-efgh"
            let thingPassword = "dummyPassword"

            // mock response
            let dict = ["accessToken":"BrZ3M9fIqghhqhyiqnxncY6KXEFEZWJaP0894qtzu2E","thingID":"th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"]

            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)

            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)",  "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            setting.api.onboard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.typedID.toString(), "THING:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
                }else {
                    XCTFail("should success")
                }
                expectation.fulfill()
            }
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        setting.api._installationID = "dummyInstallationID"
    }
    func testGetStates_success() {
        let setting = TestSetting()

        self.onboard(setting)
        let expectation = self.expectationWithDescription("testGetStates_success")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/states")
        }

        let dict : Dictionary<String,AnyObject>? = [
            "power" : true,
            "brightness" : 70,
            "color" : 0
        ]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict!, options: .PrettyPrinted)

            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier

        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }

        setting.api._target = setting.target
        setting.api.getState() { (result, error) -> Void in

            XCTAssertNotNil(result,"should not nil")
            XCTAssertEqual(result!.count, dict?.count, "Should be equal")
            if error != nil {
                XCTFail("should not error")
            }

            for (k,v) in dict! {
                let val : AnyObject = result![k]!
                XCTAssertTrue(v === val)
            }

            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    func testGetStates_http_404() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectationWithDescription("testGetStates_http_404")
        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/states")
        }

        let dict = ["errorCode":"TARGET_NOT_FOUND","message":"error message"]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)

            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier

        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }

        setting.api._target = setting.target
        setting.api.getState() { (result, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {

                switch error! {
                case .CONNECTION:
                    XCTFail("should not be connection error")
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }
    func testGetStates_http_401() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectationWithDescription("testGetStates_http_401")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/states")
        }

        let dict = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)

            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 401, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier

        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }

        setting.api._target = setting.target
        setting.api.getState() { (result, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {

                switch error! {
                case .CONNECTION:
                    XCTFail("should not be connection error")
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }

    func testGetStates_success_then_fail() {
        let setting = TestSetting()
        self.onboard(setting)
        iotSession = MockMultipleSession.self
        let expectation = self.expectationWithDescription("testGetStates_success")
        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

        }

        let dict : Dictionary<String,AnyObject>? = [
            "power" : true,
            "brightness" : 70,
            "color" : 0
        ]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict!, options: .PrettyPrinted)
            let errorJson = try NSJSONSerialization.dataWithJSONObject(["errorCode":"INVALID_INPUT_DATA","message":"error message"], options: .PrettyPrinted)
            let mockResponse1 = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            let mockResponse2 = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 401, HTTPVersion: nil, headerFields: nil)
            MockMultipleSession.responsePairs = [
                ((data: jsonData, urlResponse: mockResponse1, error: nil),requestVerifier),
                ((data: errorJson, urlResponse: mockResponse2, error: nil),requestVerifier)
            ]

        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }

        setting.api._target = setting.target
        setting.api.getState() { (result, error) -> Void in

            XCTAssertNotNil(result,"should not nil")
            XCTAssertEqual(result!.count, dict?.count, "Should be equal")
            if error != nil {
                XCTFail("should not error")
            }
            
            for (k,v) in dict! {
                let val : AnyObject = result![k]!
                XCTAssertTrue(v === val)
            }
        }

        setting.api.getState() { (result, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {

                switch error! {
                case .CONNECTION:
                    XCTFail("should not be connection error")
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)

                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetStates_target_not_available_error() {
        let setting = TestSetting()
        let expectation = self.expectationWithDescription("testGetStates_target_not_available_error")

        setting.api.getState() { (result, error) -> Void in

            XCTAssertNil(setting.api.target)

            if error == nil{
                XCTFail("should fail")
            }else {

                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("error should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}

