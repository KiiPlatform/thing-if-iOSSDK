//
//  DeleteTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//
import XCTest
@testable import ThingIFSDK

class DeleteTriggerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDeleteTrigger_success() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation = self.expectationWithDescription("enableTriggerTests")

        // perform onboarding
        api._target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify delete request
        let deleteRequestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "DELETE")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
            XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
        }
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 204, HTTPVersion: nil, headerFields: nil)
        MockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        MockSession.requestVerifier = deleteRequestVerifier
        iotSession = MockSession.self

        api.deleteTrigger(expectedTriggerID) { (trigger, error) -> Void in
            if error == nil{
                XCTAssertEqual(trigger!.triggerID, expectedTriggerID)
                XCTAssertEqual(trigger!.enabled, false)
            }else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testDeleteTrigger_404_error() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let owner = setting.owner
        let target = setting.target
        let expectation = self.expectationWithDescription("enableTrigger404Error")

        // perform onboarding
        api._target = setting.target

        do{
            let triggerID = "triggerID"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.typedID.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "DELETE")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)")
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.deleteTrigger(triggerID, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .CONNECTION:
                        XCTFail("should not be connection error")
                    case .ERROR_RESPONSE(let actualErrorResponse):
                        XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
                        XCTAssertEqual(responsedDict["errorCode"]!, actualErrorResponse.errorCode)
                        XCTAssertEqual(responsedDict["message"]!, actualErrorResponse.errorMessage)
                    default:
                        break
                    }
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testDeleteTrigger_trigger_not_available_error() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation = self.expectationWithDescription("testDeleteTrigger_trigger_not_available_error")

        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.deleteTrigger(triggerID, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE error")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}