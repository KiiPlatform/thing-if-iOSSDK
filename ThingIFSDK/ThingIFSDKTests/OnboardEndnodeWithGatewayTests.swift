//
//  OnboardEndnodeWithGatewayThingIDTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardEndnodeWithGatewayThingIDTests: SmallTestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testOnboardEndnodeWithGatewaySuccess()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingIDSuccess")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = [
                    "X-kii-appid": setting.appID,
                    "x-kii-appkey": setting.appKey,
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify body
                let expectedBody = [
                    "owner": setting.owner.typedID.toString(),
                    "gatewayThingID": gatewayThingID,
                    "endNodeVendorThingID": vendorThingID,
                    "endNodePassword": password,
                    "endNodeThingType": setting.thingType,
                    "endNodeThingProperties": thingProperties
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
            let dict = ["endNodeThingID": thingID, "accessToken": accessToken]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            let src = [
                "vendorThingID": vendorThingID,
                "thingType": setting.thingType,
                "thingProperties": thingProperties
            ]
            let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
            setting.api.onboardEndnodeWithGateway(
                pending,
                endnodePassword: password,
                completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotNil(endNode)
                    XCTAssertEqual(endNode!.typedID.id, thingID)
                    XCTAssertEqual(endNode!.accessToken, accessToken)
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

    func testOnboardEndnodeWithGateway403Error()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingID403Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties
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

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
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

    func testOnboardEndnodeWithGateway404Error()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingID404Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties
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

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
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

    func testOnboardEndnodeWithGateway500Error()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingID500Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties
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

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
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

    func testOboardEndnodeWithGatewayWithoutOnboardingGatewayError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithoutOnboardingGatewayError")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
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

    func testOboardEndnodeWithGatewayWithNilVendorThingIDError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithNilVendorThingIDError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        let src: Dictionary<String, AnyObject> = [
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
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

    func testOboardEndnodeWithGatewayWithEmptyVendorThingIDError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithEmptyVendorThingIDError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        let src = [
            "vendorThingID": "",
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
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

    func testOboardEndnodeWithGatewayWithEmptyVendorThingPasswordError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithEmptyVendorThingPasswordError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = ""
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
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

    func testOnboardEndnodeWithGatewayOptionsSuccess()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingIDSuccess")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]
        let options = OnboardEndnodeWithGatewayOptions(interval: DataGroupingInterval.INTERVAL_1_MINUTE)

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = [
                    "X-kii-appid": setting.appID,
                    "x-kii-appkey": setting.appKey,
                    "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                    "authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify body
                let expectedBody = [
                    "owner": setting.owner.typedID.toString(),
                    "gatewayThingID": gatewayThingID,
                    "endNodeVendorThingID": vendorThingID,
                    "endNodePassword": password,
                    "endNodeThingType": setting.thingType,
                    "endNodeThingProperties": thingProperties,
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
            let dict = ["endNodeThingID": thingID, "accessToken": accessToken]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            let src = [
                "vendorThingID": vendorThingID,
                "thingType": setting.thingType,
                "thingProperties": thingProperties
            ]
            let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
            setting.api.onboardEndnodeWithGateway(
                pending,
                endnodePassword: password,
                options: options,
                completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotNil(endNode)
                    XCTAssertEqual(endNode!.typedID.id, thingID)
                    XCTAssertEqual(endNode!.accessToken, accessToken)
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

    func testOnboardEndnodeWithGatewayOptions403Error()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingID403Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]
        let options = OnboardEndnodeWithGatewayOptions(interval: DataGroupingInterval.INTERVAL_15_MINUTES)

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
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

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: options,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
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

    func testOnboardEndnodeWithGatewayOptions404Error()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingID404Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]
        let options = OnboardEndnodeWithGatewayOptions(interval: DataGroupingInterval.INTERVAL_30_MINUTES)

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
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
            statusCode: 404, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: options,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
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

    func testOnboardEndnodeWithGatewayOptions500Error()
    {
        let expectation = self.expectationWithDescription("testOnboardEndnodeWithGatewayThingID500Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]
        let options = OnboardEndnodeWithGatewayOptions(interval: DataGroupingInterval.INTERVAL_1_HOUR)

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.appID)/onboardings"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
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
            statusCode: 500, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: options,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
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

    func testOboardEndnodeWithGatewayOptionsWithoutOnboardingGatewayError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithoutOnboardingGatewayError")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: nil,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
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

    func testOboardEndnodeWithGatewayOptionsWithNilVendorThingIDError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithNilVendorThingIDError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        let src: Dictionary<String, AnyObject> = [
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: nil,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
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

    func testOboardEndnodeWithGatewayOptionsWithEmptyVendorThingIDError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithEmptyVendorThingIDError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        let src = [
            "vendorThingID": "",
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: nil,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
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

    func testOboardEndnodeWithGatewayOptionsWithEmptyVendorThingPasswordError()
    {
        let expectation = self.expectationWithDescription("testOboardEndnodeWithGatewayWithEmptyVendorThingPasswordError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = ""
        let thingProperties = [
            "_thingType": setting.thingType,
            "manufacture": "kii"
        ]

        // perform onboarding
        setting.api._target = Gateway(thingID: gatewayThingID, vendorThingID: vendorThingID)

        let src = [
            "vendorThingID": vendorThingID,
            "thingProperties": thingProperties
        ]
        let pending = PendingEndNode(json: src as! Dictionary<String, AnyObject>)
        setting.api.onboardEndnodeWithGateway(
            pending,
            endnodePassword: password,
            options: nil,
            completionHandler: { (endNode:EndNode?, error:ThingIFError?) -> Void in
                XCTAssertNil(endNode)
                XCTAssertNotNil(error)
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
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
}
