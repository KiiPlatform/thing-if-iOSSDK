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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOnboardWithThingIDFail() {
        
        let expectation = self.expectationWithDescription("onboardWithThingID")
        
        let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
        
        let schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)
        
        let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: owner).addSchema(schema).build()
        
        do{
            let dict = ["errorCode":"INVALID_INPUT_DATA","message":"There are validation errors: password - password is required.", "invalidFields":["password": "password is required"]]

            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)

            let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://api-development-jp.internal.kii.com")!, statusCode: 400, HTTPVersion: nil, headerFields: nil)
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                
                //verify request header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.OnboardingWithThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify request body
                let expectedBody = ["thingID": "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", "thingPassword": "dummyPassword", "owner": owner.ownerID.toString()]
                self.verifyDict(expectedBody, actualData: request.HTTPBody!)
                
            }
            
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            
            iotSession = MockSession.self
            
            try api.onBoard("th.0267251d9d60-1858-5e11-3dc3-00f3f0b5", thingPassword: "dummyPassword") { ( target, error) -> Void in
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
    }
    
    func testOnboardWithVendorThingIDSuccess() {
        
        let expectation = self.expectationWithDescription("onboardWithVendorThingID")
        
        let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
        
        let schema = Schema(thingType: "SmartLight-Demo",
            name: "SmartLight-Demo", version: 1)

        let api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://api-development-jp.internal.kii.com", owner: owner).addSchema(schema).build()
        
        do{
            let thingProperties = NSDictionary(dictionary: ["key1":"value1", "key2":"value2"])
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
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "appID": "50a62843", "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                
                //verify body
                let expectedBody = ["vendorThingID": vendorThingID, "thingPassword": thingPassword, "owner": owner.ownerID.toString(), "thingType":thingType, "thingProperties":["key1":"value1", "key2":"value2"]]
                self.verifyDict(expectedBody as! Dictionary<String, AnyObject>, actualData: request.HTTPBody!)
                
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            try api.onBoard(vendorThingID, thingPassword: thingPassword, thingType: thingType, thingProperties: thingProperties) { ( target, error) -> Void in
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
}
