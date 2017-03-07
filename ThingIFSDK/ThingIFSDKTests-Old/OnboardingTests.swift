//
//  ThingIFAPITests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/11/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class OnboardingTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func checkSavedIoTAPI(_ setting:TestSetting){
        do{
            let savedIoTAPI = try ThingIFAPI.loadWithStoredInstance(setting.api.tag)
            XCTAssertNotNil(savedIoTAPI)
            XCTAssertTrue(setting.api == savedIoTAPI)
        }catch(let e){
            print(e)
            XCTFail("Should not throw")
        }
    }
}
