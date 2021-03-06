//
//  XCTest+Utils.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
import XCTest
@testable import ThingIF

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
            if (message == nil) {
                XCTFail(file: file, line: line)
            } else {
                XCTFail(message!, file: file, line: line)
            }
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

}
