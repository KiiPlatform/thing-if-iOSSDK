//
//  OnboardTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardTests: SmallTestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testOnboardWithVendorThingIDAndOptionsSuccess()
    {
        let expectation = self.expectation(description: "testOnboardWithVendorThingIDAndOptionsSuccess")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let firmwareVersion = "dummyVersion"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            firmwareVersion:  firmwareVersion,
            thingProperties: thingProperties,
            position: LayoutPosition.standalone,
            interval: DataGroupingInterval.interval1Minute)

        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = [
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }

                //verify body
                let expectedBody: [String: Any] = [
                    "owner": setting.owner.typedID.toString(),
                    "vendorThingID": vendorThingID,
                    "thingPassword": password,
                    "thingType": setting.thingType,
                    "firmwareVersion": firmwareVersion,
                    "thingProperties": thingProperties,
                    "layoutPosition": "STANDALONE",
                    "dataGroupingInterval": "1_MINUTE"
                ]
                do {
                    let expectedBodyData = try JSONSerialization.data(
                        withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
                }catch(_){
                    XCTFail()
                }
            }

            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.onboardWithVendorThingID(
                vendorThingID,
                thingPassword: password,
                options: options,
                completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(target!.typedID.id, thingID)
                    XCTAssertEqual(target!.accessToken, accessToken)
                    expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions403Error()
    {
        let expectation = self.expectation(description: "testOnboardWithVendorThingIDAndOptions403Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.gateway,
            interval: DataGroupingInterval.interval15Minutes)

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody: [String : Any] = [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "GATEWAY",
                "dataGroupingInterval": "15_MINUTES"
            ]
            do {
                let expectedBodyData = try JSONSerialization.data(
                    withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                let actualBodyData = request.httpBody
                XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 403, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.onboardWithVendorThingID(
            vendorThingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(403, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions404Error()
    {
        let expectation = self.expectation(description: "testOnboardWithVendorThingIDAndOptions404Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.endnode,
            interval: DataGroupingInterval.interval1Hour)

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody: [String : Any] = [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "ENDNODE",
                "dataGroupingInterval": "1_HOUR"
            ]
            do {
                let expectedBodyData = try JSONSerialization.data(
                    withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                let actualBodyData = request.httpBody
                XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 404, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.onboardWithVendorThingID(
            vendorThingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions500Error()
    {
        let expectation = self.expectation(description: "testOnboardWithVendorThingIDAndOptions500Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.standalone,
            interval: DataGroupingInterval.interval12Hours)

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody: [String : Any] = [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "STANDALONE",
                "dataGroupingInterval": "12_HOURS"
            ]
            do {
                let expectedBodyData = try JSONSerialization.data(
                    withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                let actualBodyData = request.httpBody
                XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 500, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.onboardWithVendorThingID(
            vendorThingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(500, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptionsTwiceTest()
    {
        let expectation = self.expectation(description: "testOnboardWithVendorThingIDAndOptionsTwiceTest")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.standalone,
            interval: DataGroupingInterval.interval12Hours)

        do {
            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self

            setting.api.onboardWithVendorThingID(
                vendorThingID,
                thingPassword: password,
                options: options,
                completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(target!.typedID.id, thingID)
                    XCTAssertEqual(target!.accessToken, accessToken)
                    expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        setting.api.onboardWithVendorThingID(
            vendorThingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .alreadyOnboarded:
                    break
                default:
                    XCTFail("unexpected error: \(error)")
                }
        })
    }

    func testOnboardWithThingIDAndOptionsSuccess()
    {
        let expectation = self.expectation(description: "testOnboardWithThingIDAndOptionsSuccess")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.standalone,
            interval: DataGroupingInterval.interval1Minute)

        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = [
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }

                //verify body
                let expectedBody = [
                    "owner": setting.owner.typedID.toString(),
                    "thingID": thingID,
                    "thingPassword": password,
                    "layoutPosition": "STANDALONE",
                    "dataGroupingInterval": "1_MINUTE"
                ]
                do {
                    let expectedBodyData = try JSONSerialization.data(
                        withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
                }catch(_){
                    XCTFail()
                }
            }

            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.onboardWithThingID(
                thingID,
                thingPassword: password,
                options: options,
                completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(target!.typedID.id, thingID)
                    XCTAssertEqual(target!.accessToken, accessToken)
                    expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptions403Error()
    {
        let expectation = self.expectation(description: "testOnboardWithThingIDAndOptions403Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.gateway,
            interval: DataGroupingInterval.interval30Minutes)

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "GATEWAY",
                "dataGroupingInterval": "30_MINUTES"
            ]
            do {
                let expectedBodyData = try JSONSerialization.data(
                    withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                let actualBodyData = request.httpBody
                XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 403, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.onboardWithThingID(
            thingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(403, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptions404Error()
    {
        let expectation = self.expectation(description: "testOnboardWithThingIDAndOptions404Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.endnode,
            interval: DataGroupingInterval.interval1Hour)

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "ENDNODE",
                "dataGroupingInterval": "1_HOUR"
            ]
            do {
                let expectedBodyData = try JSONSerialization.data(
                    withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                let actualBodyData = request.httpBody
                XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 404, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.onboardWithThingID(
            thingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptions500Error()
    {
        let expectation = self.expectation(description: "testOnboardWithThingIDAndOptions500Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.standalone,
            interval: DataGroupingInterval.interval12Hours)

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "thingID": thingID,
                "thingPassword": password,
                "layoutPosition": "STANDALONE",
                "dataGroupingInterval": "12_HOURS"
            ]
            do {
                let expectedBodyData = try JSONSerialization.data(
                    withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                let actualBodyData = request.httpBody
                XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
            statusCode: 500, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.onboardWithThingID(
            thingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(500, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptionsTwiceTest()
    {
        let expectation = self.expectation(description: "testOnboardWithThingIDAndOptionsTwiceTest")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.standalone,
            interval: DataGroupingInterval.interval12Hours)

        do {
            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self

            setting.api.onboardWithThingID(
                thingID,
                thingPassword: password,
                options: options,
                completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotNil(target)
                    XCTAssertEqual(target!.typedID.id, thingID)
                    XCTAssertEqual(target!.accessToken, accessToken)
                    expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        setting.api.onboardWithThingID(
            thingID,
            thingPassword: password,
            options: options,
            completionHandler: { (target:Target?, error:ThingIFError?) -> Void in
                XCTAssertNil(target)
                XCTAssertNotNil(error)
                switch error! {
                case .alreadyOnboarded:
                    break
                default:
                    XCTFail("unexpected error: \(error)")
                }
        })
    }
}
