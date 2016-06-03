//
//  UpdateVendorThingIDTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class UpdateVendorThingIDTests: SmallTestBase {

    override func setUp()
    {
        super.setUp()
    }

    override func tearDown()
    {
        super.tearDown()
    }

    func testUpdateVendorThingIDSuccess()
    {
        let expectation = self.expectationWithDescription("testUpdateVendorThingIDSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PUT")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/api/apps/\(setting.appID)/things/\(target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.VendorThingIDUpdateRequest+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
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
            statusCode: 204, HTTPVersion: nil, headerFields: nil)

        MockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        MockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testUpdateVendorThingID400Error()
    {
        let expectation = self.expectationWithDescription("testUpdateVendorThingID400Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PUT")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/api/apps/\(setting.appID)/things/\(target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.VendorThingIDUpdateRequest+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
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
            statusCode: 400, HTTPVersion: nil, headerFields: nil)

        MockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        MockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
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

    func testUpdateVendorThingID409Error()
    {
        let expectation = self.expectationWithDescription("testUpdateVendorThingID409Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "PUT")

            // verify path
            let expectedPath = "\(setting.api.baseURL!)/api/apps/\(setting.appID)/things/\(target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

            //verify header
            let expectedHeader = [
                "X-kii-appid": setting.appID,
                "x-kii-appkey": setting.appKey,
                "x-kii-sdk": SDKVersion.sharedInstance.kiiSDKHeader,
                "authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.VendorThingIDUpdateRequest+json"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }

            //verify body
            let expectedBody = [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
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
            statusCode: 409, HTTPVersion: nil, headerFields: nil)

        MockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        MockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(409, actualErrorResponse.httpStatusCode)
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

    func testUpdateVendorThingIDWithEmptyVendorThingIDError()
    {
        let expectation = self.expectationWithDescription("testUpdateVendorThingIDWithEmptyVendorThingIDError")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = ""
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
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

    func testUpdateVendorThingIDWithEmptyPasswordError()
    {
        let expectation = self.expectationWithDescription("testUpdateVendorThingIDWithEmptyPasswordError")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = ""

        // perform onboarding
        api._target = target

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
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
