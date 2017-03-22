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
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let commandForm = CommandForm(aliasActions)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertNil(commandForm.title)
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithTitle() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let commandForm = CommandForm(aliasActions, title: "title")
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithCommandDescription() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let commandForm = CommandForm(aliasActions,
                                      commandDescription: "description")
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithMetadata() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let metadata = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(aliasActions,
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(
          commandForm.metadata as! [String : String],
          metadata as [String : String])
    }

    func testInitWithTitleAndDescription() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let commandForm = CommandForm(aliasActions,
                                      title: "title",
                                      commandDescription: "description")
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithTitleAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(aliasActions,
                                      title: "title",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertEqual(
          commandForm.metadata as! [String : String],
          metadata as! [String : String])
    }

    func testInitWithDescriptionAndMetadata() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(aliasActions,
                                      commandDescription: "description",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertEqual(
          commandForm.metadata as! [String : String],
          metadata as! [String : String])
    }

    func testInitWithAllFields() {
        let aliasActions = [
          AliasAction(
            "alias",
            actions: Action(
              "action1",
              value: ["arg1" : "value1", "arg2": "value2"])
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(aliasActions,
                                      title: "title",
                                      commandDescription: "description",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        XCTAssertEqual(commandForm.aliasActions, aliasActions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertEqual(
          commandForm.metadata as! [String : String],
          metadata as! [String : String])
    }

}
