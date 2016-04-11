//
//  CommandFormTests.swift
//  ThingIFSDK
//
//  Created on 2016/04/11.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
import Foundation

@testable import ThingIFSDK

class CommandFormTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    static func equalDictionary(
            actual: Dictionary<String, AnyObject>,
            expected: Dictionary<String, AnyObject>) -> Bool
    {
        for (key, value) in actual {
            if (!value.isEqual(expected[key])) {
                return false
            }
        }
        return true;
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
            "key1" : "value1",
            "key2" : "value2"
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
        XCTAssertTrue(
            CommandFormTests.equalDictionary(
                commandForm.metadata!,
                expected: metadata))
    }

}
