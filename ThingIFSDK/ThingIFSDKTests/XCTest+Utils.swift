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

    func executeAsynchronous(
      description: String = "Asynchronous test executing",
      timeout: TimeInterval = 5.0,
      file: StaticString = #file,
      line: UInt = #line,
      _ executing: @escaping (XCTestExpectation) -> Void) -> Void
    {
        let expectation = self.expectation(description: description)
        executing(expectation)
        self.waitForExpectations(timeout: timeout) {
            XCTAssertNil($0, file: file, line: line)
        }
    }

    internal func makeRequestVerifier(
      file: StaticString = #file,
      line: UInt = #line,
      requestVerifier: @escaping (URLRequest) throws -> Void)
          -> (URLRequest) -> Void
    {
        return {
            request in

            do {
                try requestVerifier(request)
            } catch let error {
                XCTFail(
                  error as! String,
                  file: file,
                  line: line)
            }
        } as (URLRequest) -> Void
    }

    internal func fail(
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        if (message == nil) {
            XCTFail(file: file, line: line)
        } else {
            XCTFail(message!, file: file, line: line)
        }
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
        fail(message, file, line)
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

    func assertEqualsWithAccuracyOrNil<T: FloatingPoint>(
      _ expected:  T?,
      _ actual: T?,
      accuracy: T,
      _ message: String? = nil,
      _ file: StaticString = #file,
      _ line: UInt = #line)
    {
        assertOnlyOneNil(expected, actual, message, file, line)
        if expected == nil && actual == nil {
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
        assertOnlyOneNil(expected, actual, message, file, line)
        if expected == nil && actual == nil {
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
            fail(message, file, line)
            return
        }
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

}
