//
//  DeleteTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//
import XCTest
@testable import ThingIFSDK

class DeleteTriggerTests: SmallTestBase {

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
        let expectation = self.expectation(description: "enableTriggerTests")

        // perform onboarding
        api._target = setting.target

        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        // verify delete request
        let deleteRequestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "DELETE")
            //verify header
            let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
            XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")
        }
        let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 204, httpVersion: nil, headerFields: nil)
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = deleteRequestVerifier
        iotSession = MockSession.self

        api.deleteTrigger(expectedTriggerID) { (triggerID, error) -> Void in
            if error == nil{
                XCTAssertEqual(triggerID, expectedTriggerID)
            }else {
                XCTFail("should success")
            }
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
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
        let expectation = self.expectation(description: "enableTrigger404Error")

        // perform onboarding
        api._target = setting.target

        do{
            let triggerID = "triggerID"

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "DELETE")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.deleteTrigger(triggerID, completionHandler: { (triggerID, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .errorResponse(let actualErrorResponse):
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
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testDeleteTrigger_trigger_not_available_error() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation = self.expectation(description: "testDeleteTrigger_trigger_not_available_error")

        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.deleteTrigger(triggerID, completionHandler: { (triggerID, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .targetNotAvailable:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE error")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
