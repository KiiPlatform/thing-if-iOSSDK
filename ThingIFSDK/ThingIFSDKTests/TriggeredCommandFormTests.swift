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
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]

        let form = TriggeredCommandForm(aliasActions);
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertNil(form.title)
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTitle() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let form = TriggeredCommandForm(aliasActions,
                                        title: "title")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithCommandDescription() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let form = TriggeredCommandForm(aliasActions,
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.metadata)
    }

    func testInitWithMetadata() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggeredCommandForm(aliasActions,
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

    func testInitWithTitleAndDescription() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let form = TriggeredCommandForm(aliasActions,
                                        title: "title",
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.metadata)
    }

    func testInitWithTitleAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggeredCommandForm(aliasActions,
                                        title: "title",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.commandDescription)
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

    func testInitWithDescriptionAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggeredCommandForm(aliasActions,
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

    func testInitWithTargetID() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndTitle() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        title: "title")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.commandDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndTitleAndDescription() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        title: "title",
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndTitleAndDescriptionAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        title: "title",
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

    func testInitWithTargetIDAndDescription() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        commandDescription: "description")
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertNil(form.title)
        XCTAssertNil(form.metadata)
    }

    func testInitWithTargetIDAndDescriptionAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertEqual(form.metadata as! [String : String], metadata)
        XCTAssertNil(form.title)
    }

    func testInitWithTargetIDAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID)
        XCTAssertEqual(form.metadata as! [String : String], metadata)
        XCTAssertNil(form.title)
        XCTAssertNil(form.commandDescription)
    }

    func testInitWithAllFields() {
        let aliasActions = [
          AliasAction(
            "alias1",
            actions: [
              Action(
                "action1",
                value: ["key1" : "value", "key2" : "value2"
                ]
              )
            ]
          )
        ]
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let targetID = TypedID(.thing, id: "id");
        let form = TriggeredCommandForm(aliasActions,
                                        targetID: targetID,
                                        title: "title",
                                        commandDescription: "description",
                                        metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.aliasActions, aliasActions)
        XCTAssertEqual(form.targetID, targetID);
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.commandDescription, "description")
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

}
