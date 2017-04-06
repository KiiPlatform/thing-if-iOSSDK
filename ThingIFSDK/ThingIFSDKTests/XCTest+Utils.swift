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
      _ executing: @escaping (XCTestExpectation) -> Void) -> Void
    {
        let expectation = self.expectation(description: description)
        executing(expectation)
        self.waitForExpectations(timeout: timeout) { XCTAssertNil($0) }
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
