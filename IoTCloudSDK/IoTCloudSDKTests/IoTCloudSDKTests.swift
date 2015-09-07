//
//  IoTCloudSDKTests.swift
//  IoTCloudSDKTests
//
//  Created by 熊野 聡 on 2015/07/27.
//  Copyright (c) 2015年 Kii. All rights reserved.
//

import UIKit
import XCTest
@testable import IoTCloudSDK

class IoTCloudSDKTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSavedInstance(){
        let tags = ["tag1","tag2","tag3"]

        let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
        let api1 = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc"),tag:tags[0]).build()
        let api2 = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc"),tag:tags[1]).build()
        do{
            var temp = try IoTCloudAPI.loadWithStoredInstance()
             XCTAssertEqual(api,temp , "should be equal")
            temp = try IoTCloudAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api1,temp , "should be equal")
            temp = try IoTCloudAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api2,temp , "should be equal")
        }catch(_){
            XCTFail("Should not raise exception")
        }


        do{
            IoTCloudAPI.removeStoredInstances(nil)
            try IoTCloudAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        }catch(_){

        }
        do{
            IoTCloudAPI.removeStoredInstances(tags[0])
            try IoTCloudAPI.loadWithStoredInstance(tags[0])
            XCTFail("Should raise exception")
        }catch(_){

        }

        do{
            IoTCloudAPI.removeAllStoredInstances()
            try IoTCloudAPI.loadWithStoredInstance(tags[1])
            XCTFail("Should raise exception")
        }catch(_){

        }

    }
    
}
