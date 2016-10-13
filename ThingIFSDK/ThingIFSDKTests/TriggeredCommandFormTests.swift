//
//  TriggeredCommandFormTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/05.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class TriggeredCommandFormTest: SmallTestBase {

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
                "key1" : "value1",
                "key2": "value2"
              ]
          ]
        ];

        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions);
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertNil(form.title)
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
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
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        title: "title")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
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
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.metadata)
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
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertNil(form.title)
        verifyDict(form.metadata!, actualDict: metadata)
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
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        title: "title",
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.metadata)
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
          "key1" : "value1",
          "key2" : "value2"
        ]
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        title: "title",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.commandDescription)
        verifyDict(form.metadata!, actualDict: metadata)
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
          "key1" : "value1",
          "key2" : "value2"
        ]
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.commandDescription, "description")
        verifyDict(form.metadata!, actualDict: metadata)
    }

    func testInitWithTargetID() {
        let actions: [Dictionary<String, AnyObject>] = [
          [
            "action1" :
              [
                "arg1" : "value1",
                "arg2": "value2"
              ]
          ]
        ];
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndTitle() {
        let actions: [Dictionary<String, AnyObject>] = [
          [
            "action1" :
              [
                "arg1" : "value1",
                "arg2": "value2"
              ]
          ]
        ];
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        title: "title")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndTitleAndDescription() {
        let actions: [Dictionary<String, AnyObject>] = [
          [
            "action1" :
              [
                "arg1" : "value1",
                "arg2": "value2"
              ]
          ]
        ];
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        title: "title",
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndTitleAndDescriptionAndMetadata() {
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
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        title: "title",
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        verifyDict(form.metadata!, actualDict: metadata)
    }

    func testInitWithTargetIDAndDescription() {
        let actions: [Dictionary<String, AnyObject>] = [
          [
            "action1" :
              [
                "arg1" : "value1",
                "arg2": "value2"
              ]
          ]
        ];
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.title)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndDescriptionAndMetadata() {
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
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.commandDescription, "description")
        verifyDict(form.metadata!, actualDict: metadata)
        XCTAssertNil(form.title)
    }

    func testInitWithTargetIDAndMetadata() {
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
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID)
        verifyDict(form.metadata!, actualDict: metadata)
        XCTAssertNil(form.title)
        XCTAssertNil(form.commandDescription)
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
          "key1" : "value1",
          "key2" : "value2"
        ]
        let targetID = TypedID(type: "THING", id: "id");
        let form = TriggeredCommandForm(schemaName: "name",
                                        schemaVersion: 1,
                                        actions: actions,
                                        targetID: targetID,
                                        title: "title",
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.schemaName, "name")
        XCTAssertEqual(form.schemaVersion, 1)
        XCTAssertEqual(form.actions, actions)
        XCTAssertEqual(form.targetID, targetID);
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        verifyDict(form.metadata!, actualDict: metadata)
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
            "key1" : "value1",
            "key2" : "value2"
        ]
        let targetID = TypedID(type: "THING", id: "id");
        let original = TriggeredCommandForm(schemaName: "name",
                                      schemaVersion: 1,
                                      actions: actions,
                                      targetID: targetID,
                                      title: "title",
                                      commandDescription: "description",
                                      metadata: metadata)
        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
            NSKeyedArchiver(forWritingWithMutableData: data);
        original.encodeWithCoder(coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
            NSKeyedUnarchiver(forReadingWithData: data);
        let deserialized: TriggeredCommandForm =
          TriggeredCommandForm(coder: decoder)!;
        decoder.finishDecoding();

        XCTAssertNotNil(deserialized)
        XCTAssertEqual(deserialized.schemaName, "name")
        XCTAssertEqual(deserialized.schemaVersion, 1)
        XCTAssertEqual(deserialized.actions, actions)
        XCTAssertEqual(deserialized.targetID, targetID);
        XCTAssertEqual(deserialized.title, "title")
        XCTAssertEqual(deserialized.commandDescription, "description")
        verifyDict(deserialized.metadata!, actualDict: metadata)
    }

}
