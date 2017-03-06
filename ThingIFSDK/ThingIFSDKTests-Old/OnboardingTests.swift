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

    func testOnboardWithVendorThingIDSuccess() {
        
        let expectation = self.expectation(description: "onboardWithVendorThingID")
        let setting = TestSetting()
        let api = setting.api
        let owner = setting.owner

        do{
            let thingProperties:Dictionary<String, Any> = ["key1":"value1", "key2":"value2"]
            let thingType = "LED"
            let vendorThingID = "th.abcd-efgh"
            let thingPassword = "dummyPassword"
            
            // mock response
            let dict = ["accessToken":setting.ownerToken,"thingID":setting.thingID]
            
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            let urlResponse = HTTPURLResponse(url: URL(string: "https://\(setting.hostName)")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                
                //verify body
                let expectedBody: [String : Any] = ["vendorThingID": vendorThingID, "thingPassword": thingPassword, "owner": owner.typedID.toString(), "thingType":thingType, "thingProperties":["key1":"value1", "key2":"value2"]]
                self.verifyDict(expectedBody, actualData: request.httpBody!)
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/onboardings")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.onboardWith(
              vendorThingID: vendorThingID,
              thingPassword: thingPassword,
              options: OnboardWithVendorThingIDOptions(
                thingType: thingType,
                thingProperties: thingProperties)) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.typedID.toString(), "thing:\(setting.thingID)")
                    XCTAssertEqual(target!.typedID.toString(), "thing:\(setting.thingID)")
                    XCTAssertEqual(target!.accessToken, setting.ownerToken, "accessToken should equal to expected one")
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
        checkSavedIoTAPI(setting)

    }

    func testOnboardWithThingID_already_onboarded_error() {
        let expectation = self.expectation(description: "testOnboardWithThingID_already_onboarded_error")
        let setting = TestSetting()
        let api = setting.api

        api.target = setting.target
        api.onboardWith(
          thingID: "dummyThingID",
          thingPassword: "dummyPassword") { (target, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .alreadyOnboarded:
                    break
                default:
                    XCTFail("should be ALREADY_ONBOARDED error")
                }
            }
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testOnboardWithVendorThingIDAndImplementTag() {

        let expectation = self.expectation(description: "onboardWithVendorThingID")
        let setting = TestSetting()
        let owner = setting.owner
        let app = setting.app

        let api = ThingIFAPIBuilder(app:app, owner:owner, tag:"target1").make()
        do{
            let thingProperties:Dictionary<String, Any> = ["key1":"value1", "key2":"value2"]
            let thingType = "LED"
            let vendorThingID = "th.abcd-efgh"
            let thingPassword = "dummyPassword"

            // mock response
            let dict = ["accessToken":setting.ownerToken,"thingID":setting.thingID]

            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)

            let urlResponse = HTTPURLResponse(url: URL(string: "https://\(setting.hostName)")!, statusCode: 200, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/vnd.kii.OnboardingWithVendorThingIDByOwner+json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }

                //verify body
                let expectedBody: [String : Any] = ["vendorThingID": vendorThingID, "thingPassword": thingPassword, "owner": owner.typedID.toString(), "thingType":thingType, "thingProperties":["key1":"value1", "key2":"value2"]]
                self.verifyDict(expectedBody, actualData: request.httpBody!)
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/onboardings")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.onboardWith(
              vendorThingID:vendorThingID,
              thingPassword: thingPassword,
              options: OnboardWithVendorThingIDOptions(
                thingType: thingType,
                thingProperties: thingProperties)) { ( target, error) -> Void in
                if error == nil{
                    XCTAssertEqual(target!.typedID.toString(), "thing:\(setting.thingID)")
                    XCTAssertEqual(target!.typedID.toString(), "thing:\(setting.thingID)")
                    XCTAssertEqual(target!.accessToken, setting.ownerToken, "accessToken should equal to expected one")
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
    }

    
}
