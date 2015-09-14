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
        IoTCloudAPI.removeAllStoredInstances()
    }
    
    override func tearDown() {
        IoTCloudAPI.removeAllStoredInstances()
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

    func testInvalidSavedInstance(){

        let persistance = NSUserDefaults.standardUserDefaults()
        let baseKey = "IoTCloudAPI_INSTANCE"
        //clear
        persistance.removeObjectForKey(baseKey)
        persistance.synchronize()

        do{
            try IoTCloudAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        }catch(let e as IoTCloudError){
            switch e {
            case .API_NOT_STORED:
                break
            default:
                XCTFail("Exception should be API_NOT_STORED")
                break
            }

        }catch(_){
            XCTFail("Exception should be API_NOT_STORED")
        }

        //set invalid object to base key
        persistance.setInteger(1, forKey: baseKey)
        persistance.synchronize()

        do{
            try IoTCloudAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        }catch(let e as IoTCloudError){
            switch e {
            case .API_NOT_STORED:
                break
            default:
                XCTFail("Exception should be API_NOT_STORED")
                break
            }

        }catch(_){
            XCTFail("Exception should be API_NOT_STORED")
        }

        //set empty dict to base key
        persistance.setObject(NSDictionary(), forKey: baseKey)
        persistance.synchronize()

        do{
            try IoTCloudAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        }catch(let e as IoTCloudError){
            switch e {
            case .INVALID_STORED_API:
                break
            default:
                XCTFail("Exception should be INVALID_STORED_API")
                break
            }

        }catch(_){
            XCTFail("Exception should be INVALID_STORED_API")
        }

        //set invalid object to the persistance
        persistance.setObject(NSDictionary(dictionary: [baseKey:""]), forKey: baseKey)
        persistance.synchronize()

        do{
            try IoTCloudAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        }catch(let e as IoTCloudError){
            switch e {
            case .INVALID_STORED_API:
                break
            default:
                XCTFail("Exception should be INVALID_STORED_API")
                break
            }

        }catch(_){
            XCTFail("Exception should be INVALID_STORED_API")
        }

    }
    
}
