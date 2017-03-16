//
//  GetStateTests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/18/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GetTargetStateTests: SmallTestBase {

    private let ALIAS = "dummyAlias"

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetTargetStates_success() throws {
        let setting = TestSetting()

        let expectation = self.expectation(description: "testGetTargetStates_success")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody : [String : [String : Any]] = [
            "AirConditionerAlias" : [
                "power" : true,
                "currentTemperature" : 25
            ],
            "HumidityAlias" : [
                "currentHumidity" : 60
            ]
        ]
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.getTargetState() { (result, error) -> Void in

            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(responseBody as NSDictionary, result! as NSDictionary)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTargetStates_http_404() throws {
        let setting = TestSetting()

        let expectation = self.expectation(description: "testGetTargetStates_http_404")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody = ["errorCode":"TARGET_NOT_FOUND","message":"error message"]
        // mock response
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.getTargetState() { (result, error) -> Void in
            XCTAssertNil(result)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    404,
                    errorCode: responseBody["errorCode"]!,
                    errorMessage: responseBody["message"]!)),
                error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTargetStates_http_401() throws {
        let setting = TestSetting()

        let expectation = self.expectation(description: "testGetTargetStates_http_401")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        // mock response
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.getTargetState() { (result, error) -> Void in
            XCTAssertNil(result)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    401,
                    errorCode: responseBody["errorCode"]!,
                    errorMessage: responseBody["message"]!)),
                error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

    }

    func testGetStates_success_then_fail() {
        let setting = TestSetting()

        iotSession = MockMultipleSession.self
        let expectation = self.expectation(description: "testGetTargetStates_success_then_fail")

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody : [String : [String : Any]] = [
            "AirConditionerAlias" : [
                "power" : true,
                "currentTemperature" : 25
            ],
            "HumidityAlias" : [
                "currentHumidity" : 60
            ]
        ]
        let responseError = [
            "errorCode" : "INVALID_INPUT_DATA",
            "message" : "error message"
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseBody, options: .prettyPrinted)
            let errorJson = try JSONSerialization.data(withJSONObject: responseError, options: .prettyPrinted)
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

        setting.api.target = setting.target
        setting.api.getTargetState() { (result, error) -> Void in

            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(responseBody as NSDictionary, result! as NSDictionary)
        }

        setting.api.getTargetState() { (result, error) -> Void in
            XCTAssertNil(result)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    401,
                    errorCode: responseError["errorCode"]!,
                    errorMessage: responseError["message"]!)),
                error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetStates_target_not_available_error() {
        let setting = TestSetting()
        let expectation = self.expectation(description: "testGetStates_target_not_available_error")

        setting.api.getTargetState() { (result, error) -> Void in

            XCTAssertNil(setting.api.target)
            XCTAssertNil(result)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTargetState_success() throws {
        let setting = TestSetting()

        let expectation = self.expectation(description: "testGetTargetState_success")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(self.ALIAS)")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody : [String : Any] = [
            "power" : true,
            "currentTemperature" : 25
        ]
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.getTargetState(self.ALIAS) { (result, error) -> Void in

            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(responseBody as NSDictionary, result! as NSDictionary)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTargetState_http_404() throws {
        let setting = TestSetting()

        let expectation = self.expectation(description: "testGetTargetState_http_404")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(self.ALIAS)")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody = ["errorCode":"TARGET_NOT_FOUND","message":"error message"]
        // mock response
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.getTargetState(self.ALIAS) { (result, error) -> Void in
            XCTAssertNil(result)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    404,
                    errorCode: responseBody["errorCode"]!,
                    errorMessage: responseBody["message"]!)),
                error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTargetState_http_401() throws {
        let setting = TestSetting()

        let expectation = self.expectation(description: "testGetTargetState_http_401")

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(self.ALIAS)")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        // mock response
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.getTargetState(self.ALIAS) { (result, error) -> Void in
            XCTAssertNil(result)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    401,
                    errorCode: responseBody["errorCode"]!,
                    errorMessage: responseBody["message"]!)),
                error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }

    }

    func testGetTargetState_success_then_fail() {
        let setting = TestSetting()

        iotSession = MockMultipleSession.self
        let expectation = self.expectation(description: "testGetTargetState_success_then_fail")

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(self.ALIAS)")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/json"
                ],
                request.allHTTPHeaderFields!)
        }

        let responseBody : [String : Any] = [
            "power" : true,
            "currentTemperature" : 25
        ]
        let responseError = [
            "errorCode" : "INVALID_INPUT_DATA",
            "message" : "error message"
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseBody, options: .prettyPrinted)
            let errorJson = try JSONSerialization.data(withJSONObject: responseError, options: .prettyPrinted)
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

        setting.api.target = setting.target
        setting.api.getTargetState(self.ALIAS) { (result, error) -> Void in

            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertEqual(responseBody as NSDictionary, result! as NSDictionary)
        }

        setting.api.getTargetState(self.ALIAS) { (result, error) -> Void in
            XCTAssertNil(result)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    401,
                    errorCode: responseError["errorCode"]!,
                    errorMessage: responseError["message"]!)),
                error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testGetTargetState_targetNotAvailable_error() {
        let setting = TestSetting()
        let expectation = self.expectation(description: "testGetTargetState_targetNotAvailable_error")

        setting.api.getTargetState(self.ALIAS) { (result, error) -> Void in

            XCTAssertNil(setting.api.target)
            XCTAssertNil(result)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error!)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
