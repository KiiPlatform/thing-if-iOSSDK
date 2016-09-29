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

    func testTriggerWithCommand() {
        let triggerID = "dummyID";
        let enabled = true;
        let predicate = SchedulePredicate(schedule: "dummySchedule");
        let command = Command();
        let title = "dummyTitle"
        let description = "dummyDescription"
        let key = "dummyKey"
        let value = "dummyValue"
        let metadata: Dictionary<String, AnyObject> = [ key : value ]
        let trigger = Trigger(triggerID: triggerID, targetID: TypedID(type: "thing", id: "dummyTargetID"), enabled: enabled, predicate: predicate, command: command, title: title, triggerDescription: description, metadata: metadata);

        XCTAssertNotNil(trigger);
        XCTAssertEqual(trigger.triggerID, triggerID);
        XCTAssertEqual(trigger.enabled, enabled);
        let expectedPredicate = trigger.predicate as? SchedulePredicate
        XCTAssertEqual(expectedPredicate, predicate);
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

    func testTriggerWithServerCode() {
        let triggerID = "dummyID";
        let enabled = true;
        let predicate = StatePredicate(
            condition: Condition(clause: EqualsClause(field: "f", stringValue: "v")),
            triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE);
        let serverCode = ServerCode(endpoint: "dummyEndPoint", executorAccessToken: "dummyToken", targetAppID: nil, parameters: nil);
        let trigger = Trigger(triggerID: triggerID, targetID: TypedID(type: "thing", id: "dummyTargetID"), enabled: enabled, predicate: predicate, serverCode: serverCode);

        XCTAssertNotNil(trigger);
        XCTAssertEqual(trigger.triggerID, triggerID);
        XCTAssertEqual(trigger.enabled, enabled);
        let expectedPredicate = trigger.predicate as? StatePredicate
        XCTAssertEqual(expectedPredicate, predicate);
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
