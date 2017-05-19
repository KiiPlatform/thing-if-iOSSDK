//
//  Utilities.swift
//  ThingIFSDK
//
//  Created on 2017/04/04.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation
import ThingIF

/*
 Struct to check received trigger.

 In large tests, It is hard for us to use '==' of Trigger because we can
 not know values of some properties which are received from server in
 advance. For example, triggerID, created, modified and so on.

 TriggerToCheck is a struct to check all of properties in Trigger with
 '==' operator. Introducing TriggerToCheck gives us following 2 benefits:

 1. Summarize checking Trigger logic in one place.
 2. XCode point out failure positions with using XCTAssertEqual.
 */
internal struct TriggerToCheck: Equatable, CustomStringConvertible {

    private let data: (
      checker: (
        hasTriggerID: Bool,
        targetID: TypedID,
        enabled: Bool,
        command: CommandToCheck?,
        serverCode: ServerCode?,
        predicate: Predicate
      )?,
      checkee: Trigger?
    )

    init(
      _ hasTriggerID: Bool,
      targetID: TypedID,
      enabled: Bool,
      command: CommandToCheck? = nil,
      serverCode: ServerCode? = nil,
      predicate: Predicate)
    {
        self.data = (
          (
            hasTriggerID,
            targetID,
            enabled,
            command,
            serverCode,
            predicate
          ),
          nil
        )
    }

    init?(_ trigger: Trigger?) {
        guard let trigger = trigger else {
            return nil
        }
        self.data = (nil, trigger)
    }

    public static func == (
      left: TriggerToCheck,
      right: TriggerToCheck) -> Bool
    {
        guard let checker = left.data.checker ?? right.data.checker,
              let checkee = left.data.checkee ?? right.data.checkee else {
            fatalError()
        }

        if checker.hasTriggerID && checkee.triggerID.isEmpty ||
             !checker.hasTriggerID && !checkee.triggerID.isEmpty {
            return false
        }
        if checker.targetID != checkee.targetID {
            return false
        }
        if checker.enabled != checkee.enabled {
            return false
        }
        if checker.predicate != checkee.predicate {
            return false
        }
        if checker.serverCode != checkee.serverCode {
            return false
        }
        if checker.command != CommandToCheck(checkee.command) {
            return false
        }
        return true
    }

    public var description: String {
        if let checker = self.data.checker {
            var retval: [String : Any] = [
              "hasTriggerID" : checker.hasTriggerID,
              "targetID" : checker.targetID,
              "enabled" : checker.enabled,
              "predicate" : checker.predicate
            ]
            retval["command"] = checker.command
            retval["serverCode"] = checker.serverCode
            return retval.description
        } else if let checkee = self.data.checkee {
            var retval: [String : Any] = [
              "hasTriggerID" : !checkee.triggerID.isEmpty,
              "targetID" : checkee.targetID,
              "enabled" : checkee.enabled,
              "predicate" : checkee.predicate
            ]
            retval["command"] =
              checkee.command == nil ? nil : CommandToCheck(checkee.command!)
            retval["serverCode"] = checkee.serverCode
            return retval.description
        }
        fatalError()
    }

}

// Command version of Checking received command.
// The reason to create this, Please refer TriggerToCheck.
internal struct CommandToCheck: Equatable, CustomStringConvertible {

    private let data: (
      checker: (
        hasCommandID: Bool,
        targetID: TypedID,
        issuerID: TypedID,
        commandState: CommandState?,
        hasFiredByTriggerID: Bool,
        hasCreated: Bool,
        hasModified: Bool,
        aliasActions: [AliasAction],
        aliasActionResults: [AliasActionResult],
        title: String?,
        commandDescription: String?,
        metadata: [String : Any]?
      )?,
      checkee: Command?
    )

    init(
      _ hasCommandID: Bool,
      targetID: TypedID,
      issuerID: TypedID,
      commandState: CommandState?,
      hasFiredByTriggerID: Bool,
      hasCreated: Bool,
      hasModified: Bool,
      aliasActions: [AliasAction],
      aliasActionResults: [AliasActionResult] = [],
      title: String? = nil,
      commandDescription: String? = nil,
      metadata: [String : Any]? = nil)
    {
        self.data = (
          (
            hasCommandID,
            targetID,
            issuerID,
            commandState,
            hasFiredByTriggerID,
            hasCreated,
            hasModified,
            aliasActions,
            aliasActionResults,
            title,
            commandDescription,
            metadata
          ),
          nil
        )
    }

    init?(_ command: Command?) {
        guard let command = command else {
            return nil
        }
        self.data = (nil, command)
    }

