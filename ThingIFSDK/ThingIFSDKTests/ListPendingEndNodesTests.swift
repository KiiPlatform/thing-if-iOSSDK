//
//  ListPendingEndNodesTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ListPendingEndNodesTests: GatewayAPITestBase {

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
        let expectation = self.expectationWithDescription("testSuccess")
        let propeties:Dictionary<String, AnyObject> = [ "debug": true ]
        let list = [
            [ "vendorThingID": "abcd-1234" ],
            [ "vendorThingID": "efgh-5678" ],
            [ "vendorThingID": "ijkl-9012", "thingProperties": propeties ]
        ]

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                // verify path
                let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "authorization": "Bearer \(self.ACCESSTOKEN)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
            }

            // mock response
            let dict = [ "results": list ]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(nodes)
                XCTAssertEqual(3, nodes!.count)
                XCTAssertEqual(list[0]["vendorThingID"] as? String, nodes![0].vendorThingID)
                XCTAssertNil(nodes![0].thingProperties)
                XCTAssertEqual(list[1]["vendorThingID"] as? String, nodes![1].vendorThingID)
                XCTAssertNil(nodes![1].thingProperties)
                XCTAssertEqual(list[2]["vendorThingID"] as? String, nodes![2].vendorThingID)
                XCTAssertEqual(propeties.description, nodes![2].thingProperties?.description)
                expectation.fulfill()
            })
        } catch(_) {
            XCTFail("should not throw error")
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testEmpty()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("testEmpty")
        let list = [
        ]

        do {
            // verify request
            let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
                XCTAssertEqual(request.HTTPMethod, "GET")
                // verify path
                let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
                XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
                //verify header
                let expectedHeader = [
                    "authorization": "Bearer \(self.ACCESSTOKEN)"
                ]
                XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
                for (key, value) in expectedHeader {
                    XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
                }
            }

            // mock response
            let dict = [ "results": list ]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
                statusCode: 200, HTTPVersion: nil, headerFields: nil)

            sharedMockSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
            sharedMockSession.requestVerifier = requestVerifier
            iotSession = MockSession.self

            api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(nodes)
                XCTAssertEqual(0, nodes!.count)
                expectation.fulfill()
            })
        } catch(_) {
            XCTFail("should not throw error")
        }

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func testNoLoggedInError()
    {
        let setting = TestSetting()
        let api:GatewayAPI = GatewayAPI(app: setting.app, gatewayAddress: NSURL(string: setting.app.baseURL)!)
        let expectation = self.expectationWithDescription("testNoLoggedInError")

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .USER_IS_NOT_LOGGED_IN:
                break
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test400Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("test400Error")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
            statusCode: 400, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(400, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test401Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("test401Error")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
            statusCode: 401, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(401, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test404Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("test404Error")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
            statusCode: 404, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(404, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test409Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("test409Error")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
            statusCode: 409, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(409, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
            }
            expectation.fulfill()
        })

        self.waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                XCTFail("execution timeout")
            }
        }
    }

    func test503Error()
    {
        let api:GatewayAPI = getLoggedInGatewayAPI()
        let expectation = self.expectationWithDescription("test503Error")

        // verify request
        let requestVerifier: ((NSURLRequest) -> Void) = {(request) in
            XCTAssertEqual(request.HTTPMethod, "GET")
            // verify path
            let expectedPath = "\(api.gatewayAddress.absoluteString!)/\(api.app.siteName)/apps/\(api.app.appID)/gateway/end-nodes/pending"
            XCTAssertEqual(request.URL!.absoluteString, expectedPath, "Should be equal")
            //verify header
            let expectedHeader = [
                "authorization": "Bearer \(self.ACCESSTOKEN)"
            ]
            XCTAssertEqual(expectedHeader.count, request.allHTTPHeaderFields?.count)
            for (key, value) in expectedHeader {
                XCTAssertEqual(value, request.valueForHTTPHeaderField(key))
            }
        }

        // mock response
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string:api.gatewayAddress.absoluteString!)!,
            statusCode: 503, HTTPVersion: nil, headerFields: nil)

        sharedMockSession.mockResponse = (nil, urlResponse: urlResponse, error: nil)
        sharedMockSession.requestVerifier = requestVerifier
        iotSession = MockSession.self

        api.listPendingEndNodes( { (nodes:[PendingEndNode]?, error:ThingIFError?) -> Void in
            XCTAssertNil(nodes)
            XCTAssertNotNil(error)
            switch error! {
            case .ERROR_RESPONSE(let actualErrorResponse):
                XCTAssertEqual(503, actualErrorResponse.httpStatusCode)
            default:
                XCTFail("unknown error response")
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
