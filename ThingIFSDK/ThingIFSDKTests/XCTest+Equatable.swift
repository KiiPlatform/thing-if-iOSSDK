//
//  XCTest+Equatable.swift
//  ThingIFSDK
//
//  Created on 2017/03/02.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation
@testable import ThingIFSDK

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

    if left is String {
        return left as! String == right as! String
    } else if left is Int {
        return left as! Int == right as! Int
    } else if left is Double {
        return left as! Double == right as! Double
    } else if left is Bool {
        return left as! Bool == right as! Bool
    } else if left is [String : Any] {
        return NSDictionary(dictionary: left as! [String : Any]) ==
          NSDictionary(dictionary: right as! [String : Any])
    } else if left is [Any] {
        return NSArray(array: left as! [Any]) == NSArray(array: right as! [Any])
    }
    fatalError("You need to add equality check.")
}

extension ActionResult: Equatable {

    public static func == (left: ActionResult, right: ActionResult) -> Bool {
        return left.succeeded == right.succeeded &&
          left.actionName == right.actionName &&
          left.errorMessage == right.errorMessage &&
          isSameAny(left.data, right.data)
    }

}

extension AliasActionResult: Equatable {

    public static func == (
      left: AliasActionResult,
      right: AliasActionResult) -> Bool
    {
        return left.alias == right.alias && left.results == right.results
    }

}

extension AliasAction: Equatable {

    public static func == (left: AliasAction, right: AliasAction) -> Bool {
        return left.alias == right.alias &&
          NSDictionary(dictionary: left.action) ==
            NSDictionary(dictionary: right.action)
    }

}

internal func == (left: TriggerClause, right: TriggerClause) -> Bool {
    if left is EqualsClauseInTrigger && right is EqualsClauseInTrigger {
        return left as! EqualsClauseInTrigger == right as! EqualsClauseInTrigger
    } else if left is NotEqualsClauseInTrigger &&
                right is NotEqualsClauseInTrigger {
        return left as! NotEqualsClauseInTrigger ==
          right as! NotEqualsClauseInTrigger
    } else if left is RangeClauseInTrigger && right is RangeClauseInTrigger {
        return left as! RangeClauseInTrigger == right as! RangeClauseInTrigger
    } else if left is AndClauseInTrigger && right is AndClauseInTrigger {
        return left as! AndClauseInTrigger == right as! AndClauseInTrigger
    } else if left is OrClauseInTrigger && right is OrClauseInTrigger {
        return left as! OrClauseInTrigger == right as! OrClauseInTrigger
    }
    return false
}

internal func != (left: TriggerClause, right: TriggerClause) -> Bool {
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
