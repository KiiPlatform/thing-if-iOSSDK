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
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let commandForm = CommandForm(actions)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithTitle() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let commandForm = CommandForm(actions, title: "title")
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertNil(commandForm.commandDescription)
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithCommandDescription() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let commandForm = CommandForm(actions,
                                      commandDescription: "description")
        XCTAssertNotNil(commandForm)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithMetadata() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(actions,
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        assertEqualsDictionary(commandForm.metadata, metadata)
    }

    func testInitWithTitleAndDescription() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let commandForm = CommandForm(actions,
                                      title: "title",
                                      commandDescription: "description")
        XCTAssertNotNil(commandForm)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertEqual(commandForm.commandDescription, "description")
        XCTAssertNil(commandForm.metadata)
    }

    func testInitWithTitleAndMetadata() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(actions,
                                      title: "title",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertNil(commandForm.commandDescription)
        assertEqualsDictionary(commandForm.metadata, metadata)
    }

    func testInitWithDescriptionAndMetadata() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(actions,
                                      commandDescription: "description",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertNil(commandForm.title)
        XCTAssertEqual(commandForm.commandDescription, "description")
        assertEqualsDictionary(commandForm.metadata, metadata)
    }

    func testInitWithAllFields() {
        let actions = [
          AliasAction(
            "alias",
            action: [ "action1" : [ "arg1" : "value1", "arg2": "value2" ] ]
          )
        ]
        let metadata: [String : Any] = [ "key1" : "value1", "key2" : "value2" ]
        let commandForm = CommandForm(actions,
                                      title: "title",
                                      commandDescription: "description",
                                      metadata: metadata)
        XCTAssertNotNil(commandForm)
        assertEqualsAliasActionArray(commandForm.actions, actions)
        XCTAssertEqual(commandForm.title, "title")
        XCTAssertEqual(commandForm.commandDescription, "description")
        assertEqualsDictionary(commandForm.metadata, metadata)
    }

}
