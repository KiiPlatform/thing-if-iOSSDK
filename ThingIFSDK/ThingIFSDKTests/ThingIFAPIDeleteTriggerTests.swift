//
//  ThingIFAPIDeleteTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/28.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIDeleteTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDeleteTrigger_success() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation =
          self.expectation(description: "testDeleteTrigger_success")

        // perform onboarding
        api.target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify delete request
        sharedMockSession.requestVerifier = makeRequestVerifier { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)",
              request.url?.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!
            )
        }
        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        api.deleteTrigger(expectedTriggerID) { triggerID, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(expectedTriggerID, triggerID)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testDeleteTrigger_404_error() throws {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let target = setting.target
        let expectation =
          self.expectation(description: "testDeleteTrigger_404_error")

        // perform onboarding
        api.target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertEqual(
              setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)",
              request.url?.absoluteString)
            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!
            )
        }

        // mock response
        let errorCode =  "TARGET_NOT_FOUND"
        let errorMessage =  "Target \(target.typedID.toString()) not found"
        sharedMockSession.mockResponse = (
          try JSONSerialization.data(
            withJSONObject: ["errorCode" : errorCode, "message": errorMessage],
            options: .prettyPrinted),
          HTTPURLResponse(
            url: URL(string:setting.app.baseURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil),
          nil)

        iotSession = MockSession.self
        api.deleteTrigger(expectedTriggerID) { triggerID, error -> Void in
            XCTAssertEqual(expectedTriggerID, triggerID)
            XCTAssertEqual(
              ThingIFError.errorResponse(
                required: ErrorResponse(
                  404,
                  errorCode: errorCode,
                  errorMessage: errorMessage)
              ),
              error
            )
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testDeleteTrigger_trigger_not_available_error() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation = self.expectation(
          description: "testDeleteTrigger_trigger_not_available_error")

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.deleteTrigger(expectedTriggerID) { triggerID, error -> Void in
            XCTAssertEqual(expectedTriggerID, triggerID)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
