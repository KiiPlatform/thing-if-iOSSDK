//
//  XCTest+Utils.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
import XCTest
@testable import ThingIFSDK

extension XCTestCase {

    func assertEqualsAliasActionResultArray(
      _ expected: [AliasActionResult]?,
      _ actual: [AliasActionResult]?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected,actual, message, file, line)
        if expected == nil && actual == nil {
            return
        }

        assertEqualsWrapper(
          expected!.count,
          actual!.count,
          message,
          file: file,
          line: line)
        for (index, exp) in expected!.enumerated() {
            assertEqualsAliasActionResult(
              exp,
              actual![index],
              message,
              file,
              line)
        }
    }

    func assertEqualsAliasActionResult(
      _ expected: AliasActionResult?,
      _ actual: AliasActionResult?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected, actual, message, file, line)
        if expected == nil && actual == nil {
            return
        }

        assertEqualsWrapper(
          expected!.alias,
          actual!.alias,
          message,
          file: file,
          line: line)
        assertEqualsActionResultArray(
          expected!.results,
          actual!.results,
          message,
          file,
          line)
    }

    func assertEqualsActionResultArray(
      _ expected: [ActionResult]?,
      _ actual: [ActionResult]?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected,actual, message, file, line)
        if expected == nil && actual == nil {
            return
        }

        assertEqualsWrapper(
          expected!.count,
          actual!.count,
          message,
          file: file,
          line: line)
        for (index, exp) in expected!.enumerated() {
            assertEqualsActionResult(
              exp,
              actual![index],
              message,
              file,
              line)
        }
    }

    func assertEqualsActionResult(
      _ expected: ActionResult?,
      _ actual: ActionResult?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected, actual, message, file, line)
        if expected == nil && actual == nil {
            return
        }

        assertEqualsWrapper(
          expected!.succeeded,
          actual!.succeeded,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected!.actionName,
          actual!.actionName,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected!.errorMessage,
          actual!.errorMessage,
          message,
          file: file,
          line: line)
    }

    internal func assertOnlyOneNil(
      _ expected: Any?,
      _ actual: Any?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        if expected == nil && actual == nil {
            return
        } else if expected != nil && actual != nil {
            return
        }
        let errorMessage = message ?? "One is nil, the other is not nil."
        XCTFail("file=\(file), line=\(line): \(errorMessage)")
    }

    func assertEqualsAliasActionArray(
      _ expected: [AliasAction]?,
      _ actual: [AliasAction]?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected,actual, message, file, line)
        if expected == nil && actual == nil {
            return
        }

        assertEqualsWrapper(
          expected!.count,
          actual!.count,
          message,
          file: file,
          line: line)
        for (index, exp) in expected!.enumerated() {
            assertEqualsAliasAction(exp, actual![index], message, file, line)
        }
    }

    func assertEqualsAliasAction(
      _ expected: AliasAction?,
      _ actual: AliasAction?,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected, actual, message, file, line)

        if expected == nil && actual == nil {
            return
        }
        assertEqualsWrapper(
          expected!.alias,
          actual!.alias,
          message,
          file: file,
          line: line)
        assertEqualsDictionary(
          expected!.action,
          actual!.action,
          message,
          file,
          line)
    }

    internal func assertEqualsWrapper<T : Equatable>(
      _ expected: T?,
      _ actual: T?,
      _ message: String? = nil,
      file: StaticString = #file,
      line: UInt = #line)
    {
        if message == nil {
            XCTAssertEqual(expected, actual, file: file, line: line)
        } else {
            XCTAssertEqual(expected, actual, message!, file: file, line: line)
        }
    }

    internal func assertEqualsWrapper<T : Equatable>(
      _ expected: T,
      _ actual: T,
      _ message: String? = nil,
      file: StaticString = #file,
      line: UInt = #line)
    {
        if message == nil {
            XCTAssertEqual(expected, actual, file: file, line: line)
        } else {
            XCTAssertEqual(expected, actual, message!, file: file, line: line)
        }
    }

    func assertEqualsTimeRange(
      _ expected: TimeRange?,
      _ actual: TimeRange?,
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

        assertEqualsWrapper(
          expected?.from,
          actual?.from,
          message,
          file: file,
          line: line)
        assertEqualsWrapper(
          expected?.to,
          actual?.to,
          message,
          file: file,
          line: line)
    }

    func assertEqualsQueryClause(
      _ expected: QueryClause?,
      _ actual: QueryClause?,
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

        if type(of: expected!) === EqualsClauseInQuery.self {
            assertEqualsEqualsClauseInQuery(
              expected as! EqualsClauseInQuery,
              actual as! EqualsClauseInQuery,
              message,
              file,
              line)
        } else if type(of: expected!) === NotEqualsClauseInQuery.self {
            assertEqualsNotEqualsClauseInQuery(
              expected as! NotEqualsClauseInQuery,
              actual as! NotEqualsClauseInQuery,
              message,
              file,
              line)
        } else if type(of: expected!) === RangeClauseInQuery.self {
            assertEqualsRangeClauseInQuery(
              expected as! RangeClauseInQuery,
              actual as! RangeClauseInQuery,
              message,
              file,
              line)
        } else if type(of: expected!) === AndClauseInQuery.self {
            assertEqualsAndClauseInQuery(
              expected as! AndClauseInQuery,
              actual as! AndClauseInQuery,
              message,
              file,
              line)
        } else if type(of: expected!) === OrClauseInQuery.self {
            assertEqualsOrClauseInQuery(
              expected as! OrClauseInQuery,
              actual as! OrClauseInQuery,
              message,
              file,
              line)
        } else {
            XCTFail(
              "unknown type: \(Mirror(reflecting: expected!).subjectType)")
        }
    }

    private func  assertEqualsEqualsClauseInQuery(
      _ expected: EqualsClauseInQuery,
      _ actual: EqualsClauseInQuery,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
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

    private func  assertEqualsNotEqualsClauseInQuery(
      _ expected: NotEqualsClauseInQuery,
      _ actual: NotEqualsClauseInQuery,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsEqualsClauseInQuery(
          expected.equals,
          actual.equals,
          message,
          file,
          line)
    }

    private func  assertEqualsRangeClauseInQuery(
      _ expected: RangeClauseInQuery,
      _ actual: RangeClauseInQuery,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
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

    private func  assertEqualsAndClauseInQuery(
      _ expected: AndClauseInQuery,
      _ actual: AndClauseInQuery,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsQueryClauseArray(
          expected.clauses,
          actual.clauses,
          message,
          file,
          line)
    }

    private func  assertEqualsOrClauseInQuery(
      _ expected: OrClauseInQuery,
      _ actual: OrClauseInQuery,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertEqualsQueryClauseArray(
          expected.clauses,
          actual.clauses,
          message,
          file,
          line)
    }

    private func  assertEqualsQueryClauseArray(
      _ expected: [QueryClause],
      _ actual: [QueryClause],
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
            assertEqualsQueryClause(
              exp,
              actual[index],
              message ?? "index=\(index)",
              file,
              line)
        }
    }

    func assertEqualsWithAccuracyOrNil<T: FloatingPoint>(
      _ expected:  T?,
      _ actual: T?,
      accuracy: T,
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

        if message == nil {
            XCTAssertEqualWithAccuracy(
              expected!,
              actual!,
              accuracy: accuracy,
              file: file,
              line: line)
        } else {
            XCTAssertEqualWithAccuracy(
              expected!,
              actual!,
              accuracy: accuracy,
              message!,
              file: file,
              line: line)
        }
    }


    func assertEqualsAny(
      _ expected:  Any?,
      _ actual: Any?,
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

        if expected is String && actual is String {
            assertEqualsWrapper(
              expected as! String,
              actual as! String,
              message,
              file: file,
              line: line)
            return
        } else if expected is Int && actual is Int {
            assertEqualsWrapper(
              expected as! Int,
              actual as! Int,
              message,
              file: file,
              line: line)
            return
        } else if expected is Bool && actual is Bool {
            assertEqualsWrapper(
              expected as! Bool,
              actual as! Bool,
              message,
              file: file,
              line: line)
            return
        } else {
            let errorMessage = message ?? "Types are different."
            XCTFail(
              "file=\(file), line=\(line): \(errorMessage)")
            return
        }
    }

    func assertEqualsDictionary(
      _ expected: [String : Any]?,
      _ actual: [String : Any]?,
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

        if !NSDictionary(dictionary: expected!).isEqual(to: actual!) {
            let errorMessage = (message ?? "") +
              ", expected= " + expected!.description +
              ", actual= " + actual!.description
            XCTFail(
              "file=\(file), line=\(line): \(errorMessage)")
            return
        }
    }

    func verifyArray(_ expected: [Any]?,
                     actual: [Any]?,
                     message: String? = nil)
    {
        if expected == nil && actual == nil {
            return
        }
        guard let expected2 = expected, let actual2 = actual else {
            XCTFail("one of expected or actual is nil")
            return
        }

        let error_message: String
        if let message2 = message {
            error_message = message2 + ", expected=" + expected2.description +
              "actual=" + actual2.description
        } else {
            error_message = "expected=" + expected2.description +
              "actual=" + actual2.description
        }
        XCTAssertEqual(NSArray(array: expected2), NSArray(array: actual2),
                      error_message)
    }
    
    func verifyDict2(_ expectedDict:Dictionary<String, Any>?, _ actualDict: Dictionary<String, Any>?, _ errorMessage: String? = nil){
        if expectedDict == nil && actualDict == nil {
            return
        }
        verifyDict(expectedDict!,
                   actualDict: actualDict,
                   errorMessage: errorMessage)
    }

    func verifyDict(_ expectedDict:Dictionary<String, Any>, actualDict: Dictionary<String, Any>?, errorMessage: String? = nil){
        guard let actualDict2 = actualDict else {
            XCTFail("actualDict must not be nil")
            return
        }

        let s: String
        if let message = errorMessage {
            s = message + ", expected=" +
              expectedDict.description + "actual" + actualDict2.description
        } else {
            s = "expected=" + expectedDict.description +
              "actual" + actualDict2.description
        }
        XCTAssertTrue(NSDictionary(dictionary: expectedDict).isEqual(to: actualDict2), s)
    }
    func verifyNsDict(_ expectedDict:NSDictionary, actualDict:NSDictionary){
        let s = "expected=" + expectedDict.description + "actual" + actualDict.description
        XCTAssertTrue(expectedDict.isEqual(to: actualDict as! [AnyHashable: Any]), s)
    }
    
    func verifyDict(_ expectedDict:Dictionary<String, Any>, actualData: Data){
        
        do{
            let actualDict: NSDictionary = try JSONSerialization.jsonObject(with: actualData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let s = "\nexpected=" + expectedDict.description + "\nactual" + actualDict.description
            XCTAssertTrue(NSDictionary(dictionary: expectedDict).isEqual(to: actualDict as! [AnyHashable: Any]), s)
        }catch(_){
            XCTFail()
        }
    }

    func XCTAssertEqualDictionaries<S, T: Equatable>(_ first: [S:T], _ second: [S:T]) {
        XCTAssert(first == second)
    }

    func XCTAssertEqualIoTAPIWithoutTarget(_ first: ThingIFAPI, _ second: ThingIFAPI) {
        XCTAssertEqual(first.appID, second.appID)
        XCTAssertEqual(first.appKey, second.appKey)
        XCTAssertEqual(first.baseURL, second.baseURL)
        XCTAssertEqual(first.installationID, second.installationID)
    }
}
