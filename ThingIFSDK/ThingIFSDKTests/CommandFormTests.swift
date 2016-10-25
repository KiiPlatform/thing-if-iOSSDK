//
//  CommandFormTests.swift
//  ThingIFSDK
//
//  Created on 2016/04/11.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class CommandFormTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitWithRequiredValue() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithTitle() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      title: "title")
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithCommandDescription() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      commandDescription: "description")
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithMetadata() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let metadata: Dictionary<String, AnyObject> = [
            "key1" : "value1" as AnyObject,
            "key2" : "value2" as AnyObject
        ]
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        verifyDict(commandForm.metadata!, actualDict: metadata)
    }

    func testInitWithTitleAndDescription() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      title: "title",
                                      commandDescription: "description")
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithTitleAndMetadata() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let metadata: Dictionary<String, AnyObject> = [
            "key1" : "value1" as AnyObject,
            "key2" : "value2" as AnyObject
        ]
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      title: "title",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertNil(commandForm.commandDescription)
        verifyDict(commandForm.metadata!, actualDict: metadata)
    }

    func testInitWithDescriptionAndMetadata() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let metadata: Dictionary<String, AnyObject> = [
            "key1" : "value1" as AnyObject,
            "key2" : "value2" as AnyObject
        ]
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      commandDescription: "description",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(commandForm.commandDescription, "description")
        verifyDict(commandForm.metadata!, actualDict: metadata)
    }

    func testInitWithAllFields() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let metadata: Dictionary<String, AnyObject> = [
            "key1" : "value1" as AnyObject,
            "key2" : "value2" as AnyObject
        ]
        let commandForm = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      title: "title",
                                      commandDescription: "description",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.schemaName, "name")
        XCTAssertEqual(commandForm.schemaVersion, 1)
        XCTAssertEqual(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertEqual(commandForm.commandDescription, "description")
        verifyDict(commandForm.metadata!, actualDict: metadata)
    }

    func testNSCoding() {
        let actions: [Dictionary<String, AnyObject>] = [
            [
                "action1" :
                [
                    "arg1" : "value1",
                    "arg2": "value2"
                ]
            ]
        ];
        let metadata: Dictionary<String, AnyObject> = [
            "key1" : "value1" as AnyObject,
            "key2" : "value2" as AnyObject
        ]
        let original = CommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      title: "title",
                                      commandDescription: "description",
                                      metadata: metadata)
        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
            NSKeyedArchiver(forWritingWith: data);
        original.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized: CommandForm = CommandForm(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertNotNil(deserialized)
        XCTAssertEqual(deserialized.schemaName, "name")
        XCTAssertEqual(deserialized.schemaVersion, 1)
        XCTAssertEqual(deserialized.actions, actions)
        XCTAssertEqual(deserialized.title, "title")
        XCTAssertEqual(deserialized.commandDescription, "description")
        verifyDict(deserialized.metadata!, actualDict: metadata)
    }

}
