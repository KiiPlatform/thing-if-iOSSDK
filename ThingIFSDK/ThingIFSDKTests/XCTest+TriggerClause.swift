//
//  XCTest+TriggerClause.swift
//  ThingIFSDK
//
//  Created on 2017/02/20.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation
import XCTest
@testable import ThingIFSDK

extension XCTestCase {

        func assertEqualsTriggerClause(
      _ expected: TriggerClause?,
      _ actual: TriggerClause?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        if expected == nil && actual == nil {
            return
        } else if expected == nil || actual == nil {
            let errorMessage = message ?? "One is nil, the other is not nil."
            XCTFail(
              "file=\(file), line=\(line): \(errorMessage)")
            return
        }

        if type(of: expected!) !== type(of: actual!) {
            let errorMessage = message ??
              "Type mismatch: (\(Mirror(reflecting: expected!).subjectType), \(Mirror(reflecting: actual!).subjectType))"
            XCTFail(
              "file=\(file), line=\(line): \(errorMessage)")
            return
        }

        if type(of: expected!) === EqualsClauseInTrigger.self {
            assertEqualsEqualsClauseInTrigger(
              expected as! EqualsClauseInTrigger,
              actual as! EqualsClauseInTrigger,
              message,
              file,
              line)
        } else if type(of: expected!) === NotEqualsClauseInTrigger.self {
            assertEqualsNotEqualsClauseInTrigger(
              expected as! NotEqualsClauseInTrigger,
              actual as! NotEqualsClauseInTrigger,
              message,
              file,
              line)
        } else if type(of: expected!) === RangeClauseInTrigger.self {
            assertEqualsRangeClauseInTrigger(
              expected as! RangeClauseInTrigger,
              actual as! RangeClauseInTrigger,
              message,
              file,
              line)
        } else if type(of: expected!) === AndClauseInTrigger.self {
            assertEqualsAndClauseInTrigger(
              expected as! AndClauseInTrigger,
              actual as! AndClauseInTrigger,
              message,
              file,
              line)
        } else if type(of: expected!) === OrClauseInTrigger.self {
            assertEqualsOrClauseInTrigger(
              expected as! OrClauseInTrigger,
              actual as! OrClauseInTrigger,
              message,
              file,
              line)
        } else {
            XCTFail(
              "unknown type: \(Mirror(reflecting: expected!).subjectType)")
        }
    }

    private func  assertEqualsEqualsClauseInTrigger(
      _ expected: EqualsClauseInTrigger,
      _ actual: EqualsClauseInTrigger,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsWrapper(
          expected.alias,
          actual.alias,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected.field,
          actual.field,
          message,
          file: file,
          line: line)
        assertEqualsAny(
          expected.value,
          actual.value,
          message,
          file,
          line)
    }

    private func  assertEqualsNotEqualsClauseInTrigger(
      _ expected: NotEqualsClauseInTrigger,
      _ actual: NotEqualsClauseInTrigger,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsEqualsClauseInTrigger(
          expected.equals,
          actual.equals,
          message,
          file,
          line)
    }

    private func  assertEqualsRangeClauseInTrigger(
      _ expected: RangeClauseInTrigger,
      _ actual: RangeClauseInTrigger,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsWrapper(
          expected.alias,
          actual.alias,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected.field,
          actual.field,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected.lowerLimit,
          actual.lowerLimit,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected.lowerIncluded,
          actual.lowerIncluded,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected.upperLimit,
          actual.upperLimit,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected.upperIncluded,
          actual.upperIncluded,
          message,
          file: file,
          line: line)
    }

    private func  assertEqualsAndClauseInTrigger(
      _ expected: AndClauseInTrigger,
      _ actual: AndClauseInTrigger,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsTriggerClauseArray(
          expected.clauses,
          actual.clauses,
          message,
          file,
          line)
    }

    private func  assertEqualsOrClauseInTrigger(
      _ expected: OrClauseInTrigger,
      _ actual: OrClauseInTrigger,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsTriggerClauseArray(
          expected.clauses,
          actual.clauses,
          message,
          file,
          line)
    }

    private func  assertEqualsTriggerClauseArray(
      _ expected: [TriggerClause],
      _ actual: [TriggerClause],
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsWrapper(
          expected.count,
          actual.count,
          message,
          file: file,
          line: line)
        for (index, exp) in expected.enumerated() {
            assertEqualsTriggerClause(
              exp,
              actual[index],
              message ?? "index=\(index)",
              file,
              line)
        }
    }
}
