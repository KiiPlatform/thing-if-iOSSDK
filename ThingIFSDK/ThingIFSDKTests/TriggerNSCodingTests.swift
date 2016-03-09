//
//  TriggerNSCodingTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class TriggerNSCodingTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test1() {
        let triggerID = "dummyID";
        let enabled = true;
        let predicate = SchedulePredicate(schedule: "dummySchedule");
        let command = Command();
        let trigger = Trigger(triggerID: triggerID, enabled: enabled, predicate: predicate, command: command);
        let title = "dummyTitle"
        let description = "dummyDescription"
        let key = "dummyKey"
        let value = "dummyValue"
        let metadata: Dictionary<String, AnyObject> = [ key : value ]

        trigger.title = title
        trigger.triggerDescription = description
        trigger.metadata = metadata

        XCTAssertNotNil(trigger);
        XCTAssertEqual(trigger.triggerID, triggerID);
        XCTAssertEqual(trigger.enabled, enabled);
        XCTAssertEqual(trigger.predicate, predicate);
        XCTAssertEqual(trigger.command, command);
        XCTAssertNil(trigger.serverCode);
        XCTAssertEqual(trigger.title, title);
        XCTAssertEqual(trigger.triggerDescription, description);
        XCTAssertEqual(trigger.metadata!.count, metadata.count);
        XCTAssertEqual((trigger.metadata![key] as! String), value);

        let data = NSKeyedArchiver.archivedDataWithRootObject(trigger);

        XCTAssertNotNil(data);

        let decode = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Trigger;

        XCTAssertNotNil(decode);
        XCTAssertEqual(decode.triggerID, triggerID);
        XCTAssertEqual(decode.enabled, enabled);
        XCTAssertEqual(decode.predicate.toNSDictionary(), predicate.toNSDictionary());
        XCTAssertEqual(decode.command, command);
        XCTAssertNil(decode.serverCode);
        XCTAssertEqual(decode.title, title);
        XCTAssertEqual(decode.triggerDescription, description);
        XCTAssertEqual(decode.metadata!.count, metadata.count);
        XCTAssertEqual((decode.metadata![key] as! String), value);
    }

    func test2() {
        let triggerID = "dummyID";
        let enabled = true;
        let predicate = StatePredicate(
            condition: Condition(clause: EqualsClause(field: "f", string: "v")),
            triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE);
        let serverCode = ServerCode(endpoint: "dummyEndPoint", executorAccessToken: "dummyToken", targetAppID: nil, parameters: nil);
        let trigger = Trigger(triggerID: triggerID, enabled: enabled, predicate: predicate, serverCode: serverCode);

        XCTAssertNotNil(trigger);
        XCTAssertEqual(trigger.triggerID, triggerID);
        XCTAssertEqual(trigger.enabled, enabled);
        XCTAssertEqual(trigger.predicate, predicate);
        XCTAssertNil(trigger.command);
        XCTAssertEqual(trigger.serverCode, serverCode);
        XCTAssertNil(trigger.title);
        XCTAssertNil(trigger.triggerDescription);
        XCTAssertNil(trigger.metadata);

        let data = NSKeyedArchiver.archivedDataWithRootObject(trigger);

        XCTAssertNotNil(data);

        let decode = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Trigger;

        XCTAssertNotNil(decode);
        XCTAssertEqual(decode.triggerID, triggerID);
        XCTAssertEqual(decode.enabled, enabled);
        XCTAssertEqual(decode.predicate.toNSDictionary(), predicate.toNSDictionary());
        XCTAssertNil(decode.command);
        XCTAssertEqual(decode.serverCode, serverCode);
        XCTAssertNil(decode.title);
        XCTAssertNil(decode.triggerDescription);
        XCTAssertNil(decode.metadata);
    }
}