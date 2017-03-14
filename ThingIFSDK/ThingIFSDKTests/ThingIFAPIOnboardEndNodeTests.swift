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
}
