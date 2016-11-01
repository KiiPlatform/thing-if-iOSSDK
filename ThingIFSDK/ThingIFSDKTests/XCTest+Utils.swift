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
