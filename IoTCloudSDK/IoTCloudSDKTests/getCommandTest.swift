//
//  getCommandTest.swift
//  IoTCloudSDK
//
//  Created by Yongping on 8/20/15.
//  Copyright © 2015 Kii. All rights reserved.
//
import XCTest
@testable import IoTCloudSDK

class GetCommandTests: XCTestCase {

    let owner = Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")

    let schema = (thingType: "SmartLight-Demo",
        name: "SmartLight-Demo", version: 1)

    let baseURLString = "https://small-tests.internal.kii.com"

    var api: IoTCloudAPI!

    let target = Target(targetType: TypedID(type: "thing", id: "th.0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()
        api = IoTCloudAPIBuilder(appID: "50a62843", appKey: "2bde7d4e3eed1ad62c306dd2144bb2b0",
            baseURL: "https://small-tests.internal.kii.com", owner: Owner(ownerID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")).build()
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
        let issuerIDString: String
        let targetIDString: String
        let actionResults: [Dictionary<String, AnyObject>]?
        let commandState: CommandState
        let commandStateString: String
    }

    func testGetCommandSuccess() {

        // perform onboarding
        api._target = target

        let testcases = [
            TestCase(target: self.target, schema: self.schema.name, schemaVersion: self.schema.version, actions: [["turnPower":["power": true]]], issuerIDString: "\(self.owner.ownerID.type):\(self.owner.ownerID.id)", targetIDString: "\(self.target.targetType.type):\(self.target.targetType.id)", actionResults: [["turnPower":["power": true]]], commandState: CommandState.INCOMPLETE, commandStateString: "INCOMPLETE"),
            TestCase(target: self.target, schema: self.schema.name, schemaVersion: self.schema.version, actions: [["setBrightness":["brightness": 100]]],  issuerIDString: "\(self.owner.ownerID.type):\(self.owner.ownerID.id)", targetIDString: "\(self.target.targetType.type):\(self.target.targetType.id)", actionResults:nil, commandState: CommandState.SENDING, commandStateString: "SENDING"),
            TestCase(target: self.target, schema: self.schema.name, schemaVersion: self.schema.version, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(self.owner.ownerID.type):\(self.owner.ownerID.id)", targetIDString: "\(self.target.targetType.type):\(self.target.targetType.id)", actionResults:nil, commandState: CommandState.SENDING, commandStateString: "SENDING"),
            TestCase(target: self.target, schema: self.schema.name, schemaVersion: self.schema.version, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(self.owner.ownerID.type):\(self.owner.ownerID.id)", targetIDString: "\(self.target.targetType.type):\(self.target.targetType.id)", actionResults:nil, commandState: CommandState.DELIVERED, commandStateString: "DELIVERED"),
            TestCase(target: self.target, schema: self.schema.name, schemaVersion: self.schema.version, actions: [["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]],  issuerIDString: "\(self.owner.ownerID.type):\(self.owner.ownerID.id)", targetIDString: "\(self.target.targetType.type):\(self.target.targetType.id)", actionResults:[["turnPower": ["power": true]], ["setBrightness": ["brightness": 100]]], commandState: CommandState.DONE, commandStateString: "DONE")

        ]

        for (index, testcase) in testcases.enumerate() {
            getCommandSuccess("testGetCommandSuccess_\(index)", testcase: testcase)
        }
    }

    func getCommandSuccess(tag: String, testcase: TestCase) {

        let expectation = self.expectationWithDescription(tag)

        do{

            let commandID = "429251a0-46f7-11e5-a5eb-06d9d1527620"
            // mock response
            var dict: [String: AnyObject] = ["commandID": commandID, "schema": testcase.schema, "schemaVersion": testcase.schemaVersion, "target": testcase.targetIDString, "issuer": testcase.issuerIDString, "actions": testcase.actions, "commandState": testcase.commandStateString]
            if testcase.actionResults != nil {
                dict["actionResults"] = testcase.actionResults!
            }

            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:self.baseURLString)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")

                // verify path
                let expectedPath = "\(self.api.baseURL!)/iot-api/apps/\(self.api.appID!)/targets/\(testcase.targetIDString)/commands/\(commandID)"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal for \(tag)")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.getCommand(commandID, completionHandler: { (command, error) -> Void in
                if(error != nil) {
                    XCTFail("should success")
                }else {
                    XCTAssertNotNil(command, tag)
                    XCTAssertEqual(command!.commandID, commandID, tag)
                    XCTAssertEqual(command!.targetID.toString(), testcase.targetIDString, tag)
                    XCTAssertEqual(command!.commandState, testcase.commandState, tag)
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetCommand_404_error() {
        let expectation = self.expectationWithDescription("getCommand404Error")
        do{
            let commandID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"

            // perform onboarding
            api._target = target

            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.targetType.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)

            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                // verify path
                let expectedPath = "\(self.api.baseURL!)/iot-api/apps/\(self.api.appID!)/targets/\(self.target.targetType.type):\(self.target.targetType.id)/commands/\(commandID)"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")

                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testGetCommand_trigger_not_available_error() {
        let expectation = self.expectationWithDescription("testGetCommand_trigger_not_available_error")

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

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
