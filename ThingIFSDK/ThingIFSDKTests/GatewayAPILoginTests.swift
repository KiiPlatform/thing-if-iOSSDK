//
//  GatewayAPILoginTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPILoginTests: GatewayAPITestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testSuccess()
    {
        let expectation = self.expectation(description: "testSuccess")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                // verify path
                let expectedPath = "\(setting.app.baseURL)/\(setting.app.siteName)/token"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let credential = "\(setting.app.appID):\(setting.app.appKey)"
                let base64Str = credential.data(using: String.Encoding.utf8)!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
                let expectedHeader = [
                    "authorization": "Basic \(base64Str)",
                    "Content-Type": "application/json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                //verify body
                let expectedBody: Dictionary<String, Any> = [
                    "username": username,
                    "password": password];
                self.verifyDict(expectedBody, actualData: request.httpBody!)
            }

            // mock response
            let dict = ["accessToken": self.ACCESSTOKEN]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmptyUsernameError()
    {
        let expectation = self.expectation(description: "testEmptyUsernameError")
        let setting = TestSetting()
        let password = "dummyPass"

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login("", password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .unsupportedError:
                break
            default:
                XCTFail("unknown error")
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmptyPasswordError()
    {
        let expectation = self.expectation(description: "testEmptyPasswordError")
        let setting = TestSetting()
        let username = "dummyUser"

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: "", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .unsupportedError:
                break
            default:
                XCTFail("unknown error")
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test400Error()
    {
        let expectation = self.expectation(description: "test400Error")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            let expectedPath = "\(setting.app.baseURL)/\(setting.app.siteName)/token"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let credential = "\(setting.app.appID):\(setting.app.appKey)"
            let base64Str = credential.data(using: String.Encoding.utf8)!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            let expectedHeader = [
                "authorization": "Basic \(base64Str)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [
                "username": username,
                "password": password];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 400, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test401Error()
    {
        let expectation = self.expectation(description: "test401Error")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")
            // verify path
            let expectedPath = "\(setting.app.baseURL)/\(setting.app.siteName)/token"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let credential = "\(setting.app.appID):\(setting.app.appKey)"
            let base64Str = credential.data(using: String.Encoding.utf8)!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            let expectedHeader = [
                "authorization": "Basic \(base64Str)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            //verify body
            let expectedBody: Dictionary<String, Any> = [
                "username": username,
                "password": password];
            self.verifyDict(expectedBody, actualData: request.httpBody!)
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 401, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
