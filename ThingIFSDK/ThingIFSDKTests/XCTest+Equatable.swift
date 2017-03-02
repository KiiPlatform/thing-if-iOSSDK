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

extension ActionResult: Equatable {

    public static func == (left: ActionResult, right: ActionResult) -> Bool {
        return left.succeeded == right.succeeded &&
          left.actionName == right.actionName &&
          left.errorMessage == right.errorMessage
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
