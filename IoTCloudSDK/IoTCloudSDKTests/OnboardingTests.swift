//
//  IoTCloudAPITests.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/11/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class OnboardingTests: XCTestCase {

    let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

    let schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)

    var api : IoTCloudAPI!


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func checkSavedIoTAPI(){
        do{
            let savedIoTAPI = try IoTCloudAPI.loadWithStoredInstance(api.tag)
            XCTAssertNotNil(savedIoTAPI)
            XCTAssertTrue(api == savedIoTAPI)
        }catch(let e){
            print(e)
            XCTFail("Should not throw")
        }
    }
    func testOnboardWithThingIDFail() {
        
        let expectation = self.expectationWithDescription("onboardWithThingID")
        

        do{
            let dict = ["errorCode":"INVALID_INPUT_DATA","message":"There are validation errors: password - password is required.", "invalidFields":["password": "password is required"]]

            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)

            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 400, HTTPVersion: nil, headerFields: nil)
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                
                //verify request header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.OnboardingWithThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify request body
                let expectedBody = ["thingID": "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", "thingPassword": "dummyPassword", "owner": self.owner.ownerID.toString()]
                self.verifyDict(expectedBody, actualData: request.HTTPBody!)
                
            }
            
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            
            iotSession = MockSession.self
            api.onboard("th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", thingPassword: "dummyPassword") { ( target, error) -> Void in
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
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
        checkSavedIoTAPI()
    }
    
    func testOnboardWithVendorThingIDSuccess() {
        
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
                
                //verify body
                let expectedBody = ["vendorThingID": vendorThingID, "thingPassword": thingPassword, "owner": self.owner.ownerID.toString(), "thingType":thingType, "thingProperties":["key1":"value1", "key2":"value2"]]
                self.verifyDict(expectedBody as! Dictionary<String, AnyObject>, actualData: request.HTTPBody!)
                
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.onboard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.targetType.toString(), "THING:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
                    XCTAssertEqual(self.api.target!.targetType.toString(), "THING:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
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
        checkSavedIoTAPI()

    }

    func testOnboardWithThingID_already_onboarded_error() {
        let expectation = self.expectationWithDescription("testOnboardWithThingID_already_onboarded_error")

        api._target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))
        api.onboard("dummyThingID", thingPassword: "dummyPassword") { (target, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .ALREADY_ONBOARDED:
                    break
                default:
                    XCTFail("should be ALREADY_ONBOARDED error")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndImplementTag() {

        let expectation = self.expectationWithDescription("onboardWithVendorThingID")

        api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc"),tag:"target1").build()
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

                //verify body
                let expectedBody = ["vendorThingID": vendorThingID, "thingPassword": thingPassword, "owner": self.owner.ownerID.toString(), "thingType":thingType, "thingProperties":["key1":"value1", "key2":"value2"]]
                self.verifyDict(expectedBody as! Dictionary<String, AnyObject>, actualData: request.HTTPBody!)

            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.onboard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.targetType.toString(), "THING:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
                    XCTAssertEqual(self.api.target!.targetType.toString(), "THING:th.0267251d9d60-1858-5e11-3dc3-00f3f0b5")
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
        checkSavedIoTAPI()
        
    }

    
}
