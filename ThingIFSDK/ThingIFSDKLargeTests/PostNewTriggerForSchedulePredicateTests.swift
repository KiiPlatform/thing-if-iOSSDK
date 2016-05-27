//
//  PostNewTriggerForSchedulePredicateTests.swift
//  ThingIFSDK
//
//  Created on 2016/05/20.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class TestSetting: NSObject {
    let appID: String
    let appKey: String
    let hostName: String
    let tag: String?

    override init() {
        let path = NSBundle(
                forClass:TestSetting.self).pathForResource(
                       "TestSetting",
                       ofType:"plist")

        let dict: Dictionary = NSDictionary(
                contentsOfFile: path!) as! Dictionary<String, AnyObject>

        self.appID = dict["appID"] as! String
        self.appKey = dict["appKey"] as! String
        self.hostName = dict["hostName"] as! String
        self.tag = nil
    }
}

class PostNewTriggerForSchedulePredicateTests: XCTestCase {

    internal let TEST_TIMEOUT = 5.0
    internal let DEMO_THING_TYPE = "LED"
    internal let DEMO_SCHEMA_NAME = "SmartLightDemo"
    internal let DEMO_SCHEMA_VERSION = 1

    internal var onboardedApi: ThingIFAPI?

    override func setUp() {
        super.setUp()

        let setting = TestSetting();
        let userInfo: Dictionary<String, AnyObject> =
            createPseudoUser(
                setting.appID,
                appKey: setting.appKey,
                hostName: setting.hostName)
        let owner = Owner(
                typedID: TypedID(
                           type: "user",
                           id: userInfo["userID"]! as! String),
                accessToken: userInfo["_accessToken"]! as! String)
        let app = AppBuilder(
                appID: setting.appID,
                appKey: setting.appKey,
                hostName: setting.hostName).build()
        let api = ThingIFAPIBuilder(
                app: app,
                owner: owner,
                tag: setting.tag).build()


        let expectation = self.expectationWithDescription("onboard")

        api.onboard(
            "vendorThingID5",
            thingPassword: "password",
            thingType: DEMO_THING_TYPE,
            thingProperties: nil,
            completionHandler: {
                (target, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual("thing", target!.typedID.type)
                    XCTAssertNotEqual(target!.accessToken, nil)
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        self.onboardedApi = api
    }

    override func tearDown() {
        var triggerIDs: [String] = []
        let api = self.onboardedApi!

        var expectation = self.expectationWithDescription("list")

        api.listTriggers(
            100,
            paginationKey: nil,
            completionHandler: {
                (triggers, paginationKey, error) -> Void in
                    if triggers != nil {
                        for trigger in triggers! {
                            triggerIDs.append(trigger.triggerID)
                        }
                    }
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        for triggerID in triggerIDs {
            expectation = self.expectationWithDescription("delete")
            api.deleteTrigger(
                triggerID ,
                completionHandler: {
                    (deleted, error) -> Void in
                    expectation.fulfill()
                })
            self.waitForExpectationsWithTimeout(TEST_TIMEOUT) {
                (error) -> Void in
                    if error != nil {
                        XCTFail("error")
                    }
            }
        }

        super.tearDown()
    }

    func createPseudoUser(
            appID: String,
            appKey: String,
            hostName: String) -> Dictionary<String, AnyObject> {
        let request = NSMutableURLRequest(
                URL: NSURL(string: "https://\(hostName)/api/apps/\(appID)/users")!)
        request.HTTPMethod = "POST"
        request.addValue(appID, forHTTPHeaderField: "X-Kii-AppID")
        request.addValue(appKey, forHTTPHeaderField: "X-Kii-AppKey")
        request.addValue(
            "application/vnd.kii.RegistrationAndAuthorizationRequest+json",
            forHTTPHeaderField: "Content-Type")
        request.HTTPBody =
            ("{}" as NSString).dataUsingEncoding(NSUTF8StringEncoding)

        let expectation = self.expectationWithDescription("Create user")

        let session =
            NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var data: NSData?
        let dataTask = session.dataTaskWithRequest(
                           request,
                           completionHandler: { (receivedData, response, error) -> Void in
                               data = receivedData
                               expectation.fulfill()
            })
        dataTask.resume()
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        return try! NSJSONSerialization.JSONObjectWithData(
                   data!,
                   options:.AllowFragments) as! Dictionary<String, AnyObject>
    }

    func testSuccess() {

        let api = self.onboardedApi!
        let onboardedTarget = api.target!

        let colorActions: [Dictionary<String, AnyObject>] = [
            [
                "setColor": [128, 0, 255]
            ],
            [
                "setColorTemperature": 25
            ]
        ]

        var triggerID1: String?

        var expectation =
            self.expectationWithDescription("post trigger for color")
        api.postNewTrigger(
            DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: colorActions,
            predicate: SchedulePredicate(schedule: "1 * * * *"),
            completionHandler: {
                (trigger, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertNotEqual(trigger!.triggerID, nil)
                    XCTAssertTrue(trigger!.enabled)
                    XCTAssertNil(trigger!.serverCode)

                    // check command.
                    XCTAssertEqual("", trigger!.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger!.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger!.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger!.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger!.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger!.command!.commandState)
                    XCTAssertNil(trigger!.command!.firedByTriggerID)
                    XCTAssertNil(trigger!.command!.created)
                    XCTAssertNil(trigger!.command!.modified)
                    XCTAssertEqual(colorActions, trigger!.command!.actions)
                    XCTAssertEqual([], trigger!.command!.actionResults)

                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger!.predicate.getEventSource())
                    XCTAssertEqual("1 * * * *",
                                   (trigger!.predicate
                                        as! SchedulePredicate).schedule)

                    triggerID1 = trigger!.triggerID
                    expectation.fulfill()
            }
        )
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        let powerAction: [Dictionary<String, AnyObject>] = [
            [
                "turnPower": true
            ],
            [
                "setBrightness": 50
            ]
        ]

        var triggerID2: String?

        expectation = self.expectationWithDescription("post trigger for power")
        api.postNewTrigger(
            DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: powerAction,
            predicate: SchedulePredicate(schedule: "* 1 * * *"),
            completionHandler: {
                (trigger, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertNotEqual(trigger!.triggerID, nil)
                    XCTAssertTrue(trigger!.enabled)
                    XCTAssertNil(trigger!.serverCode)

                    // check command.
                    XCTAssertEqual("", trigger!.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger!.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger!.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger!.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger!.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger!.command!.commandState)
                    XCTAssertNil(trigger!.command!.firedByTriggerID)
                    XCTAssertNil(trigger!.command!.created)
                    XCTAssertNil(trigger!.command!.modified)
                    XCTAssertEqual(powerAction, trigger!.command!.actions)
                    XCTAssertEqual([], trigger!.command!.actionResults)

                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger!.predicate.getEventSource())
                    XCTAssertEqual("* 1 * * *",
                                   (trigger!.predicate
                                        as! SchedulePredicate).schedule)

                    triggerID2 = trigger!.triggerID
                    expectation.fulfill()
            }
        )
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription("list trigger first")
        api.listTriggers(
            100,
            paginationKey: nil,
            completionHandler: {
                (triggers, paginationKey, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(2, triggers!.count)
                    for trigger in triggers! {
                        if trigger.triggerID == triggerID1 {
                            XCTAssertNotEqual(trigger, nil)
                            XCTAssertEqual(triggerID1, trigger.triggerID)
                            XCTAssertTrue(trigger.enabled)
                            XCTAssertNil(trigger.serverCode)

                            // check command.
                            XCTAssertEqual("", trigger.command!.commandID)
                            XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                           trigger.command!.schemaName)
                            XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                           trigger.command!.schemaVersion)
                            XCTAssertEqual(onboardedTarget.typedID,
                                           trigger.command!.targetID)
                            XCTAssertEqual(api.owner.typedID,
                                           trigger.command!.issuerID)
                            XCTAssertEqual(CommandState.SENDING,
                                           trigger.command!.commandState)
                            XCTAssertNil(trigger.command!.firedByTriggerID)
                            XCTAssertNil(trigger.command!.created)
                            XCTAssertNil(trigger.command!.modified)
                            XCTAssertEqual(colorActions,
                                           trigger.command!.actions)
                            XCTAssertEqual([], trigger.command!.actionResults)

                            // check predicate
                            XCTAssertEqual(EventSource.Schedule,
                                           trigger.predicate.getEventSource())
                            XCTAssertEqual("1 * * * *",
                                           (trigger.predicate
                                                as! SchedulePredicate).schedule)
                        } else if trigger.triggerID == triggerID2 {
                            XCTAssertNotEqual(trigger, nil)
                            XCTAssertEqual(triggerID2, trigger.triggerID)
                            XCTAssertTrue(trigger.enabled)
                            XCTAssertNil(trigger.serverCode)

                            // check command.
                            XCTAssertEqual("", trigger.command!.commandID)
                            XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                           trigger.command!.schemaName)
                            XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                           trigger.command!.schemaVersion)
                            XCTAssertEqual(onboardedTarget.typedID,
                                           trigger.command!.targetID)
                            XCTAssertEqual(api.owner.typedID,
                                           trigger.command!.issuerID)
                            XCTAssertEqual(CommandState.SENDING,
                                           trigger.command!.commandState)
                            XCTAssertNil(trigger.command!.firedByTriggerID)
                            XCTAssertNil(trigger.command!.created)
                            XCTAssertNil(trigger.command!.modified)
                            XCTAssertEqual(powerAction,
                                           trigger.command!.actions)
                            XCTAssertEqual([], trigger.command!.actionResults)

                            // check predicate
                            XCTAssertEqual(EventSource.Schedule,
                                           trigger.predicate.getEventSource())
                            XCTAssertEqual("* 1 * * *",
                                           (trigger.predicate
                                                as! SchedulePredicate).schedule)
                        }
                    }
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription("delete trigger")
        api.deleteTrigger(
            triggerID1!,
            completionHandler: {
                (deleted, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(triggerID1, deleted)
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        let modifiedPowerAction: [Dictionary<String, AnyObject>] = [
            [
                "turnPower": true
            ],
            [
                "setBrightness": 100
            ]
        ]

        expectation = self.expectationWithDescription("patch trigger")
        api.patchTrigger(
            triggerID2!,
            schemaName: DEMO_SCHEMA_NAME,
            schemaVersion: DEMO_SCHEMA_VERSION,
            actions: modifiedPowerAction,
            predicate: SchedulePredicate(schedule: "* * 1 * *"),
            completionHandler: {
                (trigger, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertEqual(triggerID2, trigger!.triggerID)
                    XCTAssertTrue(trigger!.enabled)
                    XCTAssertNil(trigger!.serverCode)

                    // check command.
                    XCTAssertEqual("", trigger!.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger!.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger!.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger!.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger!.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger!.command!.commandState)
                    XCTAssertNil(trigger!.command!.firedByTriggerID)
                    XCTAssertNil(trigger!.command!.created)
                    XCTAssertNil(trigger!.command!.modified)
                    XCTAssertEqual(modifiedPowerAction,
                                   trigger!.command!.actions)
                    XCTAssertEqual([], trigger!.command!.actionResults)

                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger!.predicate.getEventSource())
                    XCTAssertEqual("* * 1 * *",
                                   (trigger!.predicate
                                        as! SchedulePredicate).schedule)

                    expectation.fulfill()
            }
        )
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }

        expectation = self.expectationWithDescription("list trigger second")
        api.listTriggers(
            100,
            paginationKey: nil,
            completionHandler: {
                (triggers, paginationKey, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(1, triggers!.count)
                    let trigger = triggers![0]
                    XCTAssertNotEqual(trigger, nil)
                    XCTAssertEqual(triggerID2, trigger.triggerID)
                    XCTAssertTrue(trigger.enabled)
                    XCTAssertNil(trigger.serverCode)

                            // check command.
                    XCTAssertEqual("", trigger.command!.commandID)
                    XCTAssertEqual(self.DEMO_SCHEMA_NAME,
                                   trigger.command!.schemaName)
                    XCTAssertEqual(self.DEMO_SCHEMA_VERSION,
                                   trigger.command!.schemaVersion)
                    XCTAssertEqual(onboardedTarget.typedID,
                                   trigger.command!.targetID)
                    XCTAssertEqual(api.owner.typedID,
                                   trigger.command!.issuerID)
                    XCTAssertEqual(CommandState.SENDING,
                                   trigger.command!.commandState)
                    XCTAssertNil(trigger.command!.firedByTriggerID)
                    XCTAssertNil(trigger.command!.created)
                    XCTAssertNil(trigger.command!.modified)
                    XCTAssertEqual(modifiedPowerAction,
                                   trigger.command!.actions)
                    XCTAssertEqual([], trigger.command!.actionResults)
                    // check predicate
                    XCTAssertEqual(EventSource.Schedule,
                                   trigger.predicate.getEventSource())
                    XCTAssertEqual("* * 1 * *",
                                   (trigger.predicate
                                    as! SchedulePredicate).schedule)
                    expectation.fulfill()
            })
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("error")
            }
        }
    }
}
