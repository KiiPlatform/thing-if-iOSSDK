//
//  PostNewCommandWithCommandFormTests.swift
//  ThingIFSDK
//
//  Created on 2016/04/11.
//  Copyright 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewCommandWithCommandFormTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let target: Target
        let schemaName: String
        let schemaVersion: Int
        let actions: [Dictionary<String, Any>]
        let title: String?
        let commandDescription: String?
        let metadata: Dictionary<String, Any>?
        let issuerID: TypedID
    }

    func testPostCommandWithCommandFormSuccess() {
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion
        let owner = setting.owner

        // perform onboarding
        api._target = target

        let testCases = [
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: nil,
                     commandDescription: nil,
                     metadata: nil,
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["setBrightness":[
                                 "brightness": 100]]],
                     title: nil,
                     commandDescription: nil,
                     metadata: nil,
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower": ["power": true]],
                         ["setBrightness": ["brightness": 100]]],
                     title: nil,
                     commandDescription: nil,
                     metadata: nil,
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: "title",
                     commandDescription: nil,
                     metadata: nil,
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: nil,
                     commandDescription: "command description",
                     metadata: nil,
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: nil,
                     commandDescription: nil,
                     metadata: ["key": "value"],
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: "title",
                     commandDescription: "command description",
                     metadata: nil,
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: "title",
                     commandDescription: nil,
                     metadata: ["key": "value"],
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: nil,
                     commandDescription: "command description",
                     metadata: ["key": "value"],
                     issuerID: owner.typedID),
            TestCase(target: target,
                     schemaName: schema,
                     schemaVersion: schemaVersion,
                     actions: [["turnPower":["power": true]]],
                     title: "title",
                     commandDescription: "command description",
                     metadata: ["key": "value"],
                     issuerID: owner.typedID)
        ]

        for (index, testcase) in testCases.enumerated() {
            postCommandWithCommandFormSuccess(
                "testPostCommandWithCommandFormSuccess\(index)",
                testcase: testcase, setting: setting)
        }
    }

    func postCommandWithCommandFormSuccess(
            _ tag: String,
            testcase: TestCase,
            setting:TestSetting) {
        let expectation : XCTestExpectation! = self.expectation(description: tag)

        do {
            let expectedCommandID = "c6f1b8d0-46ea-11e5-a5eb-06d9d1527620"

            // mock response
            let dict = ["commandID": expectedCommandID]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in

                XCTAssertEqual(request.httpMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(testcase.target.typedID.toString())/commands"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal for \(tag)")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key), tag)
                }

                //verify body
                var expectedBody: Dictionary<String, Any> = [
                        "schema": testcase.schemaName,
                        "schemaVersion": testcase.schemaVersion,
                        "issuer": testcase.issuerID.toString(),
                        "actions": testcase.actions];
                expectedBody["title"] = testcase.title
                expectedBody["description"] = testcase.commandDescription
                expectedBody["metadata"] = testcase.metadata;
                self.verifyDict(expectedBody, actualData: request.httpBody!)
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.postNewCommand(
                    CommandForm(schemaName: testcase.schemaName,
                                schemaVersion: testcase.schemaVersion,
                                actions: testcase.actions,
                                title: testcase.title,
                                commandDescription: testcase.commandDescription,
                                metadata: testcase.metadata),
                    completionHandler: { (command, error) -> Void in
                if error == nil{
                    XCTAssertNotNil(command, tag)
                    XCTAssertEqual(command!.commandID, expectedCommandID, tag)
                    XCTAssertEqual(command!.targetID.toString(), testcase.target.typedID.toString(), tag)
                    self.verifyArray(command!.actions, actual: testcase.actions, message: tag)
                }else {
                    XCTFail("should success for \(tag)")
                }
                expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewCommand_400_error() {

        let expectation = self.expectation(description: "testPostNewCommand_400_error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api._target = target

        do{
            // mock response
            let responsedDict = ["errorCode" : "WRONG_COMMAND",
                "message" : "Schema is required"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 400, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(target.typedID.toString())/commands"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }

                //verify body
                let expectedBody: [String : Any] = ["schema": "", "schemaVersion": setting.schemaVersion, "issuer": setting.owner.typedID.toString(), "actions": []]
                do {
                    let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count)
                }catch(_){
                    XCTFail()
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewCommand(CommandForm(
                                   schemaName: "",
                                   schemaVersion: setting.schemaVersion,
                                   actions: []),
                               completionHandler: { (command, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                } else {
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .errorResponse(let actualErrorResponse):
                        XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
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

    func testPostNewCommand_target_not_available_error() {

        let expectation = self.expectation(description: "testPostNewCommand_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.postNewCommand(CommandForm(schemaName: "", schemaVersion: setting.schemaVersion, actions: []), completionHandler: { (command, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .targetNotAvailable:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE")
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
