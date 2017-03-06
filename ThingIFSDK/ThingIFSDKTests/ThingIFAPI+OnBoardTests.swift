//
//  ThingIFAPI+OnBoardTests.swift
//  ThingIFSDK
//
//  Created on 2017/03/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFSDKOnBoardTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testOnboardWithThingIDFail() {
        let expectation = self.expectation(description: "onboardWithThingID")
        let setting = TestSetting()
        let api = setting.api
        let owner = setting.owner

        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            //verify request header
            XCTAssertEqual(
              [
                "Authorization" : "Bearer \(owner.accessToken)",
                "Content-Type" : "application/vnd.kii.OnboardingWithThingIDByOwner+json",
                "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader
              ],
              request.allHTTPHeaderFields!
            )

            //verify request body
            let requestBody: [String : String]
            do {
                requestBody = try JSONSerialization.jsonObject(
                  with: request.httpBody!,
                  options: JSONSerialization.ReadingOptions.allowFragments)
                as! [String : String]
            } catch {
                XCTFail("request body must be deserializable.")
                return
            }
            XCTAssertEqual(
              [
                "thingID": "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5",
                "thingPassword": "dummyPassword",
                "owner": owner.typedID.toString()
              ],
             requestBody
            )

            XCTAssertEqual(
              request.url?.absoluteString,
              setting.app.baseURL + "/thing-if/apps/50a62843/onboardings")
        }

        let dict: [String : Any] = [
          "errorCode" : "INVALID_INPUT_DATA",
          "message" :
            "There are validation errors: password - password is required.",
          "invalidFields":["password": "password is required"]]
        do{
            sharedMockSession.mockResponse = (
              try JSONSerialization.data(
                withJSONObject: dict,
                options: .prettyPrinted),
              HTTPURLResponse(
                url:
                  URL(string: "https://api-development-jp.internal.kii.com")!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil),
              nil)
        } catch {
            XCTFail("json must be serializable")
            return
        }
        sharedMockSession.requestVerifier = requestVerifier

        iotSession = MockSession.self
        api.onboardWith(
          thingID: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5",
          thingPassword: "dummyPassword") { ( target, error) -> Void in
            if error == nil {
                XCTFail("error must not nil")
                return
            }
            switch error! {
                case .errorResponse(let actualErrorResponse):
                    XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
                    XCTAssertEqual(
                      dict["errorCode"] as! String,
                      actualErrorResponse.errorCode)
                    XCTAssertEqual(
                      dict["message"] as! String,
                      actualErrorResponse.errorMessage)
                default:
                    XCTFail("invalid error")
                    break
            }

            expectation.fulfill()
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }

        do {
            let storedAPI =
              try ThingIFAPI.loadWithStoredInstance(setting.api.tag)
            XCTAssertEqual(setting.api, storedAPI)
        } catch {
            XCTFail("fail to load API")
        }

    }

}
