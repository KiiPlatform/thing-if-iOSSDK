//
//  ThingIFAPIPushUninstallationTests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/17/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIPushUninstallationTests: SmallTestBase {
    let deviceToken = "dummyDeviceToken"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    override class func defaultTestSuite() -> XCTestSuite { //TODO: This is temporary to mark crashed test, remove this later

        let testSuite = XCTestSuite(name: NSStringFromClass(self))

        return testSuite
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
            setting.api.onboardWith(
              vendorThingID: vendorThingID,
              thingPassword: thingPassword,
              options: OnboardWithVendorThingIDOptions(
                thingType,
                thingProperties: thingProperties)) { ( target, error) -> Void in
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
        setting.api.installationID = "dummyInstallationID"
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
            XCTAssertEqual("dummyInstallationID", setting.api.installationID)
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

    func testInvalidArgumentError() {
        let setting = TestSetting()

        setting.api.uninstallPush() {
            error in

            XCTAssertEqual(
              ThingIFError.invalidArgument(
                message: "Both of installationID and self.installationID are nil."),
              error)
        }
    }

    func testUseInstallationIDProperty() throws {
        let expectation =
          self.expectation(description: "testUseInstallationIDProperty")
        let setting = TestSetting()
        let installationID = "dummyInstallationID"
        setting.api.installationID = installationID

        sharedMockSession.requestVerifier = makeRequestVerifier { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertEqual(
              "\(setting.api.baseURL)/api/apps/\(setting.api.appID)/installations/\(installationID)",
              request.url!.absoluteString)

            //verify header
            XCTAssertEqual(
              [
                "X-Kii-AppID": setting.app.appID,
                "X-Kii-AppKey": setting.app.appKey,
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                "Authorization": "Bearer \(setting.owner.accessToken)"
              ],
              request.allHTTPHeaderFields!)
        }

        sharedMockSession.mockResponse = (
          nil,
          HTTPURLResponse(
            url: URL(string: setting.app.baseURL)!,
            statusCode: 204,
            httpVersion: nil,
            headerFields: nil),
          nil)
        iotSession = MockSession.self

        setting.api.uninstallPush() { error in
            XCTAssertNil(error)
            XCTAssertNil(setting.api.installationID)
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
