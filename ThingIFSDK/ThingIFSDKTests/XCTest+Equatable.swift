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
