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

    class func isSameArray(
            _ source: [Dictionary<String, Any>],
            target: [Dictionary<String, Any>]) -> Bool {
        if source.count != target.count {
            return false;
        }
        for index in 0..<source.count {
            if !CommandSerializationTest.isSameDictionary(
                   source[index], target: target[index]) {
                return false;
            }
        }
        return true
    }

    class func isSameDictionary(
            _ source: Dictionary<String, Any>,
            target: Dictionary<String, Any>) -> Bool {
        if source.count != target.count {
            return false;
        }
        for (key, value) in source {
            let targetValue = target[key];
            if targetValue == nil {
                return false;
            }

            if value is Dictionary<String, Any> &&
                     targetValue is Dictionary<String, Any> {
                return CommandSerializationTest.isSameDictionary(
                    value as! Dictionary<String, Any>,
                    target: targetValue as! Dictionary<String, Any>)
            } else if value is Int && targetValue is Int {
                if value as! Int != targetValue as! Int {
                    return false;
                }
                continue;
            } else if value is Double && targetValue is Double {
                if value as! Double != targetValue as! Double {
                    return false;
                }
                continue;
            } else if value is Float && targetValue is Float {
                if value as! Float != targetValue as! Float {
                    return false;
                }
                continue;
            } else if value is Bool && targetValue is Bool {
                if value as! Bool != targetValue as! Bool {
                    return false;
                }
                continue;
            } else if value is String && targetValue is String {
                if value as! String != targetValue as! String {
                    return false;
                }
                continue;
            } else {
                return false;
            }
        }
        return true;
    }

    func testSerializeCommand() {
        let created = Date(timeIntervalSince1970: 100);
        let modified = Date(timeIntervalSince1970: 200);
        let actions: [Dictionary<String, Any>] =
            [
                [ "turnPower" : [ "power" : true ] ],
                [ "setFanSpeed" : [ "fanSpeed": 100] ]
            ];
        let actionResults: [Dictionary<String, Any>] =
            [
                [ "turnPower" :
                    [
                        "succeeded" : true,
                        "data": [
                            "time": 100
                        ]
                    ]
                ],
                [ "setFanSpeed" :
                    [
                        "succeeded" : false,
                        "errorMessage" : "failed to set fan spped"
                    ]
                ]
            ];
        let metadata: Dictionary<String, Any> = [ "sound" : "noisy.mp3" ];
        let source: Command = Command(
                commandID: "testCommandID",
                targetID: TypedID(type: "testTargetType", id: "testTargetID"),
                issuerID: TypedID(type: "testIssuerType", id: "testIssuerID"),
                schemaName:"testSchemaName",
                schemaVersion: 1,
                actions: actions,
                actionResults: actionResults,
                commandState: CommandState.sending,
                firedByTriggerID: "testFiredByTriggerID",
                created: created,
                modified: modified,
                title: "testTitle",
                commandDescription: "testCommandDescription",
                metadata: metadata);

        XCTAssertEqual(source.commandID, "testCommandID");
        XCTAssertEqual(source.targetID.type, "testTargetType".lowercased());
        XCTAssertEqual(source.targetID.id, "testTargetID");
        XCTAssertEqual(source.issuerID.type, "testIssuerType".lowercased());
        XCTAssertEqual(source.issuerID.id, "testIssuerID");
        XCTAssertEqual(source.schemaName, "testSchemaName");
        XCTAssertEqual(source.schemaVersion, 1);
        XCTAssertEqual(source.actions.count, 2);
        XCTAssertTrue(
            CommandSerializationTest.isSameArray(
                source.actions, target: actions));
        XCTAssertTrue(
            CommandSerializationTest.isSameArray(
                source.actionResults, target: actionResults));
        XCTAssertEqual(source.firedByTriggerID, "testFiredByTriggerID");
        XCTAssertEqual(source.created, created);
        XCTAssertEqual(source.modified, modified);
        XCTAssertEqual(source.title, "testTitle");
        XCTAssertEqual(source.commandDescription, "testCommandDescription");
        XCTAssertTrue(
            CommandSerializationTest.isSameDictionary(
                source.metadata!, target: metadata));

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
            NSKeyedArchiver(forWritingWith: data);
        source.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWith: data as Data);
        let target: Command = Command(coder: decoder);
        decoder.finishDecoding();

        XCTAssertEqual(source.commandID, target.commandID);
        XCTAssertEqual(source.targetID.type, target.targetID.type);
        XCTAssertEqual(source.targetID.id, target.targetID.id);
        XCTAssertEqual(source.issuerID.type, target.issuerID.type);
        XCTAssertEqual(source.issuerID.id, target.issuerID.id);
        XCTAssertEqual(source.schemaName, target.schemaName);
        XCTAssertEqual(source.schemaVersion, target.schemaVersion);
        XCTAssertTrue(
            CommandSerializationTest.isSameArray(
                source.actions, target: target.actions));
        XCTAssertTrue(
            CommandSerializationTest.isSameArray(
                source.actionResults, target: target.actionResults));
        XCTAssertEqual(source.commandState, target.commandState);
        XCTAssertEqual(source.firedByTriggerID, target.firedByTriggerID);
        XCTAssertEqual(source.created, target.created);
        XCTAssertEqual(source.modified, target.modified);
        XCTAssertEqual(source.title, target.title);
        XCTAssertEqual(source.commandDescription, target.commandDescription);
        XCTAssertTrue(
            CommandSerializationTest.isSameDictionary(
                source.metadata!, target: target.metadata!));
    }
}
