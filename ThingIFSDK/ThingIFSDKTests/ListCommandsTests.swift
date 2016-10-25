//
//  ListCommandsTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/20/15.
//  Copyright © 2015 Kii. All rights reserved.
//
import XCTest
@testable import ThingIFSDK

class ListCommandsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    struct CommandStruct {
        let target: Target
        let commandID: String
        let schema: String
        let schemaVersion: Int
        let actions: [Dictionary<String, AnyObject>]
        let actionResults: [Dictionary<String, AnyObject>]?
        let commandState: CommandState
        let commandStateString: String
        let issuerID: TypedID

        func getCommandDict() -> [String: AnyObject] {
            var dict: [String: AnyObject] = ["commandID": commandID as AnyObject, "schema": schema as AnyObject, "schemaVersion": schemaVersion as AnyObject, "target": "\(target.typedID.type):\(target.typedID.id)", "commandState": commandStateString, "issuer": "\(issuerID.type):\(issuerID.id)", "actions": actions]
            if actionResults != nil {
                dict["actionResults"] = actionResults! as AnyObject?
            }
            return dict
        }
    }
    struct TestCase {
        let paginationKey: String? // for request as parameter
        let commands: [CommandStruct]
        let target: Target
        let bestEffortLimit: Int?
        let nextPaginationKey: String? // for response

        init(commands: [CommandStruct], target: Target, nextPaginationKey: String?,  paginationKey: String?, bestEffortLimit: Int?) {
            self.commands = commands
            self.target = target
            self.paginationKey = paginationKey
            self.bestEffortLimit = bestEffortLimit
            self.nextPaginationKey = nextPaginationKey
        }
    }

    func testListCommandsSuccess() {
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let schema = setting.schema
        let schemaVersion = setting.schemaVersion
        let owner = setting.owner

        let commandIDPrifex = "0267251d9d60-1858-5e11-3dc3-00f3f0b"

        // perform onboarding
        api._target = target

        let testcases = [
            // test cases request without best effort and paginationKey
            TestCase(commands: [], target: target, nextPaginationKey: nil, paginationKey: nil, bestEffortLimit: nil),
            TestCase(commands: [CommandStruct(target: target, commandID: "\(commandIDPrifex)1", schema: schema, schemaVersion: schemaVersion, actions: [["turnPower":["power": true]]], actionResults: nil, commandState: CommandState.sending, commandStateString: "SENDING", issuerID: owner.typedID)],target: target, nextPaginationKey: nil, paginationKey: nil, bestEffortLimit: nil),
            TestCase(commands:
                    [CommandStruct(target: target, commandID: "\(commandIDPrifex)2", schema: schema, schemaVersion: schemaVersion, actions: [["turnPower":["power": true]], ["setBrightness": ["brightness": 100]]], actionResults: nil, commandState: CommandState.sending, commandStateString: "SENDING", issuerID: owner.typedID),
                    CommandStruct(target: target, commandID: "\(commandIDPrifex)3", schema: schema, schemaVersion: schemaVersion, actions: [["turnPower":["power": true]], ["setBrightness": ["brightness": 100]]], actionResults: [["turnPower":["power": true]], ["setBrightness": ["brightness": 100]]], commandState: CommandState.incomplete, commandStateString: "INCOMPLETE", issuerID: owner.typedID)
                ],target: target, nextPaginationKey: "200/2", paginationKey: nil, bestEffortLimit: nil),
            // test cases request with besteffor and paginationKey
            TestCase(commands: [CommandStruct(target: target, commandID: "\(commandIDPrifex)1", schema: schema, schemaVersion: schemaVersion, actions: [["turnPower":["power": true]]], actionResults: nil, commandState: CommandState.sending, commandStateString: "SENDING", issuerID: owner.typedID)],target: target, nextPaginationKey: nil, paginationKey: "200/2", bestEffortLimit: nil),
            TestCase(commands: [CommandStruct(target: target, commandID: "\(commandIDPrifex)1", schema: schema, schemaVersion: schemaVersion, actions: [["turnPower":["power": true]]], actionResults: nil, commandState: CommandState.sending, commandStateString: "SENDING", issuerID: owner.typedID)],target: target, nextPaginationKey: nil, paginationKey: nil, bestEffortLimit: 2),
            TestCase(commands: [CommandStruct(target: target, commandID: "\(commandIDPrifex)1", schema: schema, schemaVersion: schemaVersion, actions: [["turnPower":["power": true]]], actionResults: nil, commandState: CommandState.sending, commandStateString: "SENDING", issuerID: owner.typedID)],target: target, nextPaginationKey: nil, paginationKey: "200/2", bestEffortLimit: 2),


        ]

        for (index, testcase) in testcases.enumerated() {
            listCommandsSuccess("testListCommandsSuccess_\(index)", testcase: testcase)
        }
    }

    func listCommandsSuccess(_ tag: String, testcase: TestCase) {

        let expectation : XCTestExpectation! = self.expectation(description: tag)
        
        let setting = TestSetting()
        let api = setting.api
        let owner = setting.owner

        do{
            // mock response
            var bodyDict = [String: AnyObject]()
            if let nextPaginationKey = testcase.nextPaginationKey {
                bodyDict["nextPaginationKey"] = nextPaginationKey as AnyObject?
            }
            var commandDicts = [Dictionary<String, AnyObject>]()
            for commandStruct in testcase.commands {
                commandDicts.append(commandStruct.getCommandDict())
            }
            bodyDict["commands"] = commandDicts as AnyObject?

            let jsonData = try JSONSerialization.data(withJSONObject: bodyDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")

                // verify path
                let expectedBasePath = "\(setting.app.baseURL)/thing-if/apps/\(setting.api.appID!)/targets/\(setting.target.typedID.toString())/commands"
                let actualRequestPathString = request.url!.absoluteString
                XCTAssertTrue(actualRequestPathString!.range(of: expectedBasePath) != nil, tag)
                if testcase.paginationKey != nil || testcase.bestEffortLimit != nil {
                    let expectedURL = setting.app.baseURL + "/thing-if/apps/50a62843/targets/\(setting.target.typedID.toString())/commands"
                    var queryParams = ""
                    if testcase.paginationKey != nil {
                        queryParams = "?paginationKey=" + testcase.paginationKey!
                    }
                    if testcase.bestEffortLimit != nil {
                        if queryParams.isEmpty {
                            queryParams = "?"
                        } else {
                            queryParams += "&"
                        }
                        queryParams += "bestEffortLimit=" + String(testcase.bestEffortLimit!)
                    }
                    XCTAssertEqual(request.url?.absoluteString, expectedURL + queryParams)
                }
                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api._target = setting.target
            api.listCommands(testcase.bestEffortLimit, paginationKey: testcase.paginationKey, completionHandler: { (commands, nextPaginationKey, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertEqual(commands!.count, testcase.commands.count, tag)
                    if let expectedNextPaginationKey = testcase.nextPaginationKey {
                        XCTAssertEqual(expectedNextPaginationKey, nextPaginationKey, tag)
                    }
                    if let actualCommands = commands {
                        for (i, actualCommand) in actualCommands.enumerated() {
                            let expectedCommandStruct = testcase.commands[i]
                            XCTAssertEqual(actualCommand.targetID.toString(), testcase.target.typedID.toString(), "\(tag)_\(i)")
                            XCTAssertEqual(actualCommand.commandID, expectedCommandStruct.commandID,"\(tag)_\(i)")
                            XCTAssertEqual(actualCommand.commandState, expectedCommandStruct.commandState, "\(tag)_\(i)")
                            do {
                                let expectedActionsData = try JSONSerialization.data(withJSONObject: expectedCommandStruct.actions, options: JSONSerialization.WritingOptions(rawValue: 0))
                                let actualActionsData = try JSONSerialization.data(withJSONObject: actualCommand.actions, options: JSONSerialization.WritingOptions(rawValue: 0))
                                XCTAssertTrue(expectedActionsData == actualActionsData)

                                if let expectedActionResults = expectedCommandStruct.actionResults {
                                    let expectedActionResultsData = try JSONSerialization.data(withJSONObject: expectedActionResults, options: JSONSerialization.WritingOptions(rawValue: 0))
                                    let actualActionResultsData = try JSONSerialization.data(withJSONObject: actualCommand.actionResults, options: JSONSerialization.WritingOptions(rawValue: 0))
                                    XCTAssertTrue(expectedActionResultsData == actualActionResultsData, tag)
                                }else{
                                    XCTAssertEqual(actualCommand.actionResults.count, 0, tag)
                                }
                            }catch(_){
                                XCTFail()
                            }
                        }
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

    func testListCommand_404_error() {
        let expectation = self.expectation(description: "getCommand404Error")
        let setting = TestSetting()
        let api = setting.api
        let target = setting.target
        let owner = setting.owner

        // perform onboarding
        api._target = target

        do{
            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                // verify path
                let expectedPath = "\(api.baseURL!)/thing-if/apps/\(api.appID!)/targets/\(setting.target.typedID.type):\(setting.target.typedID.id)/commands"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            api.listCommands(nil, paginationKey: nil, completionHandler: { (commands, paginationKey, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
                    XCTAssertEqual(commands!.count, 0)
                    XCTAssertNil(paginationKey)
                    switch error! {
                    case .connection:
                        XCTFail("should not be connection error")
                    case .error_RESPONSE(let actualErrorResponse):
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
    
    func testListCommand_target_not_available_error() {
        let expectation = self.expectation(description: "testListCommand_target_not_available_error")
        let setting = TestSetting()
        let api = setting.api

        api.listCommands(nil, paginationKey: nil, completionHandler: { (commands, paginationKey, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                XCTAssertNil(commands)
                XCTAssertNil(paginationKey)
                switch error! {
                case .target_NOT_AVAILABLE:
                    break
                default:
                    XCTFail("error should be TARGET_NOT_AVAILABLE")
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
