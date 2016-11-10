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
        let expectation = self.expectation(description: "testUpdateVendorThingIDSuccess")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.appID)/things/\(target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

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
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody = [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
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
            statusCode: 204, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                expectation.fulfill()
        })

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testUpdateVendorThingID400Error()
    {
        let expectation = self.expectation(description: "testUpdateVendorThingID400Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.appID)/things/\(target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

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
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody = [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
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
            statusCode: 400, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
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

    func testUpdateVendorThingID409Error()
    {
        let expectation = self.expectation(description: "testUpdateVendorThingID409Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let newVendorThingID = "dummyVendorThingID"
        let newPassword = "dummyPassword"

        // perform onboarding
        api._target = target

        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "PUT")

            // verify path
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.appID)/things/\(target.typedID.id)/vendor-thing-id"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

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
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }

            //verify body
            let expectedBody = [
                "_vendorThingID": newVendorThingID,
                "_password": newPassword
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
            statusCode: 409, httpVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        setting.api.updateVendorThingID(
            newVendorThingID,
            newPassword: newPassword,
            completionHandler: { (error:ThingIFError?) -> Void in
                XCTAssertNotNil(error)
                switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(409, actualErrorResponse.httpStatusCode)
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

    func testUpdateVendorThingIDWithEmptyVendorThingIDError()
    {
        let expectation = self.expectation(description: "testUpdateVendorThingIDWithEmptyVendorThingIDError")
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
                case .unsupportedError:
                    break
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

    func testUpdateVendorThingIDWithEmptyPasswordError()
    {
        let expectation = self.expectation(description: "testUpdateVendorThingIDWithEmptyPasswordError")
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
                case .unsupportedError:
                    break
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
}
