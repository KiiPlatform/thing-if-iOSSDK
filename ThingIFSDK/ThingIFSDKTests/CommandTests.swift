//
//  CommandTests.swift
//  ThingIFSDK
//
//  Created on 2016/03/01.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class CommandTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testOptinalNonNil() {
        let targetID = TypedID(TypedID.Types.thing, id: "target")
        let issuerID = TypedID(TypedID.Types.thing, id: "issuer")
        let actions = [AliasAction("alias", action: ["key" : "value"])]
        let actionResults = [
          AliasActionResult(
            "alias",
            results: [ActionResult(true, actionName: "actionName")])
        ]
        let created = Date()
        let modified = Date()
        let metadata: [String : Any] = ["key" : "value"]

        let actual = Command(
          "commandID",
          targetID: targetID,
          issuerID: issuerID,
          actions: actions,
          actionResults: actionResults,
          commandState: .sending,
          firedByTriggerID: "firedByTriggerID",
          created: created,
          modified: modified,
          title: "title",
          commandDescription: "commandDescription",
          metadata: metadata)

        XCTAssertEqual(targetID, actual.targetID)
        XCTAssertEqual(issuerID, actual.issuerID)
        assertEqualsAliasActionArray(actions, actual.actions)
        assertEqualsAliasActionResultArray(actionResults, actual.actionResults)
        XCTAssertEqual(.sending, actual.commandState)
        XCTAssertEqual("firedByTriggerID", actual.firedByTriggerID)
        XCTAssertEqual(created, actual.created)
        XCTAssertEqual(modified, actual.modified)
        XCTAssertEqual("title", actual.title)
        XCTAssertEqual("commandDescription", actual.commandDescription)
        assertEqualsDictionary(metadata, actual.metadata)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = Command(coder: decoder)!
        decoder.finishDecoding();

        XCTAssertEqual(actual.targetID, deserialized.targetID)
        XCTAssertEqual(actual.issuerID, deserialized.issuerID)
        assertEqualsAliasActionArray(actual.actions, deserialized.actions)
        assertEqualsAliasActionResultArray(
          actual.actionResults,
          deserialized.actionResults)
        XCTAssertEqual(actual.commandState, deserialized.commandState)
        XCTAssertEqual(actual.firedByTriggerID, deserialized.firedByTriggerID)
        XCTAssertEqual(actual.created, deserialized.created)
        XCTAssertEqual(actual.modified, deserialized.modified)
        XCTAssertEqual(actual.title, deserialized.title)
        XCTAssertEqual(
          actual.commandDescription,
          deserialized.commandDescription)
        assertEqualsDictionary(actual.metadata, deserialized.metadata)
    }

    func testOptinalNil() {
        let targetID = TypedID(TypedID.Types.thing, id: "target")
        let issuerID = TypedID(TypedID.Types.thing, id: "issuer")
        let actions = [AliasAction("alias", action: ["key" : "value"])]

        let actual = Command(
          "commandID",
          targetID: targetID,
          issuerID: issuerID,
          actions: actions)

        XCTAssertEqual(targetID, actual.targetID)
        XCTAssertEqual(issuerID, actual.issuerID)
        assertEqualsAliasActionArray(actions, actual.actions)
        assertEqualsAliasActionResultArray([], actual.actionResults)
        XCTAssertEqual(.sending, actual.commandState)
        XCTAssertNil(actual.firedByTriggerID)
        XCTAssertNil(actual.created)
        XCTAssertNil(actual.modified)
        XCTAssertNil(actual.title)
        XCTAssertNil(actual.commandDescription)
        XCTAssertNil(actual.metadata)

        let data: NSMutableData = NSMutableData(capacity: 1024)!;
        let coder: NSKeyedArchiver =
          NSKeyedArchiver(forWritingWith: data);
        actual.encode(with: coder);
        coder.finishEncoding();

        let decoder: NSKeyedUnarchiver =
          NSKeyedUnarchiver(forReadingWith: data as Data);
        let deserialized = Command(coder: decoder)!
        decoder.finishDecoding();

        XCTAssertEqual(actual.targetID, deserialized.targetID)
        XCTAssertEqual(actual.issuerID, deserialized.issuerID)
        assertEqualsAliasActionArray(actual.actions, deserialized.actions)
        assertEqualsAliasActionResultArray(
          actual.actionResults,
          deserialized.actionResults)
        XCTAssertEqual(actual.commandState, deserialized.commandState)
        XCTAssertEqual(actual.firedByTriggerID, deserialized.firedByTriggerID)
        XCTAssertEqual(actual.created, deserialized.created)
        XCTAssertEqual(actual.modified, deserialized.modified)
        XCTAssertEqual(actual.title, deserialized.title)
        XCTAssertEqual(
          actual.commandDescription,
          deserialized.commandDescription)
        assertEqualsDictionary(actual.metadata, deserialized.metadata)
    }

    func testGetAction() {

        let actionA = AliasAction("alias", action: ["key1" : "value1"])
        let actionDifferentAliasFromA =
          AliasAction("different", action: ["key2" : "value2"])
        let actionSameAliasAsA =
          AliasAction("alias", action: ["key3" : "value3"])

        let actual = Command(
          "commandID",
          targetID: TypedID(TypedID.Types.thing, id: "target"),
          issuerID: TypedID(TypedID.Types.thing, id: "issuer"),
          actions: [actionA, actionDifferentAliasFromA, actionSameAliasAsA])


        assertEqualsAliasActionArray(
          [actionA, actionSameAliasAsA],
          actual.getAction("alias"))
        assertEqualsAliasActionArray(
          [actionDifferentAliasFromA],
          actual.getAction("different"))
        assertEqualsAliasActionArray([], actual.getAction("noalias"))
    }

    func testGetActionResult() {
        let actionResults1 = ActionResult(true, actionName: "action1")
        let actionResults2 = ActionResult(true, actionName: "action2")
        let actionResults3 = ActionResult(true, actionName: "action3")

        let aliasActionResultA =
          AliasActionResult("alias", results: [actionResults1])
        let aliasActionResultDifferentAliasFromA =
           AliasActionResult("different", results: [actionResults2])
        let aliasActionResultSameAliasAsA =
          AliasActionResult(
            "alias",
            results: [actionResults1, actionResults3])

        let actual = Command(
          "commandID",
          targetID: TypedID(TypedID.Types.thing, id: "target"),
          issuerID: TypedID(TypedID.Types.thing, id: "issuer"),
          actions: [AliasAction("alias", action: ["key1" : "value1"])],
          actionResults: [
            aliasActionResultA,
            aliasActionResultDifferentAliasFromA,
            aliasActionResultSameAliasAsA])
        assertEqualsActionResultArray(
          [actionResults1, actionResults1],
          actual.getActionResult("alias", actionName: "action1"))
        assertEqualsActionResultArray(
          [actionResults2],
          actual.getActionResult("different", actionName: "action2"))
        assertEqualsActionResultArray(
          [actionResults3],
          actual.getActionResult("alias", actionName: "action3"))
        assertEqualsActionResultArray(
          [],
          actual.getActionResult("noalias", actionName: "action2"))
        assertEqualsActionResultArray(
          [],
          actual.getActionResult("alias", actionName: "noaction"))
    }
}