    public static func == (
      left: CommandToCheck,
      right: CommandToCheck) -> Bool
    {
        guard let checker = left.data.checker ?? right.data.checker,
              let checkee = left.data.checkee ?? right.data.checkee else {
            fatalError()
        }

        if checker.hasCommandID != (checkee.commandID != nil) {
            return false
        }
        if checker.targetID != checkee.targetID {
            return false
        }
        if checker.issuerID != checkee.issuerID {
            return false
        }
        if checker.commandState != checkee.commandState {
            return false
        }
        if checker.hasFiredByTriggerID != (checkee.firedByTriggerID != nil) {
            return false
        }
        if checker.hasCreated != (checkee.created != nil) {
            return false
        }
        if checker.hasModified != (checkee.modified != nil) {
            return false
        }
        if checker.aliasActions != checkee.aliasActions {
            return false
        }
        if checker.aliasActionResults != checkee.aliasActionResults {
            return false
        }
        if checker.title != checkee.title {
            return false
        }
        if checker.commandDescription != checkee.commandDescription {
            return false
        }
        if checker.metadata as NSDictionary?
             != checkee.metadata as NSDictionary? {
            return false
        }
        return true
    }

    public var description: String {
        if let checker = self.data.checker {
            var retval: [String : Any] = [
              "hasCommandID" : checker.hasCommandID,
              "targetID" : checker.targetID,
              "issuerID" : checker.issuerID,
              "hasFiredByTriggerID" : checker.hasFiredByTriggerID,
              "hasCreated" : checker.hasCreated,
              "hasModified" : checker.hasModified,
              "aliasActions" : checker.aliasActions,
              "aliasActionResults" : checker.aliasActionResults
            ]
            retval["commandState"] = checker.commandState
            retval["title"] = checker.title
            retval["commandDescription"] = checker.commandDescription
            retval["metadata"] = checker.metadata
            return retval.description
        } else if let checkee = self.data.checkee {
            var retval: [String : Any] = [
              "hasCommandID" : checkee.commandID != nil,
              "targetID" : checkee.targetID,
              "issuerID" : checkee.issuerID,
              "hasFiredByTriggerID" : checkee.firedByTriggerID != nil,
              "hasCreated" : checkee.created != nil,
              "hasModified" : checkee.modified != nil,
              "aliasActions" : checkee.aliasActions,
              "aliasActionResults" : checkee.aliasActionResults
            ]
            retval["commandState"] = checkee.commandState
            retval["title"] = checkee.title
            retval["commandDescription"] = checkee.commandDescription
            retval["metadata"] = checkee.metadata
            return retval.description
        }
        fatalError()
    }
}

/*
 TriggeredServerCodeResult version of Checking received
 TriggeredServerCodeResult. The reason to create this, Please refer
 TriggerToCheck.

 TriggeredServerCodeResultToCheck ignores executeAt field because of
 following reasons:

 1. executeAt is server dependent, we can not know the value in advance.
 2. executeAt is not optional so we do not need to check nil.
 */
internal struct TriggeredServerCodeResultToCheck:
  Equatable, CustomStringConvertible
{
    private let data: (
      checker: (
        succeeded: Bool,
        endpoint: String?,
        error: ServerError?,
        returnedValue: Any?
      )?,
      checkee: TriggeredServerCodeResult?
    )

    init(
      _ succeeded: Bool,
      endpoint: String? = nil,
      error: ServerError? = nil,
      returnedValue: Any? = nil)
    {
        self.init((succeeded, endpoint, error, returnedValue), checkee: nil)
    }

    init?(_ result: TriggeredServerCodeResult?) {
        guard let result = result else {
            return nil
        }
        self.init(nil, checkee: result)
    }

    private init(
      _ checker: (
        succeeded: Bool,
        endpoint: String?,
        error: ServerError?,
        returnedValue: Any?
      )?,
      checkee: TriggeredServerCodeResult?)
    {
        self.data = (checker, checkee)
    }

    public static func == (
      left: TriggeredServerCodeResultToCheck,
      right: TriggeredServerCodeResultToCheck) -> Bool
    {
        guard let checker = left.data.checker ?? right.data.checker,
              let checkee = left.data.checkee ?? right.data.checkee else {
            fatalError()
        }

        if checker.succeeded != checkee.succeeded {
            return false
        }
        if checker.endpoint != checkee.endpoint {
            return false
        }
        if checker.error != checkee.error {
            return false
        }
        if !isSameAny(checker.returnedValue, checkee.returnedValue) {
            return false
        }
        return true
    }

    public var description: String {
        get {
            if let checker = self.data.checker {
                var retval: [String : Any] = ["succeeded" : checker.succeeded]
                retval["endpoint"] = checker.endpoint
                retval["error"] = checker.error
                retval["returnedValue"] = checker.returnedValue
                return retval.description
            } else if let checkee = self.data.checkee {
                var retval: [String : Any] = ["succeeded" : checkee.succeeded]
                retval["endpoint"] = checkee.endpoint
                retval["error"] = checkee.error
                retval["returnedValue"] = checkee.returnedValue
                return retval.description
            }
            fatalError()
        }
    }

}
