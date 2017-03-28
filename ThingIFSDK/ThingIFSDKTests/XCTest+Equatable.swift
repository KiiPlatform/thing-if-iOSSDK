//
//  XCTest+Equatable.swift
//  ThingIFSDK
//
//  Created on 2017/03/02.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation
@testable import ThingIFSDK

public protocol EquatableWrapper: Equatable {
    associatedtype T

    var item: T { get }
}

extension EquatableWrapper where T: TargetThing {

    public static func == (left: Self, right: Self) -> Bool {
        return left.item.typedID == right.item.typedID &&
          left.item.accessToken == right.item.accessToken &&
          left.item.vendorThingID == right.item.vendorThingID
    }
}

struct GatewayWrapper: EquatableWrapper {

    internal let item: Gateway

    init(
      _ thingID: String,
      vendorThingID: String,
      accessToken: String? = nil)
    {
        self.item = Gateway(
          thingID,
          vendorThingID: vendorThingID,
          accessToken: accessToken)
    }

    init?(_ item: Gateway?) {
        if item == nil {
            return nil
        }
        self.item = item!
    }

}

struct EndNodeWrapper: EquatableWrapper {

    internal let item: EndNode

    init(
      _ thingID: String,
      vendorThingID: String,
      accessToken: String? = nil)
    {
        self.item = EndNode(
          thingID,
          vendorThingID: vendorThingID,
          accessToken: accessToken)
    }

    init?(_ item: EndNode?) {
        if item == nil {
            return nil
        }
        self.item = item!
    }

}

extension TimeRange: Equatable {

    public static func == (left: TimeRange, right: TimeRange) -> Bool {
        return left.from == right.from && left.to == right.to
    }
}

internal func == (left: QueryClause, right: QueryClause) -> Bool {
    if left is EqualsClauseInQuery && right is EqualsClauseInQuery {
        return left as! EqualsClauseInQuery == right as! EqualsClauseInQuery
    } else if left is NotEqualsClauseInQuery &&
                right is NotEqualsClauseInQuery {
        return left as! NotEqualsClauseInQuery ==
          right as! NotEqualsClauseInQuery
    } else if left is RangeClauseInQuery && right is RangeClauseInQuery {
        return left as! RangeClauseInQuery == right as! RangeClauseInQuery
    } else if left is AndClauseInQuery && right is AndClauseInQuery {
        return left as! AndClauseInQuery == right as! AndClauseInQuery
    } else if left is OrClauseInQuery && right is OrClauseInQuery {
        return left as! OrClauseInQuery == right as! OrClauseInQuery
    }
    return false
}

internal func != (left: QueryClause, right: QueryClause) -> Bool {
    return !(left == right)
}

extension EqualsClauseInQuery: Equatable {

    public static func == (
      left: EqualsClauseInQuery,
      right: EqualsClauseInQuery) -> Bool
    {
        if left.field != right.field {
            return false
        }

        if left.value is String && right.value is String {
            return left.value as! String == right.value as! String
        } else if left.value is Int && right.value is Int {
            return left.value as! Int ==  right.value as! Int
        } else if left.value is Bool && right.value is Bool {
            return left.value as! Bool ==  right.value as! Bool
        }
        return false
    }

}

extension NotEqualsClauseInQuery: Equatable {

    public static func == (
      left: NotEqualsClauseInQuery,
      right: NotEqualsClauseInQuery) -> Bool
    {
        return left.equals == right.equals
    }

}

extension RangeClauseInQuery: Equatable {

    public static func == (
      left: RangeClauseInQuery,
      right: RangeClauseInQuery) -> Bool
    {
        return left.field == right.field &&
          left.lowerLimit == right.lowerLimit &&
          left.lowerIncluded == right.lowerIncluded &&
          left.upperLimit == right.upperLimit &&
          left.upperIncluded == right.upperIncluded
    }

}

fileprivate func isEqualClauseArray(
  _ left: [QueryClause],
  _ right: [QueryClause]) -> Bool
{
    if left.count != right.count {
        return false
    }

    for (index, leftClause) in left.enumerated() {
        if leftClause != right[index] {
            return false
        }
    }
    return true
}

extension AndClauseInQuery: Equatable {

    public static func == (
      left: AndClauseInQuery,
      right: AndClauseInQuery) -> Bool
    {
        return isEqualClauseArray(left.clauses, right.clauses)
    }

}

extension OrClauseInQuery: Equatable {

    public static func == (
      left: OrClauseInQuery,
      right: OrClauseInQuery) -> Bool
    {
        return isEqualClauseArray(left.clauses, right.clauses)
    }

}

extension AllClause: Equatable {

    public static func == (left: AllClause, right: AllClause) -> Bool {
        return true
    }

}

