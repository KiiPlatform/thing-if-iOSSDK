import XCTest
@testable import ThingIFSDK

class PatchServerCodeTriggerTests: SmallTestBase {
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPatchServerCodeStateTrigger_success() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)
        patchServerCodeTrigger_success(predicate)

    }
    func testPatchServerCodeScheduleOnceTrigger_success() {
        let predicate = ScheduleOncePredicate(scheduleAt: NSDate(timeIntervalSinceNow: 1000))
        patchServerCodeTrigger_success(predicate)
    }
    func patchServerCodeTrigger_success(predicate: Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let tag = "PatchServerCodeTriggerTests.testPatchServerCodeTrigger_success"
        let expectation : XCTestExpectation! = self.expectationWithDescription("testPostNewServerCodeTrigger_success_\(predicate.getEventSource().rawValue)")
        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedEndpoint = "my_function"
        let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
        let expectedTargetAppID = "app000001"
        var expectedParameters = Dictionary<String, AnyObject>()
        expectedParameters["arg1"] = "abcd"
        expectedParameters["arg2"] = 1234
        expectedParameters["arg3"] = 0.12345
        expectedParameters["arg4"] = false
        
        let serverCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)

        let expectedPredicateDict = predicate.toNSDictionary()
        let expectedServerCodeDict = serverCode.toNSDictionary()
        do {
            // mock response for patch
            let dict4Patch = ["triggerID": expectedTriggerID]
            let jsonData4Patch = try NSJSONSerialization.dataWithJSONObject(dict4Patch, options: .PrettyPrinted)
            let urlResponse4Patch = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            // mock response for get
            let dict4Get = ["triggerID": expectedTriggerID, "predicate": expectedPredicateDict, "serverCode": expectedServerCodeDict, "triggersWhat":"SERVER_CODE", "disabled":false]
            let jsonData4Get = try NSJSONSerialization.dataWithJSONObject(dict4Get, options: .PrettyPrinted)
            let urlResponse4Get = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
            
            // verify request for patch
            let patchRequestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "PATCH")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                }
                //verify body
                
                let expectedBody = ["predicate": expectedPredicateDict, "serverCode": expectedServerCodeDict, "triggersWhat":"SERVER_CODE"]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
                }catch(_){
                    XCTFail(tag)
                }
                XCTAssertEqual(request.URL?.absoluteString, setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers/\(expectedTriggerID)")

            }
            // verify request for get
            let getRequestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                }
            }
            iotSession = MockMultipleSession.self
            sharedMockMultipleSession.responsePairs = [
                ((data: jsonData4Patch, urlResponse: urlResponse4Patch, error: nil), patchRequestVerifier),
                ((data: jsonData4Get, urlResponse: urlResponse4Get, error: nil),getRequestVerifier)
            ]
            
            api._target = setting.target
            api.patchTrigger(expectedTriggerID, serverCode: serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTAssertEqual(trigger!.triggerID, expectedTriggerID, tag)
                    XCTAssertEqual(trigger!.enabled, true, tag)
                    self.verifyNsDict(trigger!.predicate.toNSDictionary(), actualDict: expectedPredicateDict)
                    XCTAssertEqual(trigger!.serverCode!.endpoint, expectedEndpoint, tag)
                    XCTAssertEqual(trigger!.serverCode!.executorAccessToken, expectedExecutorAccessToken, tag)
                    XCTAssertEqual(trigger!.serverCode!.targetAppID, expectedTargetAppID, tag)
                    self.verifyDict(expectedParameters, actualDict: trigger!.serverCode!.parameters!)
                    XCTAssertNil(trigger!.command)
                } else {
                    XCTFail("should success for \(tag) " + String(error))
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }
    func testPatchServerCodeStateTrigger_http_404() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)
        patchServerCodeTrigger_http_404(predicate)

    }
    func testPatchServerCodeScheduleOnceTrigger_http_404() {
        let predicate = ScheduleOncePredicate(scheduleAt: NSDate(timeIntervalSinceNow: 1000))
        patchServerCodeTrigger_http_404(predicate)
    }
    func patchServerCodeTrigger_http_404(predicate: Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let tag = "PatchServerCodeTriggerTests.testPatchServerCodeTrigger_http_404"
        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectation : XCTestExpectation! = self.expectationWithDescription("testPostNewServerCodeTrigger_http_404_\(predicate.getEventSource().rawValue)")
        let expectedEndpoint = "my_function"
        let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
        let expectedTargetAppID = "app000001"
        var expectedParameters = Dictionary<String, AnyObject>()
        expectedParameters["arg1"] = "abcd"
        expectedParameters["arg2"] = 1234
        expectedParameters["arg3"] = 0.12345
        expectedParameters["arg4"] = false
        
        let serverCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)

        let expectedPredicateDict = predicate.toNSDictionary()
        let expectedServerCodeDict = serverCode.toNSDictionary()
        do {
            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:setting.app.baseURL)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "PATCH")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key), tag)
                }
                //verify body
                
                let expectedBody = ["predicate": expectedPredicateDict, "serverCode": expectedServerCodeDict, "triggersWhat":"SERVER_CODE"]
                do {
                    let expectedBodyData = try NSJSONSerialization.dataWithJSONObject(expectedBody, options: NSJSONWritingOptions(rawValue: 0))
                    let actualBodyData = request.HTTPBody
                    XCTAssertTrue(expectedBodyData.length == actualBodyData!.length, tag)
                }catch(_){
                    XCTFail(tag)
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api._target = setting.target
            api.patchTrigger(triggerID, serverCode:serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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
        self.waitForExpectationsWithTimeout(TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPatchServerCodeStateTrigger_target_not_available_error() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)
        patchServerCodeTrigger_target_not_available_error(predicate)
    }
    func testPatchServerCodeScheduleOnceTrigger_target_not_available_error() {
        let predicate = ScheduleOncePredicate(scheduleAt: NSDate(timeIntervalSinceNow: 1000))
        patchServerCodeTrigger_target_not_available_error(predicate)
    }

    func patchServerCodeTrigger_target_not_available_error(predicate: Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectation : XCTestExpectation! = self.expectationWithDescription("PatchServerCodeTriggerTests.testPatchServerCodeTrigger_target_not_available_error_\(predicate.getEventSource().rawValue)")
        
        let serverCode:ServerCode = ServerCode(endpoint: "function_name", executorAccessToken: "abcd", targetAppID: "app001", parameters: nil)
        
        api.patchTrigger(triggerID, serverCode:serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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

