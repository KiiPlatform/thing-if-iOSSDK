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
    
    func verifyDict(expectedDict:Dictionary<String, AnyObject>, actualDict: Dictionary<String, AnyObject>){
        let s = "expected=" + expectedDict.description + "actual" + actualDict.description
        XCTAssertTrue(NSDictionary(dictionary: expectedDict).isEqualToDictionary(actualDict), s)
    }
    func verifyNsDict(expectedDict:NSDictionary, actualDict:NSDictionary){
        let s = "expected=" + expectedDict.description + "actual" + actualDict.description
        XCTAssertTrue(expectedDict.isEqualToDictionary(actualDict as [NSObject : AnyObject]), s)
    }
    
    func verifyDict(expectedDict:Dictionary<String, AnyObject>, actualData: NSData){
        
        do{
            let actualDict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(actualData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            let s = "\nexpected=" + expectedDict.description + "\nactual" + actualDict.description
            XCTAssertTrue(NSDictionary(dictionary: expectedDict).isEqualToDictionary(actualDict as [NSObject : AnyObject]), s)
        }catch(_){
            XCTFail()
        }
    }

    func XCTAssertEqualDictionaries<S, T: Equatable>(first: [S:T], _ second: [S:T]) {
        XCTAssert(first == second)
    }

    func XCTAssertEqualIoTAPIWithoutTarget(first: ThingIFAPI, _ second: ThingIFAPI) {
        XCTAssertEqual(first.appID, second.appID)
        XCTAssertEqual(first.appKey, second.appKey)
        XCTAssertEqual(first.baseURL, second.baseURL)
        XCTAssertEqual(first.installationID, second.installationID)
    }
}
