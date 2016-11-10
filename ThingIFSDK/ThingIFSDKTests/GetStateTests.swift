//
//  GetStateTests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GetStateTests: SmallTestBase {

    let deviceToken = "dummyDeviceToken"

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func onboard(_ setting:TestSetting){
        let expectation = self.expectation(description: "onboardWithVendorThingID")

        do{
            let thingProperties:Dictionary<String, Any> = ["key1":"value1", "key2":"value2"]
            let thingType = "LED"
            let vendorThingID = "th.abcd-efgh"
            let thingPassword = "dummyPassword"

            // mock response
            let dict = ["accessToken":"BrZ3M9fIqghhqhyiqnxncY6KXEFEZWJaP0894qtzu2E","thingID":"th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"]

            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)",  "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }

            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            setting.api.onboard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.typedID.toString(), "thing:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
                }else {
                    XCTFail("should success")
                }
                expectation.fulfill()
            }
        }catch(let e){
            print(e)
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        setting.api._installationID = "dummyInstallationID"
    }
    func testGetStates_success() {
        let setting = TestSetting()

        self.onboard(setting)
        let expectation = self.expectation(description: "testGetStates_success")

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/states")
        }

        let dict : Dictionary<String, Any>? = [
            "power" : true,
            "brightness" : 70,
            "color" : 0
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict!, options: .prettyPrinted)

            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
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
                let val : Any = result![k]!
                XCTAssertTrue((v as AnyObject).isEqual(val))
            }

            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    func testGetStates_http_404() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectation(description: "testGetStates_http_404")
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/states")
        }

        let dict = ["errorCode":"TARGET_NOT_FOUND","message":"error message"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
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
                case .connection:
                    XCTFail("should not be connection error")
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }
    func testGetStates_http_401() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectation(description: "testGetStates_http_401")

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/states")
        }

        let dict = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
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
                case .connection:
                    XCTFail("should not be connection error")
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }

    func testGetStates_success_then_fail() {
        let setting = TestSetting()
        self.onboard(setting)
        iotSession = MockMultipleSession.self
        let expectation = self.expectation(description: "testGetStates_success")
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(setting.target.typedID.toString())/states"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "content-type": "application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

        }

        let dict : Dictionary<String, Any>? = [
            "power" : true,
            "brightness" : 70,
            "color" : 0
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict!, options: .prettyPrinted)
            let errorJson = try JSONSerialization.data(withJSONObject: ["errorCode":"INVALID_INPUT_DATA","message":"error message"], options: .prettyPrinted)
            let mockResponse1 = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let mockResponse2 = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
            iotSession = MockMultipleSession.self
            sharedMockMultipleSession.responsePairs = [
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
                let val : Any = result![k]!
                XCTAssertTrue((v as AnyObject).isEqual(val))
            }
        }

        setting.api.getState() { (result, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {

                switch error! {
                case .connection:
                    XCTFail("should not be connection error")
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)

                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetStates_target_not_available_error() {
        let setting = TestSetting()
        let expectation = self.expectation(description: "testGetStates_target_not_available_error")

        setting.api.getState() { (result, error) -> Void in

            XCTAssertNil(setting.api.target)

            if error == nil{
                XCTFail("should fail")
            }else {

                switch error! {
                case .targetNotAvailable:
                    break
                default:
                    XCTFail("error should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}

