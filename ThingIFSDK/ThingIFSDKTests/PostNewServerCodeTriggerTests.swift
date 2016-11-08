import XCTest
@testable import ThingIFSDK

class PostNewServerCodeTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostNewServerCodeStateTrigger_success() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.conditionFalseToTrue)
        postNewServerCodeTrigger_success(predicate)

    }
    func testPostNewServerCodeScheduleOnceTrigger_success() {
        let predicate = ScheduleOncePredicate(scheduleAt: Date(timeIntervalSinceNow: 1000))
        postNewServerCodeTrigger_success(predicate)
    }

    func postNewServerCodeTrigger_success(_ predicate: Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let tag = "PostNewServerCodeTriggerTests.testPostNewTrigger_success"
        let expectation : XCTestExpectation! = self.expectation(description: "testPostNewServerCodeTrigger_success_\(predicate.getEventSource().rawValue)")
        let expectedTriggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectedEndpoint = "my_function"
        let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
        let expectedTargetAppID = "app000001"
        var expectedParameters = Dictionary<String, Any>()
        expectedParameters["arg1"] = "abcd"
        expectedParameters["arg2"] = 1234
        expectedParameters["arg3"] = 0.12345
        expectedParameters["arg4"] = false
        
        let serverCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)


        let expectedPredicateDict = predicate.toNSDictionary()
        let expectedServerCodeDict = serverCode.toNSDictionary()
        do {
            // mock response
            let dict = ["triggerID": expectedTriggerID]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key), tag)
                }
                //verify body
                
                let expectedBody: [String : Any] = ["predicate": expectedPredicateDict, "serverCode": expectedServerCodeDict, "triggersWhat":"SERVER_CODE"]
                do {
                    let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count, tag)
                }catch(_){
                    XCTFail(tag)
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers")
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api._target = setting.target
            api.postNewTrigger(serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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
                    XCTFail("should success for \(tag) " + String(describing: error))
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewServerCodeStateTrigger_http_404() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.conditionFalseToTrue)
        postNewServerCodeTrigger_success(predicate)

    }
    func testPostNewServerCodeScheduleOnceTrigger_http_404() {
        let predicate = ScheduleOncePredicate(scheduleAt: Date(timeIntervalSinceNow: 1000))
        postNewServerCodeTrigger_http_404(predicate)
    }
    
    func postNewServerCodeTrigger_http_404(_ predicate : Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let tag = "PostNewServerCodeTriggerTests.testPostNewServerCodeTrigger_http_404"
        let expectation : XCTestExpectation! = self.expectation(description: "testPostNewServerCodeTrigger_http_404_\(predicate.getEventSource().rawValue)")
        let expectedEndpoint = "my_function"
        let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
        let expectedTargetAppID = "app000001"
        var expectedParameters = Dictionary<String, Any>()
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
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)", "Content-type":"application/json"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key), tag)
                }
                //verify body
                
                let expectedBody: [String : Any] = ["predicate": expectedPredicateDict, "serverCode": expectedServerCodeDict, "triggersWhat":"SERVER_CODE"]
                do {
                    let expectedBodyData = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
                    let actualBodyData = request.httpBody
                    XCTAssertTrue(expectedBodyData.count == actualBodyData!.count, tag)
                }catch(_){
                    XCTFail(tag)
                }
            }
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api._target = setting.target
            api.postNewTrigger(serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
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
                XCTFail("execution timeout for \(tag)")
            }
        }
    }
    
    func testPostNewServerCodeTrigger_target_not_available_error() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation : XCTestExpectation! = self.expectation(description: "testPostNewServerCodeTrigger_target_not_available_error")
        
        let serverCode:ServerCode = ServerCode(endpoint: "function_name", executorAccessToken: "abcd", targetAppID: "app001", parameters: nil)
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", intValue: 0)), triggersWhen: TriggersWhen.conditionFalseToTrue)
        
        api.postNewTrigger(serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .target_NOT_AVAILABLE:
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
