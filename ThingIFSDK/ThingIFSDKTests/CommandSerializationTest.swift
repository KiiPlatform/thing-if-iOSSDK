//
//  CommandSerializationTest.swift
//  ThingIFSDK
//
//  Created on 2016/03/01.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class CommandSerializationTest: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testSerializeCommand() {
        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
            NSKeyedArchiver(forWritingWithMutableData: data);
        let created = NSDate(timeIntervalSince1970: 100);
        let modified = NSDate(timeIntervalSince1970: 200);
        let source: Command = Command(
                commandID: "testCommandID",
                targetID: TypedID(type: "testTargetType", id: "testTargetID"),
                issuerID: TypedID(type: "testIssuerType", id: "testIssuerID"),
                schemaName:"testSchemaName",
                schemaVersion: 1,
                actions: [],
                actionResults: [],
                commandState: CommandState.SENDING);
        source.firedByTriggerID = "testFiredByTriggerID";
        source.created = created;
        source.modified = modified;
        source.title = "testTitle";
        source.commandDescription = "testCommandDescription";
        source.encodeWithCoder(coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWithData: data);
        let target: Command = Command(coder: decoder);
        decoder.finishDecoding();

        XCTAssertEqual(source.commandID, "testCommandID");
        XCTAssertEqual(source.targetID.type, "testTargetType");
        XCTAssertEqual(source.targetID.id, "testTargetID");
        XCTAssertEqual(source.issuerID.type, "testIssuerType");
        XCTAssertEqual(source.issuerID.id, "testIssuerID");
        XCTAssertEqual(source.schemaName, "testSchemaName");
        XCTAssertEqual(source.schemaVersion, 1);
        XCTAssertEqual(source.firedByTriggerID, "testFiredByTriggerID");
        XCTAssertEqual(source.created, created);
        XCTAssertEqual(source.modified, modified);
        XCTAssertEqual(source.title, "testTitle");
        XCTAssertEqual(source.commandDescription, "testCommandDescription");

        XCTAssertEqual(source.commandID, target.commandID);
        XCTAssertEqual(source.targetID.type, target.targetID.type);
        XCTAssertEqual(source.targetID.id, target.targetID.id);
        XCTAssertEqual(source.issuerID.type, target.issuerID.type);
        XCTAssertEqual(source.issuerID.id, target.issuerID.id);
        XCTAssertEqual(source.schemaName, target.schemaName);
        XCTAssertEqual(source.schemaVersion, target.schemaVersion);
        XCTAssertEqual(source.commandState, target.commandState);
        XCTAssertEqual(source.firedByTriggerID, target.firedByTriggerID);
        XCTAssertEqual(source.created, target.created);
        XCTAssertEqual(source.modified, target.modified);
        XCTAssertEqual(source.title, target.title);
        XCTAssertEqual(source.commandDescription, target.commandDescription);
    }
}
