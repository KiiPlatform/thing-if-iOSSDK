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
        let actions: [Dictionary<String, AnyObject>]
        let issuerIDString: String
        let targetIDString: String
        let actionResults: [Dictionary<String, AnyObject>]?
        let commandState: CommandState
        let commandStateString: String
        let firedByTriggerID: String?
        let created: NSDate?
        let modified: NSDate?
    }

    func testGetCommandSuccess() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        // perform onboarding
        api._target = setting.target

        let testcases = [
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower":["power": true]]], issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.getTypedID().type):\(setting.target.getTypedID().id)", actionResults: [["turnPower":["power": true]]], commandState: CommandState.INCOMPLETE, commandStateString: "INCOMPLETE", firedByTriggerID:"trigger-0001", created:NSDate(timeIntervalSince1970:1456377631.467), modified:NSDate(timeIntervalSince1970:1456377633.467)),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["setBrightness":["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.getTypedID().type):\(setting.target.getTypedID().id)", actionResults:nil, commandState: CommandState.SENDING, commandStateString: "SENDING", firedByTriggerID:"trigger-0002", created:NSDate(timeIntervalSince1970:1456377634.467), modified:NSDate(timeIntervalSince1970:1456377635.467)),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.getTypedID().type):\(setting.target.getTypedID().id)", actionResults:nil, commandState: CommandState.SENDING, commandStateString: "SENDING",firedByTriggerID:nil, created:nil, modified:nil),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.getTypedID().type):\(setting.target.getTypedID().id)", actionResults:nil, commandState: CommandState.DELIVERED, commandStateString: "DELIVERED",firedByTriggerID:nil, created:nil, modified:nil),
            TestCase(target: setting.target, schema: setting.schema, schemaVersion: setting.schemaVersion, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(setting.owner.typedID.type):\(setting.owner.typedID.id)", targetIDString: "\(setting.target.getTypedID().type):\(setting.target.getTypedID().id)", actionResults:[["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]], commandState: CommandState.DONE, commandStateString: "DONE", firedByTriggerID:nil, created:nil, modified:nil)

        ]

        for (index, testcase) in testcases.enumerate() {
            getCommandSuccess("testGetCommandSuccess_\(index)", testcase: testcase, setting: setting)
        }
    }

    func getCommandSuccess(tag: String, testcase: TestCase, setting: TestSetting) {

        weak var expectation : XCTestExpectation! = self.expectationWithDescription(tag)
        defer{
            expectation = nil
        }

        do{

            let commandID = "429251a0-46f7-11e5-a5eb-06d9d1527620"
            // mock response
            var dict: [String: AnyObject] = ["commandID": commandID, "schema": testcase.schema, "schemaVersion": testcase.schemaVersion, "target": testcase.targetIDString, "issuer": testcase.issuerIDString, "actions": testcase.actions, "commandState": testcase.commandStateString]
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
                dict["actionResults"] = testcase.actionResults!
            }

            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")

                // verify path
                let expectedPath = "\(setting.api.baseURL!)/thing-if/apps/\(setting.api.appID!)/targets/\(testcase.targetIDString)/commands/\(commandID)"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal for \(tag)")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.getTypedID().toString())/commands/\(commandID)")

            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
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
                        let expectedActionsData = try NSJSONSerialization.dataWithJSONObject(testcase.actions, options: NSJSONWritingOptions(rawValue: 0))
                        let actualActionsData = try NSJSONSerialization.dataWithJSONObject(command!.actions, options: NSJSONWritingOptions(rawValue: 0))
                        XCTAssertTrue(expectedActionsData == actualActionsData, tag)

                        if testcase.actionResults != nil {
                            let expectedActionResultsData = try NSJSONSerialization.dataWithJSONObject(testcase.actionResults!, options: NSJSONWritingOptions(rawValue: 0))
                            let actualActionResultsData = try NSJSONSerialization.dataWithJSONObject(command!.actionResults, options: NSJSONWritingOptions(rawValue: 0))
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
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetCommand_404_error() {
        let expectation = self.expectationWithDescription("getCommand404Error")
        let setting = TestSetting()
        let api = setting.api
        do{
            let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // perform onboarding
            api._target = setting.target

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.getTypedID().toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                // verify path
                let expectedPath = "\(api.baseURL!)/thing-if/apps/\(api.appID!)/targets/\(setting.target.getTypedID().type):\(setting.target.getTypedID().id)/commands/\(commandID)"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.getTypedID().toString())/commands/\(commandID)")
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.getCommand(commandID, completionHandler: { (command, error) -> Void in
                 if error == nil{
                    XCTFail("should fail")
                }else {
                    XCTAssertNil(command)
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
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetCommand_trigger_not_available_error() {
        let expectation = self.expectationWithDescription("testGetCommand_trigger_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

        api.getCommand(commandID, completionHandler: { (trigger, error) -> Void in
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

        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
