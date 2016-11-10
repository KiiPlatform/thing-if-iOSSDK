//
//  IoTRequestTests.swift
//  ThingIFSDK
//
//  Created by syahRiza on 7/19/16.
//  Copyright © 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class IoTRequestTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRequestInvalidURL(){
        let operationQueue = ThingIFSDK.OperationQueue()
        let expectation = self.expectation(description: "testRequestInvalidURL")
        let appID = "dummyApp"
        let targetStr = "dummy_target"
        let triggerID = "dummy_id"
        let baseURL = "https://https://dummy"
        let accessToken = "accessToken"

        let enableString = "enable"

        let requestURL = "\(baseURL)/thing-if/apps/\(appID)/targets/\(targetStr)/triggers/\(triggerID)/\(enableString)"

        // generate header
        let requestHeaderDict:Dictionary<String, String> = ["authorization": "Bearer \(accessToken)", "content-type": "application/json"]

        iotSession = URLSession.self

        let request = buildDefaultRequest(HTTPMethod.PUT,urlString: requestURL, requestHeaderDict: requestHeaderDict, requestBodyData: nil, completionHandler: { (response, error) -> Void in
            if error == nil {
                XCTFail("Should not be nil")
            }else{
                switch error! {
                case .connection:
                    XCTFail(": should not be connection")
                case .errorRequest(let actualErrorRequest):
                    XCTAssertEqual("A server with the specified hostname could not be found.",
                        actualErrorRequest.localizedDescription)
                default:
                    XCTFail("Invalid error")
                }
            }
            expectation.fulfill()
        })

        let operation = IoTRequestOperation(request: request)
        operationQueue.addOperation(operation)
        self.waitForExpectations(timeout: 30) { (error) in
            if error != nil {
                XCTFail()
            }
        }
    }

}