func isSameAny(_ left: Any?, _ right: Any?) -> Bool {
    if left == nil && right == nil {
        return true
    } else if left == nil || right == nil {
        return false
    }

    if type(of: left) != type(of: right) {
        return false
    }

    switch (left, right) {
        case (is String, is String) where left as! String == right as! String:
            return true
        case (is Int, is Int) where left as! Int == right as! Int:
            return true
        case (is Double, is Double) where left as! Double == right as! Double:
            return true
        case (is Bool, is Bool) where left as! Bool == right as! Bool:
            return true
        case (is [String : Any], is [String : Any])
               where left as! NSDictionary == right as! NSDictionary:
            return true
        case (is [Any], is [Any]) where left as! NSArray == right as! NSArray:
            return true
        default:
            break
    }
    fatalError("You need to add equality check.")
}

extension ActionResult: Equatable, ToJsonObject {

    public static func == (left: ActionResult, right: ActionResult) -> Bool {
        return left.succeeded == right.succeeded &&
          left.actionName == right.actionName &&
          left.errorMessage == right.errorMessage &&
          isSameAny(left.data, right.data)
    }

    public func makeJsonObject() -> [String : Any] {
        var dict: [String : Any] = ["succeeded" : self.succeeded]
        dict["data"] = self.data
        dict["errorMessage"] = self.errorMessage

        return [self.actionName : dict]
    }

}

extension AliasActionResult: Equatable, ToJsonObject {

    public static func == (
      left: AliasActionResult,
      right: AliasActionResult) -> Bool
    {
        return left.alias == right.alias && left.results == right.results
    }

    public func makeJsonObject() -> [String : Any] {
        return [self.alias : self.results.map { $0.makeJsonObject() }]
    }

}

extension AliasAction: Equatable {

    public static func == (left: AliasAction, right: AliasAction) -> Bool {
        return left.alias == right.alias && left.actions == right.actions
    }

}

private func == (left: TriggerClause, right: TriggerClause) -> Bool {
    switch (left, right) {
    case (is EqualsClauseInTrigger, is EqualsClauseInTrigger) where
           left as! EqualsClauseInTrigger == right as! EqualsClauseInTrigger:
        return true
    case (is NotEqualsClauseInTrigger, is NotEqualsClauseInTrigger) where
           left as! NotEqualsClauseInTrigger ==
             right as! NotEqualsClauseInTrigger:
        return true
    case (is RangeClauseInTrigger, is RangeClauseInTrigger) where
           left as! RangeClauseInTrigger == right as! RangeClauseInTrigger:
        return true
    case (is AndClauseInTrigger, is AndClauseInTrigger) where
           left as! AndClauseInTrigger == right as! AndClauseInTrigger:
        return true
    case (is OrClauseInTrigger, is OrClauseInTrigger) where
           left as! OrClauseInTrigger == right as! OrClauseInTrigger:
        return true
    default:
        return false
    }
}

private func != (left: TriggerClause, right: TriggerClause) -> Bool {
    return !(left == right)
}

extension EqualsClauseInTrigger: Equatable {

    public static func == (
      left: EqualsClauseInTrigger,
      right: EqualsClauseInTrigger) -> Bool
    {
        if left.field != right.field || left.alias != right.alias {
            return false
        }

        if left.value is String && right.value is String {
            return left.value as! String == right.value as! String
        } else if left.value is Int && right.value is Int {
            return left.value as! Int ==  right.value as! Int
        } else if left.value is Bool && right.value is Bool {
            return left.value as! Bool ==  right.value as! Bool
        }
        return false
    }

}

extension NotEqualsClauseInTrigger: Equatable {

    public static func == (
      left: NotEqualsClauseInTrigger,
      right: NotEqualsClauseInTrigger) -> Bool
    {
        return left.equals == right.equals
    }

}

extension RangeClauseInTrigger: Equatable {

    public static func == (
      left: RangeClauseInTrigger,
      right: RangeClauseInTrigger) -> Bool
    {
        return left.alias == right.alias &&
          left.field == right.field &&
          left.lowerLimit == right.lowerLimit &&
          left.lowerIncluded == right.lowerIncluded &&
          left.upperLimit == right.upperLimit &&
          left.upperIncluded == right.upperIncluded
    }

}

fileprivate func isEqualClauseArray(
  _ left: [TriggerClause],
  _ right: [TriggerClause]) -> Bool
{
    if left.count != right.count {
        return false
    }

    for (index, leftClause) in left.enumerated() {
        if leftClause != right[index] {
            return false
        }
    }
    return true
}

extension AndClauseInTrigger: Equatable {

    public static func == (
      left: AndClauseInTrigger,
      right: AndClauseInTrigger) -> Bool
    {
        return isEqualClauseArray(left.clauses, right.clauses)
    }

}

extension OrClauseInTrigger: Equatable {

