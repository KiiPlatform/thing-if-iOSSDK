//
//  CommandTests.swift
//  ThingIFSDK
//
//  Created on 2016/03/01.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIF

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
        let aliasActions =
          [AliasAction("alias", actions: Action("key", value: "value"))]
        let aliasActionResults = [
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
          aliasActions: aliasActions,
          aliasActionResults: aliasActionResults,
          commandState: .sending,
          firedByTriggerID: "firedByTriggerID",
          created: created,
          modified: modified,
          title: "title",
          commandDescription: "commandDescription",
          metadata: metadata)

        XCTAssertEqual(targetID, actual.targetID)
        XCTAssertEqual(issuerID, actual.issuerID)
        XCTAssertEqual(aliasActions, actual.aliasActions)
        XCTAssertEqual(aliasActionResults, actual.aliasActionResults)
        XCTAssertEqual(.sending, actual.commandState)
        XCTAssertEqual("firedByTriggerID", actual.firedByTriggerID)
        XCTAssertEqual(created, actual.created)
        XCTAssertEqual(modified, actual.modified)
        XCTAssertEqual("title", actual.title)
        XCTAssertEqual("commandDescription", actual.commandDescription)
        XCTAssertEqual(
          metadata as! [String : String],
          actual.metadata as! [String : String])
    }

    func testOptinalNil() {
        let targetID = TypedID(TypedID.Types.thing, id: "target")
        let issuerID = TypedID(TypedID.Types.thing, id: "issuer")
        let aliasActions =
          [AliasAction("alias", actions: Action("key", value: "value"))]

        let actual = Command(
          "commandID",
          targetID: targetID,
          issuerID: issuerID,
          aliasActions: aliasActions)

        XCTAssertEqual(targetID, actual.targetID)
        XCTAssertEqual(issuerID, actual.issuerID)
        XCTAssertEqual(aliasActions, actual.aliasActions)
        XCTAssertEqual([], actual.aliasActionResults)
        XCTAssertNil(actual.commandState)
        XCTAssertNil(actual.firedByTriggerID)
        XCTAssertNil(actual.created)
        XCTAssertNil(actual.modified)
        XCTAssertNil(actual.title)
        XCTAssertNil(actual.commandDescription)
        XCTAssertNil(actual.metadata)
    }

    func testGetAction() {

        let actionA = AliasAction(
          "alias",
          actions: Action("key1", value: "value1"))
        let actionDifferentAliasFromA =
          AliasAction("different", actions: Action("key2", value: "value2"))
        let aliasActionsameAliasAsA =
          AliasAction("alias", actions: Action("key3", value: "value3"))

        let actual = Command(
          "commandID",
          targetID: TypedID(TypedID.Types.thing, id: "target"),
          issuerID: TypedID(TypedID.Types.thing, id: "issuer"),
          aliasActions: [actionA, actionDifferentAliasFromA,
                         aliasActionsameAliasAsA])


        XCTAssertEqual(
          [actionA, aliasActionsameAliasAsA],
          actual.getAliasActions("alias"))
        XCTAssertEqual(
          [actionDifferentAliasFromA],
          actual.getAliasActions("different"))
        XCTAssertEqual([], actual.getAliasActions("noalias"))
    }

    func testGetActionResult() {
        let aliasActionResults1 = ActionResult(true, actionName: "action1")
        let aliasActionResults2 = ActionResult(true, actionName: "action2")
        let aliasActionResults3 = ActionResult(true, actionName: "action3")

        let aliasActionResultA =
          AliasActionResult("alias", results: [aliasActionResults1])
        let aliasActionResultDifferentAliasFromA =
           AliasActionResult("different", results: [aliasActionResults2])
        let aliasActionResultSameAliasAsA =
          AliasActionResult(
            "alias",
            results: [aliasActionResults1, aliasActionResults3])

        let actual = Command(
          "commandID",
          targetID: TypedID(TypedID.Types.thing, id: "target"),
          issuerID: TypedID(TypedID.Types.thing, id: "issuer"),
          aliasActions:
            [AliasAction("alias", actions: Action("key1", value: "value1"))],
          aliasActionResults: [
            aliasActionResultA,
            aliasActionResultDifferentAliasFromA,
            aliasActionResultSameAliasAsA])
        XCTAssertEqual(
          [aliasActionResults1, aliasActionResults1],
          actual.getActionResult("alias", actionName: "action1"))
        XCTAssertEqual(
          [aliasActionResults2],
          actual.getActionResult("different", actionName: "action2"))
        XCTAssertEqual(
          [aliasActionResults3],
          actual.getActionResult("alias", actionName: "action3"))
        XCTAssertEqual(
          [],
          actual.getActionResult("noalias", actionName: "action2"))
        XCTAssertEqual(
          [],
          actual.getActionResult("alias", actionName: "noaction"))
    }
}
