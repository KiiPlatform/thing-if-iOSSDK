//
//  getCommandTest.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/20/15.
//  Copyright © 2015 Kii. All rights reserved.
//
import XCTest
@testable import ThingIFSDK

class GetCommandTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let target: Target
        let schema: String
        let schemaVersion: Int
        let actions: [Dictionary<String, Any>]
        let issuerIDString: String
        let targetIDString: String
        let actionResults: [Dictionary<String, Any>]?
        let commandState: CommandState
        let commandStateString: String
        let firedByTriggerID: String?
        let created: Date?
        let modified: Date?
    }

    func testGetCommandSuccess() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        // perform onboarding
        api._target = setting.target

        let testcases = [
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower":["power": true]]], issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.typedID.type):\(setting.target.typedID.id)", actionResults: [["turnPower":["power": true]]], commandState: CommandState.incomplete, commandStateString: "INCOMPLETE", firedByTriggerID:"trigger-0001", created:Date(timeIntervalSince1970:1456377631.467), modified:Date(timeIntervalSince1970:1456377633.467)),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["setBrightness":["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.typedID.type):\(setting.target.typedID.id)", actionResults:nil, commandState: CommandState.sending, commandStateString: "SENDING", firedByTriggerID:"trigger-0002", created:Date(timeIntervalSince1970:1456377634.467), modified:Date(timeIntervalSince1970:1456377635.467)),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.typedID.type):\(setting.target.typedID.id)", actionResults:nil, commandState: CommandState.sending, commandStateString: "SENDING",firedByTriggerID:nil, created:nil, modified:nil),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.typedID.type):\(setting.target.typedID.id)", actionResults:nil, commandState: CommandState.delivered, commandStateString: "DELIVERED",firedByTriggerID:nil, created:nil, modified:nil),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.typedID.type):\(setting.target.typedID.id)", actionResults:[["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]], commandState: CommandState.done, commandStateString: "DONE", firedByTriggerID:nil, created:nil, modified:nil)

        ]

        for (index, testcase) in testcases.enumerated() {
            getCommandSuccess("testGetCommandSuccess_\(index)", testcase: testcase, setting: setting)
        }
    }

    func getCommandSuccess(_ tag: String, testcase: TestCase, setting: TestSetting) {

        let expectation : XCTestExpectation! = self.expectation(description: tag)

        do{

            let commandID = "429251a0-46f7-11e5-a5eb-06d9d1527620"
            // mock response
            var dict: [String: Any] = ["commandID": commandID, "schema": testcase.schema, "schemaVersion": testcase.schemaVersion, "target": testcase.targetIDString, "issuer": testcase.issuerIDString, "actions": testcase.actions, "commandState": testcase.commandStateString]
            if let firedByTriggerID = testcase.firedByTriggerID {
                dict["firedByTriggerID"] = firedByTriggerID
            }
            if let created = testcase.created {
                dict["createdAt"] = created.timeIntervalSince1970 * 1000
            }
            if let modified = testcase.modified {
                dict["modifiedAt"] = modified.timeIntervalSince1970 * 1000
            }
            if testcase.actionResults != nil {
                dict["actionResults"] = testcase.actionResults
            }

            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")

                // verify path
                let expectedPath = "\(setting.api.baseURL)/thing-if/apps/\(setting.api.appID)/targets/\(testcase.targetIDString)/commands/\(commandID)"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal for \(tag)")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/commands/\(commandID)")

            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            setting.api.getCommand(commandID, completionHandler: { (command, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertNotNil(command, tag)
                    XCTAssertEqual(command!.commandID, commandID, tag)
                    XCTAssertEqual(command!.targetID.toString(), testcase.targetIDString, tag)
                    XCTAssertEqual(command!.commandState, testcase.commandState, tag)
                    
                    XCTAssertEqual(command?.firedByTriggerID, testcase.firedByTriggerID, tag)
                    XCTAssertEqual(command?.created, testcase.created, tag)
                    XCTAssertEqual(command?.modified, testcase.modified, tag)
                    do {
                        let expectedActionsData = try JSONSerialization.data(withJSONObject: testcase.actions, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let actualActionsData = try JSONSerialization.data(withJSONObject: command!.actions, options: JSONSerialization.WritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedActionsData == actualActionsData, tag)

                        if testcase.actionResults != nil {
                            let expectedActionResultsData = try JSONSerialization.data(withJSONObject: testcase.actionResults!, options: JSONSerialization.WritingOptions(rawValue: 0))
                            let actualActionResultsData = try JSONSerialization.data(withJSONObject: command!.actionResults, options: JSONSerialization.WritingOptions(rawValue: 0))
                            XCTAssertTrue(expectedActionResultsData == actualActionResultsData, tag)
                        }else{
                            XCTAssertEqual(command!.actionResults.count, 0, tag)
                        }
                    }catch(_){
                        XCTFail()
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

    func testGetCommand_404_error() {
        let expectation = self.expectation(description: "getCommand404Error")
        let setting = TestSetting()
        let api = setting.api
        do{
            let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // perform onboarding
            api._target = setting.target

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                // verify path
                let expectedPath = "\(api.baseURL)/thing-if/apps/\(api.appID)/targets/\(setting.target.typedID.type):\(setting.target.typedID.id)/commands/\(commandID)"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/commands/\(commandID)")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.getCommand(commandID, completionHandler: { (command, error) -> Void in
                 if error == nil{
                    XCTFail("should fail")
                }else {
                    XCTAssertNil(command)
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

    func testGetCommand_trigger_not_available_error() {
        let expectation = self.expectation(description: "testGetCommand_trigger_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.getCommand(commandID, completionHandler: { (trigger, error) -> Void in
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
