//
//  XCTest+Utils.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
import XCTest
@testable import IoTCloudSDK

extension XCTestCase {
    
    func verifyDict(expectedDict:Dictionary<String, AnyObject>, actualData: NSData){
        
        do{
            let actualDict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(actualData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            for (key, value) in actualDict {
                if value is String {
                    XCTAssertEqual(value as? String, expectedDict[key as! String] as? String)
                }else if value is NSDictionary{
                    let valueDict = value as! NSDictionary
                    if let expectedValueDict = expectedDict[key as! String] as? Dictionary<String, String> {
                        for (key1, value1) in valueDict {
                            XCTAssertEqual(value1 as? String, expectedValueDict[key1 as! String]! )
                        }
                    }else{
                        XCTFail()
                    }
                }
            }
        }catch(_){
            XCTFail()
        }
    }

    func XCTAssertEqualDictionaries<S, T: Equatable>(first: [S:T], _ second: [S:T]) {
        XCTAssert(first == second)
    }

    func XCTAssertEqualIoTAPIWithoutTarget(first: IoTCloudAPI, _ second: IoTCloudAPI) {
        XCTAssertEqual(first.appID, second.appID)
        XCTAssertEqual(first.appKey, second.appKey)
        XCTAssertEqual(first.baseURL, second.baseURL)
        XCTAssertEqual(first.installationID, second.installationID)
    }
}
