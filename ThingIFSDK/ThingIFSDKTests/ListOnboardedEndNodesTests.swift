//
//  ListOnboardedEndNodesTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ListOnboardedEndNodesTests: GatewayAPITestBase {
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testSuccess()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testSuccess")
        let list = [
            [ "thingID": "thing-0001", "vendorThingID": "abcd-1234" ],
            [ "thingID": "thing-0002", "vendorThingID": "efgh-5678" ],
            [ "thingID": "thing-0003", "vendorThingID": "ijkl-9012" ]
        ]
        
        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                // verify path
                let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "authorization": "Bearer \(self.ACCESSTOKEN)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }
            
            // mock response
            let dict = [ "results": list ]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)
            
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(nodes)
                XCTAssertEqual(3, nodes!.count)
                XCTAssertEqual(list[0]["thingID"], nodes![0].thingID)
                XCTAssertEqual(list[0]["vendorThingID"], nodes![0].vendorThingID)
                XCTAssertEqual(list[1]["thingID"], nodes![1].thingID)
                XCTAssertEqual(list[1]["vendorThingID"], nodes![1].vendorThingID)
                XCTAssertEqual(list[2]["thingID"], nodes![2].thingID)
                XCTAssertEqual(list[2]["vendorThingID"], nodes![2].vendorThingID)
                expectation.fulfill()
            })
        } catch(_) {
            XCTFail("should not throw error")
        }
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func testEmpty()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "testEmpty")
        let list: [String : Any] = [ : ]
        
        do {
            // verify request
            let requestVerifier: ((URLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.httpMethod, "GET")
                // verify path
                let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
                XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "authorization": "Bearer \(self.ACCESSTOKEN)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
                }
            }
            
            // mock response
            let dict = [ "results": list ]
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
                statusCode: 200, httpVersion: nil, headerFields: nil)
            
            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self
            
            api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(nodes)
                XCTAssertEqual(0, nodes!.count)
                expectation.fulfill()
            })
        } catch(_) {
            XCTFail("should not throw error")
        }
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: URL(string: setting.app.baseURL)!)
        let expectation = self.expectation(description: "testNoLoggedInError")
        
        api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .userIsNotLoggedIn:
                break
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func test400Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test400Error")
        
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }
        
        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 400, httpVersion: nil, headerFields: nil)
        
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self
        
        api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func test401Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test401Error")
        
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }
        
        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 401, httpVersion: nil, headerFields: nil)
        
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self
        
        api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func test404Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test404Error")
        
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }
        
        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 404, httpVersion: nil, headerFields: nil)
        
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self
        
        api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func test409Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test409Error")
        
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }
        
        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 409, httpVersion: nil, headerFields: nil)
        
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self
        
        api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(409, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
    
    func test503Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectation(description: "test503Error")
        
        // verify request
        let requestVerifier: ((URLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.httpMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/onboarded"
            XCTAssertEqual(request.url!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.value(forHTTPHeaderField: key))
            }
        }
        
        // mock response
        let urlResponse = HTTPURLResponse(url: URL(string:api.gatewayAddress.absoluteString)!,
            statusCode: 503, httpVersion: nil, headerFields: nil)
        
        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self
        
        api.list( { (nodes:[EndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .errorResponse(let actualErrorResponse):
                XCTAssertEqual(503, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }
}
