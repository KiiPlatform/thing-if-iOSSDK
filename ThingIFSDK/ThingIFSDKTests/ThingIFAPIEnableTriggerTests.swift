//
//  ThingIFAPIEnableTriggerTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/28.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class ThingIFAPIEnableTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEnableTriggerEnabledSuccess() throws {
        let setting:TestSetting = TestSetting()
        let api:ThingIFAPI = setting.api
        let expectation =
          self.expectation(description: "testEnableTriggerEnabledSuccess")

        // perform onboarding
        api.target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: true,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)),
            triggersWhen: .conditionFalseToTrue),
          command: Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ],
            commandState: .sending,
            created: Date()
          )
        )

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
          (
            (
              nil,
              HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: nil),
              nil),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "PUT")

                XCTAssertEqual(
                  setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)/enable",
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
          ),
          (
            (
              try JSONSerialization.data(
                withJSONObject: expectedTrigger.makeJsonObject(),
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string: setting.app.baseURL)!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil),
              nil),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
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
                  request.allHTTPHeaderFields!)
            })
        ]

        api.enableTrigger(expectedTriggerID, enable: true) {
            trigger, error -> Void in

            XCTAssertNil(error)
            XCTAssertEqual(expectedTrigger, trigger)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testEnableTriggerDisabledSuccess() throws {
        let setting:TestSetting = TestSetting()
        let api:ThingIFAPI = setting.api
        let expectation =
          self.expectation(description: "testEnableTriggerDisabledSuccess")

        // perform onboarding
        api.target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedTrigger = Trigger(
          expectedTriggerID,
          targetID: setting.target.typedID,
          enabled: false,
          predicate: StatePredicate(
            Condition(
              EqualsClauseInTrigger(
                "alias1",
                field: "color",
                intValue: 0)),
            triggersWhen: .conditionFalseToTrue),
          command: Command(
            "429251a0-46f7-11e5-a5eb-06d9d1527620",
            targetID: setting.target.typedID,
            issuerID: setting.owner.typedID,
            aliasActions: [
              AliasAction(
                "alias1",
                actions: [
                  Action("turnPower", value: true),
                  Action("setBrightness", value: 90)
                ]
              )
            ],
            commandState: .sending,
            created: Date()
          )
        )

        iotSession = MockMultipleSession.self
        sharedMockMultipleSession.responsePairs = [
          (
            (
              nil,
              HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: nil),
              nil),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "PUT")

                XCTAssertEqual(
                  setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)/disable",
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
          ),
          (
            (
              try JSONSerialization.data(
                withJSONObject: expectedTrigger.makeJsonObject(),
                options: .prettyPrinted),
              HTTPURLResponse(
                url: URL(string: setting.app.baseURL)!,
                statusCode: 201,
                httpVersion: nil,
                headerFields: nil),
              nil),
            makeRequestVerifier() { request in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
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
                  request.allHTTPHeaderFields!)
            })
        ]

        api.enableTrigger(expectedTriggerID, enable: false) {
            trigger, error -> Void in

            XCTAssertNil(error)
            XCTAssertEqual(expectedTrigger, trigger)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
