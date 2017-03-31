//
//  OnboardedTestsBase.swift
//  ThingIFSDK
//
//  Created on 2016/05/27.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardedTestsBase: NotOnboardedYetTestsBase {

    internal var onboardedApi: ThingIFAPI! {
        get {
            return self.api
        }
    }

    override func setUp() {
        super.setUp()

        let expectation = self.expectation(description: "onboard")

        let vendorThingID = "vid-" + String(Date.init().timeIntervalSince1970)
        self.api.onboardWith(
          vendorThingID: vendorThingID,
          thingPassword: "password",
          options: OnboardWithVendorThingIDOptions(
            DEFAULT_THING_TYPE,
            firmwareVersion: DEFAULT_FIRMWAREVERSION,
            position: .standalone)) {
            target, error in
            XCTAssertNil(error)
            XCTAssertEqual(.thing, target!.typedID.type)
            XCTAssertNotNil(target!.accessToken)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
    }

    override func tearDown() {
        var triggerIDs: [String] = []

        var expectation = self.expectation(description: "list")

        self.api.listTriggers(100, paginationKey: nil) {
            triggers, paginationKey, error in
            if triggers != nil {
                for trigger in triggers! {
                    triggerIDs.append(trigger.triggerID)
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        for triggerID in triggerIDs {
            expectation = self.expectation(description: "delete")
            self.api.deleteTrigger(triggerID) { deleted, error in
                expectation.fulfill()
            }
            self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
                XCTAssertNil(error)
            }
        }

        super.tearDown()
    }

}

extension ThingIFAPI {

    internal func updateTargetState(
        _ alias: String,
        state: [String : Any],
        completionHandler: @escaping(ThingIFError?) -> Void) -> Void
    {
        if self.target == nil {
            completionHandler(ThingIFError.targetNotAvailable)
            return;
        }

        self.operationQueue.addHttpRequestOperation(
            .put,
            url: "\(self.baseURL)/thing-if/apps/\(self.appID)/targets/\(self.target!.typedID.toString())/states",
            requestHeader: self.defaultHeader + [
                "Content-Type" : "application/vnd.kii.MultipleTraitState+json"
            ],
            requestBody: [
                alias: state
            ],
            failureBeforeExecutionHandler: { completionHandler($0) }) {
                response, error in

                DispatchQueue.main.async {
                    completionHandler( error)
                }
        }
    }
}
