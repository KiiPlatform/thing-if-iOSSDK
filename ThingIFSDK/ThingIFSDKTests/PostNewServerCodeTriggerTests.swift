import XCTest
@testable import ThingIFSDK

class PostNewServerCodeTriggerTests: XCTestCase {

    var owner: Owner!
    let baseURLString = "https://small-tests.internal.kii.com"
    var api: ThingIFAPI!
    let target = Target(typedID: TypedID(type: "thing", id: "0267251d9d60-1858-5e11-3dc3-00f3f0b5"))

    override func setUp() {
        super.setUp()
        
        owner = Owner(typedID: TypedID(type:"user", id:"53ae324be5a0-2b09-5e11-6cc3-0862359e"), accessToken: "BbBFQMkOlEI9G1RZrb2Elmsu5ux1h-TIm5CGgh9UBMc")
        
        api = ThingIFAPIBuilder(appID: "dummyID", appKey: "dummyKey",
            site: Site.CUSTOM(self.baseURLString), owner: owner).build()
        
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostNewServerCodeTrigger_success() {
        let tag = "PostNewServerCodeTriggerTests.testPostNewTrigger_success"
        let expectation = self.expectationWithDescription("testPostNewServerCodeTrigger_success")
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
        let condition = Condition(clause: EqualsClause(field: "color", value: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)

        let expectedPredicateDict = predicate.toNSDictionary()
        let expectedServerCodeDict = serverCode.toNSDictionary()
        do {
            // mock response
            let dict = ["triggerID": expectedTriggerID]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 201, HTTPVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
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
                XCTAssertEqual(request.URL?.absoluteString, self.baseURLString + "/thing-if/apps/dummyID/targets/\(self.target.typedID.toString())/triggers")
            }
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api._target = target
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
                    XCTFail("should success for \(tag) " + String(error))
                }
                expectation.fulfill()
            })
        }catch(let e){
            print(e)
        }
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewServerCodeTrigger_http_404() {
        let tag = "PostNewServerCodeTriggerTests.testPostNewServerCodeTrigger_http_404"
        let expectation = self.expectationWithDescription("testPostNewServerCodeTrigger_http_404")
        let expectedEndpoint = "my_function"
        let expectedExecutorAccessToken = "abcdefgHIJKLMN1234567"
        let expectedTargetAppID = "app000001"
        var expectedParameters = Dictionary<String, AnyObject>()
        expectedParameters["arg1"] = "abcd"
        expectedParameters["arg2"] = 1234
        expectedParameters["arg3"] = 0.12345
        expectedParameters["arg4"] = false
        
        let serverCode:ServerCode = ServerCode(endpoint: expectedEndpoint, executorAccessToken: expectedExecutorAccessToken, targetAppID: expectedTargetAppID, parameters: expectedParameters)
        let condition = Condition(clause: EqualsClause(field: "color", value: 0))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)
        
        let expectedPredicateDict = predicate.toNSDictionary()
        let expectedServerCodeDict = serverCode.toNSDictionary()
        do {
            // mock response
            let responsedDict = ["errorCode" : "TARGET_NOT_FOUND",
                "message" : "Target \(target.typedID.toString()) not found"]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(responsedDict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:baseURLString)!, statusCode: 404, HTTPVersion: nil, headerFields: nil)
            
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "POST")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(self.owner.accessToken)", "Content-type":"application/json"]
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
            MockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            MockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api._target = target
            api.postNewTrigger(serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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
        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for \(tag)")
            }
        }
    }

    func testPostNewServerCodeTrigger_UnsupportError() {
        let expectation = self.expectationWithDescription("testPostNewServerCodeTrigger_UnsupportError")

        
        let serverCode:ServerCode = ServerCode(endpoint: "function_name", executorAccessToken: "abcd", targetAppID: "app001", parameters: nil)
        let predicate = SchedulePredicate(schedule: "'*/15 * * * *")
        
        api._target = target
        api.postNewTrigger(serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
            if error == nil{
                XCTFail("should fail")
            }else {
                switch error! {
                case .UNSUPPORTED_ERROR:
                    break
                default:
                    XCTFail("should be unsupport error")
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
    
    func testPostNewServerCodeTrigger_target_not_available_error() {
        let expectation = self.expectationWithDescription("testPostNewServerCodeTrigger_target_not_available_error")
        
        let serverCode:ServerCode = ServerCode(endpoint: "function_name", executorAccessToken: "abcd", targetAppID: "app001", parameters: nil)
        let predicate = StatePredicate(condition: Condition(clause: EqualsClause(field: "color", value: 0)), triggersWhen: TriggersWhen.CONDITION_FALSE_TO_TRUE)
        
        api.postNewTrigger(serverCode, predicate: predicate, completionHandler: { (trigger, error) -> Void in
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
