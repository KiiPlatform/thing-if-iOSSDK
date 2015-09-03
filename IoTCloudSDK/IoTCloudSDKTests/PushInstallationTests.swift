//
//  PushInstallationTests.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/13/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class PushInstallationTests: XCTestCase {

    let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
    
    let schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)
    
    let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
        baseURL: "https://api-development-jp.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
    
    let deviceToken = "dummyDeviceToken"
    
    override func setUp() {
        super.setUp()
        setKiiLogLevel(.verbose)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func onboard(){
        let expectation = self.expectationWithDescription("onboardWithVendorThingID")
        
        do{
            let thingProperties:Dictionary<String, AnyObject> = ["key1":"value1", "key2":"value2"]
            let thingType = "LED"
            let vendorThingID = "th.abcd-efgh"
            let thingPassword = "dummyPassword"
            
            // mock response
            let dict = ["accessToken":"BrZ3M9fIqghhqhyiqnxncY6KXEFEZWJaP0894qtzu2E","thingID":"th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"]
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.onBoard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.targetType.toString(), "THING:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
                }else {
                    XCTFail("should success")
                }
                expectation.fulfill()
            }
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }
    func testPushInstallation_success() {
        
        self.onboard()
        let expectation = self.expectationWithDescription("testPushInstallation_success")
        //iotSession = NSURLSession.self
        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")
            
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.InstallationCreationRequest+json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            //verify request body
            let expectedBody = ["installationRegistrationID": self.deviceToken, "deviceType": "IOS","development":"false","userID": self.owner.ownerID.id]
            self.verifyDict(expectedBody, actualData: request.HTTPBody!)
        }
        
        let dict = ["installationID":"dummy_installation_ID"]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            
        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }
        
        api.installPush(self.deviceToken,development: false) { (installID, error) -> Void in
            XCTAssertTrue(error==nil,"should not error")
            
            XCTAssertNotNil(installID,"Should not nil")
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    func testPushInstallation_http_404() {
        self.onboard()
        let expectation = self.expectationWithDescription("testPushInstallation_http_404")
        //iotSession = NSURLSession.self
        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")
            
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.InstallationCreationRequest+json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            //verify request body
            let expectedBody = ["installationRegistrationID": self.deviceToken, "deviceType": "IOS","development":"false","userID": self.owner.ownerID.id]
            self.verifyDict(expectedBody, actualData: request.HTTPBody!)
        }
        
        let dict = ["errorCode":"USER_NOT_FOUND","message":"error message"]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            
        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }
        
        api.installPush(self.deviceToken,development: false) { (installID, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                
                switch error! {
                case .CONNECTION:
                    XCTFail("should not be connection error")
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }
    func testPushInstallation_http_400() {
        self.onboard()
        let expectation = self.expectationWithDescription("testPushInstallation_http_400")
        //iotSession = NSURLSession.self
        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")
            
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.InstallationCreationRequest+json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            //verify request body
            let expectedBody = ["installationRegistrationID": self.deviceToken, "deviceType": "IOS","development":"false","userID": self.owner.ownerID.id]
            self.verifyDict(expectedBody, actualData: request.HTTPBody!)
        }
        
        let dict = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 400, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            
        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }
        
        api.installPush(self.deviceToken,development: false) { (installID, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                
                switch error! {
                case .CONNECTION:
                    XCTFail("should not be connection error")
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }
    func testPushInstallation_http_401() {
        self.onboard()
        let expectation = self.expectationWithDescription("testPushInstallation_http_401")
        //iotSession = NSURLSession.self
        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "POST")
            
            //verify header
            let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.InstallationCreationRequest+json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            //verify request body
            let expectedBody = ["installationRegistrationID": self.deviceToken, "deviceType": "IOS","development":"false","userID": self.owner.ownerID.id]
            self.verifyDict(expectedBody, actualData: request.HTTPBody!)
        }
        
        let dict = ["errorCode":"INVALID_INPUT_DATA","message":"error message"]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 401, HTTPVersion: nil, headerFields: nil)
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            
        }catch(_){
            //should never reach this
            XCTFail("exception happened")
            return;
        }
        
        api.installPush(self.deviceToken,development: false) { (installID, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                
                switch error! {
                case .CONNECTION:
                    XCTFail("should not be connection error")
                case .ERROR_RESPONSE(let actualErrorResponse):
                    XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(dict["errorCode"]!, actualErrorResponse.errorCode)
                    XCTAssertEqual(dict["message"]!, actualErrorResponse.errorMessage)
                default:
                    break
                }
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

    }

}
