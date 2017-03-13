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

class ThingIFSDKTests: SmallTestBase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSavedInstanceWithInstallPush(){
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        
        let api1 = ThingIFAPIBuilder(app:app, owner:owner).make()
        let api2 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[0]).make()
        let api3 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[1]).make()
        
        var expectation = self.expectation(description: "testSavedInstanceWithInstallPush")
        setMockResponse4InstallPush("installationID-0001", setting: setting);
        api1.installPush("deviceToken-0001".data(using: String.Encoding.utf8)!, development: false) { (installID, error) -> Void in
            XCTAssertNil(error,"should not error")
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        
        expectation = self.expectation(description: "testSavedInstanceWithInstallPush")
        setMockResponse4InstallPush("installationID-0002", setting: setting);
        api2.installPush("deviceToken-0002".data(using: String.Encoding.utf8)!, development: false) { (installID, error) -> Void in
            XCTAssertNil(error,"should not error")
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        expectation = self.expectation(description: "testSavedInstanceWithInstallPush")
        setMockResponse4InstallPush("installationID-0003", setting: setting);
        api3.installPush("deviceToken-0003".data(using: String.Encoding.utf8)!, development: false) { (installID, error) -> Void in
            XCTAssertNil(error,"should not error")
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        do {
            var temp = try ThingIFAPI.loadWithStoredInstance()
            XCTAssertEqual(api1, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api2, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api3, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }
        
        ThingIFAPI.removeStoredInstances(nil)
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            switch error {
            case ThingIFError.apiNotStored:
                // Succeed.
                break;
            default:
                XCTFail("Unexpect error")
            }
        }
        ThingIFAPI.removeStoredInstances(tags[0])
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[0])) { error in
            switch error {
            case ThingIFError.apiNotStored:
                // Succeed.
                break;
            default:
                XCTFail("Unexpect error")
            }
        }
        
        ThingIFAPI.removeAllStoredInstances()
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[1])) { error in
            switch error {
            case ThingIFError.apiNotStored:
                // Succeed.
                break;
            default:
                XCTFail("Unexpect error")
            }
        }
    }
    private func setMockResponse4InstallPush(_ installationID: String, setting:TestSetting) -> Void {
        let dict = ["installationID":installationID]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string: setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            iotSession = MockSession.self
        } catch {
            //should never reach this
            XCTFail("exception happened")
            return;
        }

    }
    func testSavedInstanceWithCopyWithTarget(){
        let tags = ["tag1","tag2"]
        let setting = TestSetting()
        let app = setting.app
        let owner = setting.owner
        
        let target1 = StandaloneThing(thingID: "user-00001", vendorThingID: "vendor-thing-id-001", accessToken: "token-00001")
        let target2 = StandaloneThing(thingID: "user-00002", vendorThingID: "vendor-thing-id-002", accessToken: "token-00002")
        let target3 = StandaloneThing(thingID: "user-00003", vendorThingID: "vendor-thing-id-003", accessToken: "token-00003")
        
        var api1 = ThingIFAPIBuilder(app:app, owner:owner).make()
        var api2 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[0]).make()
        var api3 = ThingIFAPIBuilder(app:app, owner:owner, tag:tags[1]).make()
        
        api1 = api1.copyWithTarget(target1)
        api2 = api2.copyWithTarget(target2, tag: tags[0])
        api3 = api3.copyWithTarget(target3, tag: tags[1])
        do {
            var temp = try ThingIFAPI.loadWithStoredInstance()
            XCTAssertEqual(api1, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[0])
            XCTAssertEqual(api2, temp , "should be equal")
            temp = try ThingIFAPI.loadWithStoredInstance(tags[1])
            XCTAssertEqual(api3, temp , "should be equal")
        } catch {
            XCTFail("Should not raise exception ")
        }
        
        ThingIFAPI.removeStoredInstances(nil)
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance()) { error in
            switch error {
            case ThingIFError.apiNotStored:
                // Succeed.
                break;
            default:
                XCTFail("Unexpect error")
            }
        }
        ThingIFAPI.removeStoredInstances(tags[0])
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[0])) { error in
            switch error {
            case ThingIFError.apiNotStored:
                // Succeed.
                break;
            default:
                XCTFail("Unexpect error")
            }
        }
        
        ThingIFAPI.removeAllStoredInstances()
        XCTAssertThrowsError(try ThingIFAPI.loadWithStoredInstance(tags[1])) { error in
            switch error {
            case ThingIFError.apiNotStored:
                // Succeed.
                break;
            default:
                XCTFail("Unexpect error")
            }
        }
    }

}
