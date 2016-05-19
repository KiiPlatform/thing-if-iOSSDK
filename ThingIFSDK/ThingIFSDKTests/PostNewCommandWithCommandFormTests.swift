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
        let actions: [Dictionary<String, AnyObject>]
        let title: String?
        let commandDescription: String?
        let metadata: Dictionary<String, AnyObject>?
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

        for (index, testcase) in testCases.enumerate() {
            postCommandWithCommandFormSuccess(
                "testPostCommandWithCommandFormSuccess\(index)",
                testcase: testcase, setting: setting)
        }
    }

    func postCommandWithCommandFormSuccess(
            tag: String,
            testcase: TestCase,
            setting:TestSetting) {
        let expectation : XCTestExpectation! = self.expectationWithDescription(tag)

        do {
            let expectedCommandID = "c6f1b8d0-46ea-11e5-a5eb-06d9d1527620"

            // mock response
            let dict = ["commandID": expectedCommandID]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in

                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(testcase.target.typedID.toString())/commands"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal for \(tag)")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                }

                //verify body
                var expectedBody: Dictionary<String, AnyObject> = [
                        "schema": testcase.schemaName,
                        "schemaVersion": testcase.schemaVersion,
                        "issuer": testcase.issuerID.toString(),
                        "actions": testcase.actions];
                expectedBody["title"] = testcase.title
                expectedBody["description"] = testcase.commandDescription
                expectedBody["metadata"] = testcase.metadata;
                self.verifyDict(expectedBody, actualData: request.HTTPBody!)
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
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
                    XCTAssertEqual(command!.actions, testcase.actions, tag)
                }else {
                    XCTFail("should success for \(tag)")
                }
                expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewCommand_400_error() {

        let expectation = self.expectationWithDescription("testPostNewCommand_400_error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target

        // perform onboarding
        api._target = target

        do{
            // mock response
            let responsedDict = ["errorCode" : "WRONG_COMMAND",
                "message" : "Schema is required"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 400, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(target.typedID.toString())/commands"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify body
                let expectedBody = ["schema": "", "schemaVersion": setting.schemaVersion, "issuer": setting.owner.typedID.toString(), "actions": []]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length)
                }catch(_){
                    XCTFail()
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
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
                    case .CONNECTION:
                        XCTFail("should not be connection error")
                    case .ERROR_RESPONSE(let actualErrorResponse):
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
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testPostNewCommand_target_not_available_error() {

        let expectation = self.expectationWithDescription("testPostNewCommand_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.postNewCommand(CommandForm(schemaName: "", schemaVersion: setting.schemaVersion, actions: []), completionHandler: { (command, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .TARGET_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("should be TARGET_NOT_AVAILABLE")
                }
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
