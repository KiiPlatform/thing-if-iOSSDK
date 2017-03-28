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

    func testPatchServerCodeStateTrigger_http_404() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.conditionFalseToTrue)
        patchServerCodeTrigger_http_404(predicate)

    }
    func testPatchServerCodeScheduleOnceTrigger_http_404() {
        let predicate = ScheduleOncePredicate(scheduleAt: Date(timeIntervalSinceNow: 1000))
        patchServerCodeTrigger_http_404(predicate)
    }
    func patchServerCodeTrigger_http_404(_ predicate: Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let tag = "PatchServerCodeTriggerTests.testPatchServerCodeTrigger_http_404"
        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectation : XCTestExpectation! = self.expectation(description: "testPostNewServerCodeTrigger_http_404_\(predicate.eventSource.rawValue)")
        let expectedEndpoint = "my_function"
        let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
        let expectedTargetAppID = "app000001"
        var expectedParameters = Dictionary<String, Any>()
        expectedParameters["arg1"] = "abcd"
        expectedParameters["arg2"] = 1234
        expectedParameters["arg3"] = 0.12345
        expectedParameters["arg4"] = false
        
        let serverCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)

        let expectedPredicateDict = predicate.makeDictionary()
        let expectedServerCodeDict = serverCode.makeDictionary()
        do {
            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(setting.target.typedID.toString()) not found"]
            let jsonData = try JSONSerialization.data(withJSONObject: responsedDict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 404, httpVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "PATCH")
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
            
            api.target = setting.target
            api.patchTrigger(triggerID, serverCode:serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
                if error == nil{
                    XCTFail("should fail")
                }else {
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
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPatchServerCodeStateTrigger_target_not_available_error() {
        let condition = Condition(clause: EqualsClause(field: "color", intValue: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.conditionFalseToTrue)
        patchServerCodeTrigger_target_not_available_error(predicate)
    }
    func testPatchServerCodeScheduleOnceTrigger_target_not_available_error() {
        let predicate = ScheduleOncePredicate(scheduleAt: Date(timeIntervalSinceNow: 1000))
        patchServerCodeTrigger_target_not_available_error(predicate)
    }

    func patchServerCodeTrigger_target_not_available_error(_ predicate: Predicate) {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let triggerID = "0267251d9d60-1858-5e11-3dc3-00f3f0b5"
        let expectation : XCTestExpectation! = self.expectation(description: "PatchServerCodeTriggerTests.testPatchServerCodeTrigger_target_not_available_error_\(predicate.eventSource.rawValue)")
        
        let serverCode:ServerCode = ServerCode(endpoint: "function_name", executorAccessToken: "abcd", targetAppID: "app001", parameters: nil)
        
        api.patchTrigger(triggerID, serverCode:serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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

