//
//  PushUninstallationTests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/17/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PushUninstallationTests: SmallTestBase {
    let deviceToken = "dummyDeviceToken"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

    func onboard(_ setting:TestSetting){
        let expectation = self.expectation(description: "onboardWithVendorThingID")
        
        do{
            let thingProperties:Dictionary<String, Any> = ["key1":"value1", "key2":"value2"]
            let thingType = "LED"
            let vendorThingID = "th.abcd-efgh"
            let thingPassword = "dummyPassword"
            
            // mock response
            let dict = ["accessToken":"BrZ3M9fIqghhqhyiqnxncY6KXEFEZWJaP0894qtzu2E","thingID":"th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"]
            
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            setting.api.onboard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.typedID.toString(), "thing:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
                }else {
                    XCTFail("should success")
                }
                expectation.fulfill()
            }
        }catch(let e){
            print(e)
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        setting.api._installationID = "dummyInstallationID"
    }
    func testPushUninstallation_success() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectation(description: "testPushUninstallation_success")
        let installID = "dummyInstallId"
        
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "DELETE")
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.api.appID)/installations/\(installID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/api/apps/50a62843/installations/\(installID)")
        }
        
        let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 204, httpVersion: nil, headerFields: nil)
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self
        
        setting.api.uninstallPush(installID) { (error) -> Void in
            XCTAssertTrue(error==nil,"should not error")
            XCTAssertNil(setting.api._installationID,"Should be nil")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        checkSavedIoTAPI(setting)
    }
    func testPushUninstallation_http_404() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectation(description: "testPushUninstallation_http_404")
        let installID = "dummyInstallId"
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "DELETE")
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.api.appID)/installations/\(installID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            
        }
        
        let dict = ["errorCode":"INSTALLATION_NOT_FOUND","message":"error message"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }
        
        setting.api.uninstallPush(installID) { (error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                
                switch error! {
                case .connection:
                    XCTFail("should not be connection error")
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        checkSavedIoTAPI(setting)
    }
    func testPushUninstallation_http_401() {
        let setting = TestSetting()
        self.onboard(setting)
        let expectation = self.expectation(description: "testPushUninstallation_http_401")
        let installID = "dummyInstallId"
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "DELETE")
            let expectedPath = "\(setting.api.baseURL)/api/apps/\(setting.api.appID)/installations/\(installID)"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            
        }
        
        let dict = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            let urlResponse = HTTPURLResponse(url: URL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }
        
        setting.api.uninstallPush(installID) { (error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                
                switch error! {
                case .connection:
                    XCTFail("should not be connection error")
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        checkSavedIoTAPI(setting)
    }
    
}