    public static func == (
      left: OrClauseInTrigger,
      right: OrClauseInTrigger) -> Bool
    {
        return isEqualClauseArray(left.clauses, right.clauses)
    }

}

extension ThingIFError: Equatable {

    public static func == (left: ThingIFError, right: ThingIFError) -> Bool {
        switch (left, right) {
        case (.connection, .connection):
            return true
        case (.errorResponse(let leftError), .errorResponse(let rightError))
               where leftError == rightError:
            return true
        case (.pushNotAvailable, .pushNotAvailable):
            return true
        case (.jsonParseError, .jsonParseError):
            return true
        case (.unsupportedError, .unsupportedError):
            return true
        case (.alreadyOnboarded, .alreadyOnboarded):
            return true
        case (.targetNotAvailable, .targetNotAvailable):
            return true
        case (.apiNotStored(let leftTag), .apiNotStored(let rightTag))
               where leftTag == rightTag:
            return true
        case (.apiUnloadable(let leftData), .apiUnloadable(let rightData))
               where leftData.tag == rightData.tag &&
                       leftData.storedVersion == rightData.storedVersion &&
                       leftData.minimumVersion == rightData.minimumVersion:
            return true
        case (.invalidStoredApi, .invalidStoredApi):
            return true
        case (.userIsNotLoggedIn, .userIsNotLoggedIn):
            return true
        case (.errorRequest(let leftError), .errorRequest(let rightError))
               where type(of: leftError) == type(of: rightError):
            // In fact, we need to check more detail of leftError and
            // rightError, but it dependes on concrete error type.
            // Only we can do is add concrete type check as is.
            return true
        case (.invalidArgument(let leftMessage),
              .invalidArgument(let rightMessage)) where
               leftMessage == rightMessage:
            return true
        default:
            return false
        }
    }
}

extension ErrorResponse: Equatable {

    public static func == (left: ErrorResponse, right: ErrorResponse) -> Bool {
        return left.httpStatusCode == right.httpStatusCode &&
          left.errorCode == right.errorCode &&
          left.errorMessage == right.errorMessage
    }
}

extension GatewayAPI: Equatable, CustomStringConvertible {

    public static func == (left: GatewayAPI, right: GatewayAPI) -> Bool {
        return left.app == right.app &&
          left.gatewayAddress == right.gatewayAddress &&
          left.accessToken == right.accessToken &&
          left.tag == right.tag
    }

    public var description: String {
        return "app={\(self.app)|, gatewayAddress=\(self.gatewayAddress), "
          + "accessToken=\(self.accessToken), tag=\(self.tag)"
    }
}

extension KiiApp: Equatable, CustomStringConvertible {

    public static func == (left: KiiApp, right: KiiApp) -> Bool {
        return left.appID == right.appID &&
          left.appKey == right.appKey &&
          left.hostName == right.hostName &&
          left.baseURL == right.baseURL &&
          left.siteName == right.siteName
    }

    public var description: String {
        return "appID={\(self.appID)|, appKey={\(self.appKey), "
          + "hostName=\(self.hostName), baseURL=\(self.baseURL), "
          + "siteName=\(self.siteName)"
    }
}

extension Action: Equatable {

    public static func == (left: Action, right: Action) -> Bool {
        return left.name == right.name && isSameAny(left.value, right.value)
    }

}

extension HistoryState : Equatable, ToJsonObject {
    public static func == (left: HistoryState, right: HistoryState) -> Bool {
        return
            left.state as NSDictionary == right.state as NSDictionary &&
                left.createdAt == right.createdAt
    }

    public func makeJsonObject() -> [String : Any] {
        var ret = self.state
        ret["_created"] = self.createdAt.timeIntervalSince1970InMillis
        return ret
    }
}

internal func isSameDate(_ left: Date?, _ right: Date?) -> Bool {
    if left == nil && right == nil {
        return true
    }

    guard let leftInterval = left?.timeIntervalSince1970,
          let rightInterval = right?.timeIntervalSince1970 else {
        return false
    }

    let distance = leftInterval - rightInterval
    return (0 < distance && 1 > distance) ||
      (-1 < distance && 0 > distance) ||
      distance == 0

}
extension Command: Equatable, ToJsonObject {

    public static func == (left: Command, right: Command) -> Bool {
        return left.commandID == right.commandID &&
          left.targetID == right.targetID &&
          left.issuerID == right.issuerID &&
          left.aliasActions == right.aliasActions &&
          left.aliasActionResults == right.aliasActionResults &&
          left.commandState == right.commandState &&
          left.firedByTriggerID == right.firedByTriggerID &&
          isSameDate(left.created, right.created) &&
          isSameDate(left.modified, right.modified) &&
          left.title == right.title &&
          left.commandDescription == right.commandDescription &&
          left.metadata as NSDictionary? == right.metadata as NSDictionary?
    }

