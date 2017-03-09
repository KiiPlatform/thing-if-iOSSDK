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
