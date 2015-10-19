//
//  ThingIFSDKTests.swift
//  ThingIFSDKTests
//
//  Created by 熊野 聡 on 2015/07/27.
//  Copyright (c) 2015年 Kii. All rights reserved.
//

import UIKit
import XCTest
@testable import ThingIFSDK

class ThingIFSDKTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        ThingIFAPI.removeAllStoredInstances()
    }
    
    override func tearDown() {
        ThingIFAPI.removeAllStoredInstances()
        super.tearDown()
    }
    
    func testSavedInstance(){
        let tags = ["tag1","tag2","tag3"]

        let api = ThingIFAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            site: Site.CUSTOM("https://api-development-jp.internal.kii.com"), owner: Owner(typedID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
        let api1 = ThingIFAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            site: Site.CUSTOM("https://api-development-jp.internal.kii.com"), owner: Owner(typedID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc"),tag:tags[0]).build()
        let api2 = ThingIFAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            site: Site.CUSTOM("https://api-development-jp.internal.kii.com"), owner: Owner(typedID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc"),tag:tags[1]).build()
        do{
            var temp = try ThingIFAPI.loadWithStoredInstance()
             XCTAssertEqual(api,temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api1,temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api2,temp , "should be equal")
        }catch(_){
            XCTFail("Should not raise exception")
        }


        do{
            ThingIFAPI.removeStoredInstances(nil)
            try ThingIFAPI.loadWithStoredInstance()
            XCTFail("Should raise exception")
        }catch(_){

        }
        do{
            ThingIFAPI.removeStoredInstances(tags[0])
            try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTFail("Should raise exception")
        }catch(_){

        }

        do{
            ThingIFAPI.removeAllStoredInstances()
            try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTFail("Should raise exception")
        }catch(_){

        }

    }

    func testInvalidSavedInstance(){

        let persistance = NSUserDefaults.standardUserDefaults()
        let baseKey = "ThingIFAPI_INSTANCE"
        //clear
        persistance.removeObjectForKey(baseKey)
        persistance.synchronize()

        do{
            try ThingIFAPI.loadWithStoredInstance()
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
            try ThingIFAPI.loadWithStoredInstance()
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
            try ThingIFAPI.loadWithStoredInstance()
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
            try ThingIFAPI.loadWithStoredInstance()
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
