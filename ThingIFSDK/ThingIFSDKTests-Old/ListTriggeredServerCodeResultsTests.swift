import XCTest
@testable import ThingIFSDK

class ListTriggeredServerCodeResultsTests: SmallTestBase {
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testListTriggeredServerCodeResultsTests_success() {
        let setting:TestSetting = TestSetting()
        let api = setting.api
        let expectation = self.expectation(description: "testPostNewServerCodeTrigger_success")
        let triggerID = "abcdefgHIJKLMN1234567"
        
        do{
            let expectedNextPaginationKey = "1234567abcde"
            let serverCodeResultDic1: NSDictionary = ["succeeded": true, "returnedValue": "12345", "executedAt": 1454474985511, "endpoint":"func"]
            let serverCodeResultDic2: NSDictionary = ["succeeded": false, "executedAt": 1454474985511, "endpoint":"func", "errorMessage": "RuntimeError"]
            let serverCodeResultDic3: NSDictionary = ["succeeded": false, "executedAt": 1454474985511, "endpoint":"func", "errorMessage": "ReferenceError"]
            let serverCodeResultDic4: NSDictionary = ["succeeded": true, "returnedValue": "{\"field\":\"abcd\"}", "executedAt": 1454474985511, "endpoint":"func"]
            let serverCodeResult1 = TriggeredServerCodeResult.resultWithNSDict(serverCodeResultDic1)
            let serverCodeResult2 = TriggeredServerCodeResult.resultWithNSDict(serverCodeResultDic2)
            let serverCodeResult3 = TriggeredServerCodeResult.resultWithNSDict(serverCodeResultDic3)
            let serverCodeResult4 = TriggeredServerCodeResult.resultWithNSDict(serverCodeResultDic4)
            
            let resDic1 = ["nextPaginationKey":expectedNextPaginationKey, "triggerServerCodeResults":[serverCodeResultDic1, serverCodeResultDic2]] as [String : Any]
            let resJson1 = try JSONSerialization.data(withJSONObject: resDic1, options: .prettyPrinted)
            let urlResponse1 = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let requestVerifier1: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key), "testPostNewServerCodeTrigger_success")
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)/results/server-code")
            }

            let resDic2 = ["triggerServerCodeResults":[serverCodeResultDic3, serverCodeResultDic4]]
            let resJson2 = try JSONSerialization.data(withJSONObject: resDic2, options: .prettyPrinted)
            let urlResponse2 = HTTPURLResponse(url: URL(string:setting.app.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let requestVerifier2: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                //verify header
                let expectedHeader = ["authorization": "Bearer \(setting.ownerToken)"]
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key), "testPostNewServerCodeTrigger_success")
                }
                XCTAssertEqual(request.url?.absoluteString, setting.app.baseURL + "/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/triggers/\(triggerID)/results/server-code?paginationKey=\(expectedNextPaginationKey)&bestEffortLimit=2")
            }
            
            iotSession = MockMultipleSession.self
            sharedMockMultipleSession.responsePairs = [
                ((data: resJson1, urlResponse: urlResponse1, error: nil), requestVerifier1),
                ((data: resJson2, urlResponse: urlResponse2, error: nil), requestVerifier2)
            ]

            api.target = setting.target
            api.listTriggeredServerCodeResults(triggerID, bestEffortLimit: 0, paginationKey: nil) { (results, paginationKey, error) -> Void in
                XCTAssertNil(error)
                XCTAssertEqual(2, results!.count)
                XCTAssertEqual(serverCodeResult1, results![0])
                XCTAssertEqual(serverCodeResult2, results![1])
                api.listTriggeredServerCodeResults(triggerID, bestEffortLimit: 2, paginationKey: paginationKey) { (results, paginationKey, error) -> Void in
                    XCTAssertNil(error)
                    XCTAssertEqual(2, results!.count)
                    XCTAssertEqual(serverCodeResult3, results![0])
                    XCTAssertEqual(serverCodeResult4, results![1])
                    expectation.fulfill()
                }
            }
        }catch(let e){
            print(e)
        }

        self.waitForExpectations(timeout: TEST_TIMEOUT) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout for testListTriggeredServerCodeResultsTests_success")
            }
        }
    }
}