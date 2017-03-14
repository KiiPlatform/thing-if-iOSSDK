//
//  ThingIFAPIOnboardEndNodeTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/14.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIOnboardEndNodeTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testOnboardEndnodeWithGatewaySuccess() throws {
        let expectation = self.expectation(
          description: "testOnboardEndnodeWithGatewayThingIDSuccess")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
          "_thingType": setting.thingType,
          "manufacture": "kii"
        ]
        let firmwareVersion = "dummyFirmwareVersion"
        let thingID = "dummyThingID"
        let accessToken = "dummyAccessToken"

        // perform onboarding
        setting.api.target = Gateway(
          gatewayThingID,
          vendorThingID: vendorThingID)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
                "endNodeFirmwareVersion": firmwareVersion
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary)
        }

        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: [
              "endNodeThingID": thingID,
              "accessToken": accessToken
            ],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboard(
          PendingEndNode(
            vendorThingID,
            thingType: setting.thingType,
            thingProperties: thingProperties,
            firmwareVersion: firmwareVersion),
          endnodePassword: password) {
            (endNode, error) -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(
              EndNodeWrapper(
                thingID,
                vendorThingID: vendorThingID,
                accessToken: accessToken),
              EndNodeWrapper(endNode))
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testOnboardEndnodeWithGateway403Error() throws {
        let expectation = self.expectation(
          description: "testOnboardEndnodeWithGatewayThingID403Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
          "_thingType": setting.thingType,
          "manufacture": "kii"
        ]
        let firmwareVersion = "dummyFirmwareVersion"

        // perform onboarding
        setting.api.target = Gateway(
          gatewayThingID,
          vendorThingID: vendorThingID)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
                "endNodeFirmwareVersion": firmwareVersion
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboard(
          PendingEndNode(
            vendorThingID,
            thingType: setting.thingType,
            thingProperties: thingProperties,
            firmwareVersion: firmwareVersion),
          endnodePassword: password) { (endNode, error) -> Void in
            XCTAssertNil(endNode)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  403,
                  errorCode: "",
                  errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testOnboardEndnodeWithGateway404Error() throws {
        let expectation = self.expectation(
          description: "testOnboardEndnodeWithGatewayThingID404Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
          "_thingType": setting.thingType,
          "manufacture": "kii"
        ]
        let firmwareVersion = "dummyFirmwareVersion"

        // perform onboarding
        setting.api.target = Gateway(
          gatewayThingID,
          vendorThingID: vendorThingID)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
                "endNodeFirmwareVersion": firmwareVersion
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboard(
          PendingEndNode(
            vendorThingID,
            thingType: setting.thingType,
            thingProperties: thingProperties,
            firmwareVersion: firmwareVersion),
          endnodePassword: password) { (endNode, error) -> Void in
            XCTAssertNil(endNode)
            XCTAssertNotNil(error)
            XCTAssertNil(endNode)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  404,
                  errorCode: "",
                  errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testOnboardEndnodeWithGateway500Error() throws {
        let expectation = self.expectation(
          description: "testOnboardEndnodeWithGatewayThingID500Error")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
          "_thingType": setting.thingType,
          "manufacture": "kii"
        ]
        let firmwareVersion = "dummyFirmwareVersion"

        // perform onboarding
        setting.api.target = Gateway(
          gatewayThingID,
          vendorThingID: vendorThingID)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
              "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/onboardings",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK": SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)",
                "Content-Type": "application/vnd.kii.OnboardingEndNodeWithGatewayThingID+json"
              ],
              request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
              [
                "owner": setting.owner.typedID.toString(),
                "gatewayThingID": gatewayThingID,
                "endNodeVendorThingID": vendorThingID,
                "endNodePassword": password,
                "endNodeThingType": setting.thingType,
                "endNodeThingProperties": thingProperties,
                "endNodeFirmwareVersion": firmwareVersion
              ] as NSDictionary,
              try JSONSerialization.jsonObject(
                with: request.httpBody!,
                options: JSONSerialization.ReadingOptions.allowFragments)
                as? NSDictionary)
        }

        // mock response
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.onboard(
          PendingEndNode(
            vendorThingID,
            thingType: setting.thingType,
            thingProperties: thingProperties,
            firmwareVersion: firmwareVersion),
          endnodePassword: password) { (endNode, error) -> Void in
            XCTAssertNil(endNode)
            XCTAssertNotNil(error)
            XCTAssertNil(endNode)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  500,
                  errorCode: "",
                  errorMessage: "")),
              error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testOboardEndnodeWithGatewayWithoutOnboardingGatewayError() throws {

        let expectation = self.expectation(
          description: "testOboardEndnodeWithGatewayWithoutOnboardingGatewayError")
        let setting = TestSetting()
        let vendorThingID = "dummyVendorThingID"
        let password = "dummyPassword"
        let thingProperties = [
          "_thingType": setting.thingType,
          "manufacture": "kii"
        ]
        let firmwareVersion = "dummyFirmwareVersion"

        setting.api.onboard(
          PendingEndNode(
            vendorThingID,
            thingType: setting.thingType,
            thingProperties: thingProperties,
            firmwareVersion: firmwareVersion),
          endnodePassword: password) { (endNode, error) -> Void in
            XCTAssertNil(endNode)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

    func testOboardEndnodeWithGatewayWithEmptyVendorThingPasswordError() {
        let expectation = self.expectation(
          description: "testOboardEndnodeWithGatewayWithEmptyVendorThingPasswordError")
        let setting = TestSetting()
        let gatewayThingID = "dummyGatewayThingID"
        let vendorThingID = "dummyVendorThingID"
        let password = ""
        let thingProperties = [
          "_thingType": setting.thingType,
          "manufacture": "kii"
        ]
        let firmwareVersion = "dummyFirmwareVersion"

        // perform onboarding
        setting.api.target = Gateway(
          gatewayThingID,
          vendorThingID: vendorThingID)

        setting.api.onboard(
          PendingEndNode(
            vendorThingID,
            thingType: setting.thingType,
            thingProperties: thingProperties,
            firmwareVersion: firmwareVersion),
          endnodePassword: password) { (endNode, error) -> Void in
            XCTAssertNil(endNode)
            XCTAssertEqual(ThingIFError.unsupportedError, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error, "execution timeout")
        }
    }

}
