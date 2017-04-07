//
//  ThingIFAPIListTriggeredServerCodeResultsTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/28.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIListTriggeredServerCodeResultsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    override class func defaultTestSuite() -> XCTestSuite { //TODO: This is temporary to mark crashed test, remove this later

        let testSuite = XCTestSuite(name: NSStringFromClass(self))

        return testSuite
    }

    func testListTriggeredServerCodeResultsTests_success() throws {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation = self.expectation(description: "testPostNewServerCodeTrigger_success")
        let triggerID = "abcdefgHIJKLMN1234567"

        let expectedNextPaginationKey = "1234567abcde"
        let expectedBestEffortLimit = 2

        let expectedFirstTriggeredServerCodeResults = [
          TriggeredServerCodeResult(
            true,
            executedAt: Date(
              timeIntervalSince1970InMillis: 1454474985511),
            endpoint: "func",
            returnedValue: 12345),
          TriggeredServerCodeResult(
            false,
            executedAt: Date(
              timeIntervalSince1970InMillis: 1454474985511),
            endpoint: "func",
            error: ServerError("RuntimeError"))
        ]

        let expectedSecondTriggeredServerCodeResults = [
          TriggeredServerCodeResult(
            false,
            executedAt: Date(
              timeIntervalSince1970InMillis: 1454474985511),
            endpoint: "func",
            error: ServerError("ReferenceError")),
          TriggeredServerCodeResult(
            true,
            executedAt: Date(
              timeIntervalSince1970InMillis: 1454474985511),
            endpoint :"func",
            returnedValue: ["field" :"abcd"])
        ]

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
          (
            (
              try JSONSerialization.data(
                withJSONObject:
                  [
                    "nextPaginationKey" : expectedNextPaginationKey,
                    "triggerServerCodeResults":
                      expectedFirstTriggeredServerCodeResults.map {
                          $0.makeJsonObject()
                      }
                  ],
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
              nil
            ),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "GET")

                XCTAssertEqual(
                  setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)/results/server-code",
                  request.url?.absoluteString)
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
          ),
          (
            (
              (
                try JSONSerialization.data(
                  withJSONObject: [
                    "triggerServerCodeResults":
                      expectedSecondTriggeredServerCodeResults.map {
                          $0.makeJsonObject()
                      }
                  ], options: .prettyPrinted),
                HTTPURLResponse(
                  url: URL(string:setting.app.baseURL)!,
                  statusCode: 200,
                  httpVersion: nil,
                  headerFields: nil),
                nil
              ),
              makeRequestVerifier() { request in
                  XCTAssertEqual(request.httpMethod, "GET")
                  XCTAssertEqual(
                    setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)/results/server-code?paginationKey=\(expectedNextPaginationKey)&bestEffortLimit=\(expectedBestEffortLimit)",
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
            )
          )
        ]

        api.target = setting.target
        api.listTriggeredServerCodeResults(
          triggerID) {
            results, paginationKey, error -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(expectedFirstTriggeredServerCodeResults, results!)
            XCTAssertEqual(expectedNextPaginationKey, paginationKey)

            api.listTriggeredServerCodeResults(
              triggerID,
              bestEffortLimit: expectedBestEffortLimit,
              paginationKey: paginationKey) {
                (results, paginationKey, error) -> Void in

                XCTAssertNil(error)
                XCTAssertNil(paginationKey)
                XCTAssertEqual(
                  expectedSecondTriggeredServerCodeResults,
                  results!)
                expectation.fulfill()
            }
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
