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
        let expectation = self.expectationWithDescription("testOnboardWithVendorThingIDAndOptionsSuccess")
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
            position: LayoutPosition.STANDALONE,
            interval: DataGroupingInterval.INTERVAL_1_MINUTE)

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = [
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify body
                let expectedBody = [
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
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                        expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
                }catch(_){
                    XCTFail()
                }
            }

            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions403Error()
    {
        let expectation = self.expectationWithDescription("testOnboardWithVendorThingIDAndOptions403Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.GATEWAY,
            interval: DataGroupingInterval.INTERVAL_15_MINUTES)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "GATEWAY",
                "dataGroupingInterval": "15_MINUTES"
            ]
            do {
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                    expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 403, HTTPVersion: nil, headerFields: nil)

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
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(403, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions404Error()
    {
        let expectation = self.expectationWithDescription("testOnboardWithVendorThingIDAndOptions404Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.ENDNODE,
            interval: DataGroupingInterval.INTERVAL_1_HOUR)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "ENDNODE",
                "dataGroupingInterval": "1_HOUR"
            ]
            do {
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                    expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 404, HTTPVersion: nil, headerFields: nil)

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
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptions500Error()
    {
        let expectation = self.expectationWithDescription("testOnboardWithVendorThingIDAndOptions500Error")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.STANDALONE,
            interval: DataGroupingInterval.INTERVAL_12_HOURS)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "vendorThingID": vendorThingID,
                "thingPassword": password,
                "thingType": setting.thingType,
                "thingProperties": thingProperties,
                "layoutPosition": "STANDALONE",
                "dataGroupingInterval": "12_HOURS"
            ]
            do {
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                    expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 500, HTTPVersion: nil, headerFields: nil)

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
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(500, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndOptionsTwiceTest()
    {
        let expectation = self.expectationWithDescription("testOnboardWithVendorThingIDAndOptionsTwiceTest")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "manufacture": "kii"
        ]
        let options = OnboardWithVendorThingIDOptions(
            thingType: setting.thingType,
            thingProperties: thingProperties,
            position: LayoutPosition.STANDALONE,
            interval: DataGroupingInterval.INTERVAL_12_HOURS)

        do {
            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
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
                case .ALREADY_ONBOARDED:
                    break
                default:
                    XCTFail("unexpected error: \(error)")
                }
        })
    }

    func testOnboardWithThingIDAndOptionsSuccess()
    {
        let expectation = self.expectationWithDescription("testOnboardWithThingIDAndOptionsSuccess")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.STANDALONE,
            interval: DataGroupingInterval.INTERVAL_1_MINUTE)

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = [
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
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
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                        expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
                }catch(_){
                    XCTFail()
                }
            }

            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptions403Error()
    {
        let expectation = self.expectationWithDescription("testOnboardWithThingIDAndOptions403Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.GATEWAY,
            interval: DataGroupingInterval.INTERVAL_30_MINUTES)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
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
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                    expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 403, HTTPVersion: nil, headerFields: nil)

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
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(403, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptions404Error()
    {
        let expectation = self.expectationWithDescription("testOnboardWithThingIDAndOptions404Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.ENDNODE,
            interval: DataGroupingInterval.INTERVAL_1_HOUR)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
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
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                    expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 404, HTTPVersion: nil, headerFields: nil)

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
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptions500Error()
    {
        let expectation = self.expectationWithDescription("testOnboardWithThingIDAndOptions500Error")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.STANDALONE,
            interval: DataGroupingInterval.INTERVAL_12_HOURS)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingWithThingIDByOwner+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
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
                let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(
                    expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                let actualBodyData = request.HTTPBody
                XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
            }catch(_){
                XCTFail()
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
            statusCode: 500, HTTPVersion: nil, headerFields: nil)

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
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(500, actualErrorResponse.httpStatusCode)
                default:
                    XCTFail("unexpected error: \(error)")
                }
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithThingIDAndOptionsTwiceTest()
    {
        let expectation = self.expectationWithDescription("testOnboardWithThingIDAndOptionsTwiceTest")
        let setting = TestSetting()
        let thingID = "dummyThingID"
        let password = "dummyPassword"
        let options = OnboardWithThingIDOptions(
            position: LayoutPosition.STANDALONE,
            interval: DataGroupingInterval.INTERVAL_12_HOURS)

        do {
            // mock response
            let thingID = "dummyThingID"
            let accessToken = "dummyAccessToken"
            let dict = ["thingID": thingID, "accessToken": accessToken]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
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
                case .ALREADY_ONBOARDED:
                    break
                default:
                    XCTFail("unexpected error: \(error)")
                }
        })
    }
}