    public func makeJsonObject() -> [String : Any] {
        var retval: [String : Any] = [
          "commandID" : self.commandID,
          "target" : self.targetID.toString(),
          "issuer" : self.issuerID.toString(),
          "actions" : self.aliasActions.map { $0.makeJsonObject() },
          "commandState" : self.commandState.rawValue,
          "created" : self.created!.timeIntervalSince1970InMillis
        ]

        if !self.aliasActionResults.isEmpty {
            retval["actionResults"] =
              self.aliasActionResults.map { $0.makeJsonObject() }
        }
        retval["modified"] = self.modified?.timeIntervalSince1970InMillis
        retval["firedByTriggerID"] = self.firedByTriggerID
        retval["title"] = self.title
        retval["metadata"] = self.metadata
        retval["description"] = self.commandDescription
        return retval
    }
}

extension Trigger: Equatable, ToJsonObject {

    public static func == (left: Trigger, right: Trigger) -> Bool {
        return left.triggerID == right.triggerID &&
          left.targetID == right.targetID &&
          left.enabled == right.enabled &&
          left.predicate == right.predicate &&
          left.command == right.command &&
          left.serverCode == right.serverCode &&
          left.title == right.title &&
          left.triggerDescription == right.triggerDescription &&
          left.metadata as NSDictionary? == right.metadata as NSDictionary?
    }

    public func makeJsonObject() -> [String : Any] {
        var retval: [String : Any] = [
          "triggerID" : self.triggerID,
          "disabled" : !self.enabled,
          "predicate" : (self.predicate as! ToJsonObject).makeJsonObject()
        ]
        retval["command"] = self.command?.makeJsonObject()
        retval["serverCode"] = self.serverCode?.makeJsonObject()
        retval["title"] = self.title
        retval["description"] = self.triggerDescription
        retval["metadata"] = self.metadata
        return retval
    }
}

private func == (left: Predicate, right: Predicate) -> Bool {
    switch (left, right) {
    case (is StatePredicate, is StatePredicate):
        return left as! StatePredicate == right as! StatePredicate
    case (is SchedulePredicate, is SchedulePredicate):
        return left as! SchedulePredicate == right as! SchedulePredicate
    case (is ScheduleOncePredicate, is ScheduleOncePredicate):
        return left as! ScheduleOncePredicate ==
          right as! ScheduleOncePredicate
    default:
        return false
    }
}

extension StatePredicate: Equatable, ToJsonObject {

    public static func == (
      left: StatePredicate,
      right: StatePredicate) -> Bool
    {
        return left.triggersWhen == right.triggersWhen &&
          left.condition == right.condition
    }

    public func makeJsonObject() -> [String : Any] {
        return [
          "eventSource" : self.eventSource.rawValue,
          "triggersWhen" : self.triggersWhen.rawValue,
          "condition" : self.condition.makeJsonObject()
        ]
    }
}

extension SchedulePredicate: Equatable, ToJsonObject {

    public static func == (
      left: SchedulePredicate,
      right: SchedulePredicate) -> Bool
    {
        return left.schedule == right.schedule
    }

    public func makeJsonObject() -> [String : Any] {
        return [
          "eventSource" : self.eventSource.rawValue,
          "schedule" : self.schedule
        ]
    }
}

extension ScheduleOncePredicate: Equatable, ToJsonObject {

    public static func == (
      left: ScheduleOncePredicate,
      right: ScheduleOncePredicate) -> Bool
    {
        return isSameDate(left.scheduleAt, right.scheduleAt)
    }

    public func makeJsonObject() -> [String : Any] {
        return [
          "eventSource" : self.eventSource.rawValue,
          "scheduleAt" : Int(self.scheduleAt.timeIntervalSince1970InMillis)
        ]
    }
}

extension Condition: Equatable, ToJsonObject {

    public static func == (left: Condition, right: Condition) -> Bool {
        return left.clause == right.clause
    }

    public func makeJsonObject() -> [String : Any] {
        return (self.clause as! ToJsonObject).makeJsonObject()
    }
}

extension ServerCode: Equatable {

    public static func == (left: ServerCode, right: ServerCode) -> Bool
    {
        return left.endpoint == right.endpoint &&
          left.executorAccessToken == right.executorAccessToken &&
          left.targetAppID == right.targetAppID &&
          left.parameters as NSDictionary? == right.parameters as NSDictionary?
    }

}

extension PendingEndNode: Equatable {

    public static func == (left: PendingEndNode, right: PendingEndNode) -> Bool {
        return left.vendorThingID == right.vendorThingID &&
            left.thingType == right.thingType &&
            left.firmwareVersion == right.firmwareVersion &&
            left.thingProperties as NSDictionary? == right.thingProperties as NSDictionary?
    }
}
