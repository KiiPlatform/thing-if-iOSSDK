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

        setting.api.onboardWith(
            vendorThingID: vendorThingID,
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

            setting.api.onboardWith(
                thingID: thingID,
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

        setting.api.onboardWith(
            thingID: thingID,
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
