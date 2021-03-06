//
//  XCTest+Equatable.swift
//  ThingIFSDK
//
//  Created on 2017/03/02.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation
@testable import ThingIF

public protocol EquatableWrapper: Equatable, CustomStringConvertible {
    associatedtype T

    var item: T { get }
}

extension EquatableWrapper where T: TargetThing {

    public static func == (left: Self, right: Self) -> Bool {
        return left.item.typedID == right.item.typedID &&
          left.item.accessToken == right.item.accessToken &&
          left.item.vendorThingID == right.item.vendorThingID
    }

    public var description: String {
        get {
            var retval: [String : Any] = [
              "typedID" : self.item.typedID,
              "vendorThingID" : self.item.vendorThingID
            ]
            retval["accessToken"] = self.item.accessToken
            return retval.description
        }
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

struct AnyWrapper: EquatableWrapper {

    internal let item: Any

    init?(_ item: Any?) {
        guard let item = item else {
            return nil
        }
        self.item = item
    }

    public static func == (left: AnyWrapper, right: AnyWrapper) -> Bool {
        return isSameAny(left.item, right.item)
    }

    public var description: String {
        get {
            guard let item = self.item as? CustomStringConvertible else {
                return "concrete type of this Any does not adopt CustomStringConvertible"
            }
            return item.description
        }
    }
}

extension TimeRange: Equatable, ToJsonObject {

    public static func == (left: TimeRange, right: TimeRange) -> Bool {
        return left.from == right.from && left.to == right.to
    }

    public func makeJsonObject() -> [String : Any] {
        return [
            "from" : self.from.timeIntervalSince1970InMillis,
            "to" : self.to.timeIntervalSince1970InMillis
        ]
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

internal func isSameAny(_ left: Any?, _ right: Any?) -> Bool {
    if left == nil && right == nil {
        return true
    } else if left == nil || right == nil {
        return false
    }

    if type(of: left) != type(of: right) {
        return false
    }

    switch (left, right) {
        case (is String, is String):
            return left as! String == right as! String
        case (is Int, is Int):
            return left as! Int == right as! Int
        case (is Double, is Double):
            return left as! Double == right as! Double
        case (is Bool, is Bool):
            return left as! Bool == right as! Bool
        case (is [String : Any], is [String : Any]):
            return left as! NSDictionary == right as! NSDictionary
        case (is [Any], is [Any]):
            return left as! NSArray == right as! NSArray
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

extension GroupedHistoryStates : Equatable, ToJsonObject {

    public static func == (left: GroupedHistoryStates, right: GroupedHistoryStates) -> Bool {
        return
            left.timeRange == right.timeRange &&
            left.objects == right.objects
    }

    public func makeJsonObject() -> [String : Any] {
        return [
            "range" : self.timeRange.makeJsonObject(),
            "objects" : self.objects.map { $0.makeJsonObject() }
        ]
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
extension Command: Equatable, Hashable, ToJsonObject {

    public var hashValue: Int {
        return self.commandID?.hash ?? 0
    }

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
          "target" : self.targetID.toString(),
          "issuer" : self.issuerID.toString(),
          "actions" : self.aliasActions.map { $0.makeJsonObject() }
        ]

        if !self.aliasActionResults.isEmpty {
            retval["actionResults"] =
              self.aliasActionResults.map { $0.makeJsonObject() }
        }
        retval["commandID"] = self.commandID
        retval["commandState"] = self.commandState?.rawValue
        retval["created"] = self.created?.timeIntervalSince1970InMillis
        retval["modified"] = self.modified?.timeIntervalSince1970InMillis
        retval["firedByTriggerID"] = self.firedByTriggerID
        retval["title"] = self.title
        retval["metadata"] = self.metadata
        retval["description"] = self.commandDescription
        return retval
    }
}

extension Trigger: Equatable, Hashable, ToJsonObject {

    public var hashValue: Int {
        return self.triggerID.hash
    }

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

    internal init(
      _ trigger: Trigger,
      triggerID: String? = nil,
      targetID: TypedID? = nil,
      enabled: Bool? = nil,
      predicate: Predicate? = nil,
      command: Command? = nil,
      serverCode: ServerCode? = nil,
      title: String? = nil,
      triggerDescription: String? = nil,
      metadata: Dictionary<String, Any>? = nil)
    {
        self.triggerID = triggerID ?? trigger.triggerID
        self.targetID = targetID ?? trigger.targetID
        self.enabled = enabled ?? trigger.enabled
        self.predicate = predicate ?? trigger.predicate
        self.command = command ?? trigger.command
        self.serverCode = serverCode ?? trigger.serverCode
        self.title = title ?? trigger.title
        self.triggerDescription =
          triggerDescription ?? trigger.triggerDescription
        self.metadata = metadata ?? trigger.metadata
    }

}

internal func == (left: Predicate, right: Predicate) -> Bool {
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

internal func != (left: Predicate, right: Predicate) -> Bool {
    return !(left == right)
}

extension StatePredicate: Equatable {

    public static func == (
      left: StatePredicate,
      right: StatePredicate) -> Bool
    {
        return left.triggersWhen == right.triggersWhen &&
          left.condition == right.condition
    }

}

extension SchedulePredicate: Equatable {

    public static func == (
      left: SchedulePredicate,
      right: SchedulePredicate) -> Bool
    {
        return left.schedule == right.schedule
    }

}

extension ScheduleOncePredicate: Equatable {

    public static func == (
      left: ScheduleOncePredicate,
      right: ScheduleOncePredicate) -> Bool
    {
        return isSameDate(left.scheduleAt, right.scheduleAt)
    }

}

extension Condition: Equatable {

    public static func == (left: Condition, right: Condition) -> Bool {
        return left.clause == right.clause
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

extension TriggeredServerCodeResult: Equatable, ToJsonObject {
    public static func == (
      left: TriggeredServerCodeResult,
      right: TriggeredServerCodeResult) -> Bool
    {
        return left.succeeded == right.succeeded &&
          left.endpoint == right.endpoint &&
          left.error == right.error &&
          isSameDate(left.executedAt, right.executedAt) &&
          isSameAny(left.returnedValue, right.returnedValue)
    }

    public func makeJsonObject() -> [String : Any] {
        var retval: [String : Any] = [
          "succeeded" : self.succeeded,
          "executedAt" : self.executedAt.timeIntervalSince1970InMillis
        ]
        retval["endpoint"] = self.endpoint
        retval["returnedValue"] = self.returnedValue
        if let error = self.error?.makeJsonObject() {
            if !error.isEmpty {
                retval["error"] = error
            }
        }
        return retval
    }
}

extension ServerError: Equatable, ToJsonObject {
    public static func == (left: ServerError, right: ServerError) -> Bool {
        return left.errorMessage == right.errorMessage &&
          left.errorCode == right.errorCode &&
          left.detailMessage == right.detailMessage
    }

    public func makeJsonObject() -> [String : Any] {
        var detail: [String : Any] = [ : ]
        detail["errorCode"] = self.errorCode
        detail["message"] = self.detailMessage
        var retval: [String : Any] = [ : ]
        retval["errorMessage"] = self.errorMessage
        if !detail.isEmpty {
            retval["detail"] = detail
        }
        return retval
    }

}

extension AggregatedResult: Equatable {
    public static func == (left: AggregatedResult<AggregatedValueType>, right: AggregatedResult<AggregatedValueType>) -> Bool {
        return isSameAny(left.value, right.value) &&
            left.timeRange == right.timeRange &&
            left.aggregatedObjects == right.aggregatedObjects
    }
}
