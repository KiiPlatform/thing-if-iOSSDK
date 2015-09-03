//
//  PostNewCommandTests.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/20/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import IoTCloudSDK

class PostNewCommandTests: XCTestCase {

    var owner: Owner!
    var schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)
    let baseURLString = "https://small-tests.internal.kii.com"
    var api: IoTCloudAPI!
    let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()

        owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

        api = IoTCloudAPIBuilder(appID: "dummyID", appKey: "dummyKey",
            baseURL: self.baseURLString, owner: owner).build()

    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct TestCase {
        let target: Target
        let schema: String
        let schemaVersion: Int
        let actions: [Dictionary<String, AnyObject>]
        let issuerID: TypedID
    }

    func testPostCommandSuccess() {
        // perform onboarding
        api._target = target

        let testCases = [
            TestCase(target: target, schema: schema.name, schemaVersion: schema.version, actions: [["turnPower":["power": true]]], issuerID: owner.ownerID),
            TestCase(target: target, schema: schema.name, schemaVersion: schema.version, actions: [["setBrightness":["brightness": 100]]], issuerID: owner.ownerID),
            TestCase(target: target, schema: schema.name, schemaVersion: schema.version, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]], issuerID: owner.ownerID)
        ]

        for (index, testcase) in testCases.enumerate() {
            postCommandSuccess("testPostCommandSuccess_\(index)", testcase: testcase)
        }
    }

    func postCommandSuccess(tag: String, testcase: TestCase) {

        let expectation = self.expectationWithDescription(tag)


        do {
            let expectedCommandID = "c6f1b8d0-46ea-11e5-a5eb-06d9d1527620"

            // mock response
            let dict = ["commandID": expectedCommandID]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in

                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(self.api.baseURL!)/iot-api/apps/\(self.api.appID!)/targets/\(testcase.target.targetType.toString())/commands"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal for \(tag)")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                }

                //verify body
                let expectedBody = ["schema": testcase.schema, "schemaVersion": testcase.schemaVersion, "issuer": testcase.issuerID.toString(), "actions": testcase.actions]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
                }catch(_){
                    XCTFail(tag)
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.postNewCommand(testcase.schema, schemaVersion: testcase.schemaVersion, actions: testcase.actions, completionHandler: { (command, error) -> Void in
                if error == nil{
                    XCTAssertNotNil(command, tag)
                    XCTAssertEqual(command!.commandID, expectedCommandID, tag)
                    XCTAssertEqual(command!.targetID.toString(), testcase.target.targetType.toString(), tag)
                    XCTAssertEqual(command!.actions, testcase.actions, tag)
                }else {
                    XCTFail("should success for \(tag)")
                }
                expectation.fulfill()
            })
        }catch(_){
            XCTFail("should not throw error")
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewCommand_400_error() {

        let expectation = self.expectationWithDescription("testPostNewCommand_400_error")

        // perform onboarding
        api._target = target

        do{
            // mock response
            let responsedDict = ["errorCode" : "WRONG_COMMAND",
                "message" : "Schema is required"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 400, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")

                // verify path
                let expectedPath = "\(self.api.baseURL!)/iot-api/apps/\(self.api.appID!)/targets/\(self.target.targetType.toString())/commands"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }

                //verify body
                let expectedBody = ["schema": "", "schemaVersion": self.schema.version, "issuer": self.owner.ownerID.toString(), "actions": []]
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

            api.postNewCommand("", schemaVersion: self.schema.version, actions: [], completionHandler: { (command, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testPostNewCommand_target_not_available_error() {

        let expectation = self.expectationWithDescription("testPostNewCommand_target_not_available_error")

        api.postNewCommand("", schemaVersion: self.schema.version, actions: [], completionHandler: { (command, error) -> Void in
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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}