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
        let expectation = self.expectationWithDescription("testSuccess")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                // verify path
                let expectedPath = "\(setting.app.baseURL)/\(setting.app.siteName)/token"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let credential = "\(setting.app.appID):\(setting.app.appKey)"
                let base64Str = credential.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                let expectedHeader = [
                    "authorization": "Basic \(base64Str)",
                    "Content-Type": "application/json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                //verify body
                let expectedBody: Dictionary<String, AnyObject> = [
                    "username": username,
                    "password": password];
                self.verifyDict(expectedBody, actualData: request.HTTPBody!)
            }

            // mock response
            let dict = ["accessToken": self.ACCESSTOKEN]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
        } catch(_) {
            XCTFail("should not throw error")
        }

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmptyUsernameError()
    {
        let expectation = self.expectationWithDescription("testEmptyUsernameError")
        let setting = TestSetting()
        let password = "dummyPass"

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login("", password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .UNSUPPORTED_ERROR:
                break
            default:
                XCTFail("unknown error")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmptyPasswordError()
    {
        let expectation = self.expectationWithDescription("testEmptyPasswordError")
        let setting = TestSetting()
        let username = "dummyUser"

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: "", completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .UNSUPPORTED_ERROR:
                break
            default:
                XCTFail("unknown error")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test400Error()
    {
        let expectation = self.expectationWithDescription("test400Error")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")
            // verify path
            let expectedPath = "\(setting.app.baseURL)/\(setting.app.siteName)/token"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let credential = "\(setting.app.appID):\(setting.app.appKey)"
            let base64Str = credential.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            let expectedHeader = [
                "authorization": "Basic \(base64Str)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            //verify body
            let expectedBody: Dictionary<String, AnyObject> = [
                "username": username,
                "password": password];
            self.verifyDict(expectedBody, actualData: request.HTTPBody!)
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 400, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test401Error()
    {
        let expectation = self.expectationWithDescription("test401Error")
        let setting = TestSetting()
        let username = "dummyUser"
        let password = "dummyPass"

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")
            // verify path
            let expectedPath = "\(setting.app.baseURL)/\(setting.app.siteName)/token"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let credential = "\(setting.app.appID):\(setting.app.appKey)"
            let base64Str = credential.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            let expectedHeader = [
                "authorization": "Basic \(base64Str)",
                "Content-Type": "application/json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            //verify body
            let expectedBody: Dictionary<String, AnyObject> = [
                "username": username,
                "password": password];
            self.verifyDict(expectedBody, actualData: request.HTTPBody!)
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 401, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        let gatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        gatewayAPI.login(username, password: password, completionHandler: { (error:ThingIFError?) -> Void in
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
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
