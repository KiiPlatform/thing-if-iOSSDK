//
//  ThingIFAPIQueryUngroupedTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIQueryUngroupedTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() throws {
        let expectation = self.expectation(description: "testSuccess")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)
        let historyState = HistoryState(
            ["power" : true, "currentTemperature" : 25],
            createdAt: Date(timeIntervalSince1970: 50))
        let nextPaginationKey = "100/2"

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        let responseBody : [String: Any] = [
            "results" : [
                historyState.makeJsonObject()
            ],
            "nextPaginationKey": nextPaginationKey
        ]
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssertEqual(1, results!.count)
            let result: HistoryState = results![0]
            XCTAssertEqual(historyState, result)
            XCTAssertEqual(nextPaginationKey, paginationKey)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testSuccessResultsEmpty() throws {
        let expectation = self.expectation(description: "testSuccessResultsEmpty")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        let responseBody : [String: Any] = [
            "results" : [ ]
        ]
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssertEqual(0, results!.count)
            XCTAssertNil(paginationKey)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testSuccessNoStateInServer() throws {
        let expectation = self.expectation(description: "testSuccessNoStateInServer")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        let responseBody : [String: Any] = [
            "errorCode" : "STATE_HISTORY_NOT_AVAILABLE",
            "message" : "Time series bucket does not exist"
        ]
        sharedMockSession.mockResponse = (
            try JSONSerialization.data(withJSONObject: responseBody, options: JSONSerialization.WritingOptions(rawValue: 0)),
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 409,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssertEqual(0, results!.count)
            XCTAssertNil(paginationKey)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse400() throws {
        let expectation = self.expectation(description: "testErrorResponse400")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(400, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse403() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 403,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(403, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse404() throws {
        let expectation = self.expectation(description: "testErrorResponse404")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(404, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse409() throws {
        let expectation = self.expectation(description: "testErrorResponse409")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 409,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(409, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse503() throws {
        let expectation = self.expectation(description: "testErrorResponse503")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        // verify request
        sharedMockSession.requestVerifier = makeRequestVerifier() {(request) in
            XCTAssertEqual(request.httpMethod, "POST")

            // verify path
            XCTAssertEqual(
                request.url!.absoluteString,
                "\(setting.api.baseURL)/thing-if/apps/\(setting.app.appID)/targets/\(setting.target.typedID.toString())/states/aliases/\(alias)/query")

            //verify header
            XCTAssertEqual(
                [
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": MediaType.mediaTypeTraitStateQueryRequest.rawValue
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "eq",
                        "field": clause.field,
                        "value": clause.value
                    ]
                ]
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: expectedBody, options: JSONSerialization.WritingOptions(rawValue: 0))
            let expectedBodyStr: String = String.init(data: data, encoding: .utf8)!
            //verify body
            XCTAssertEqual(
                expectedBodyStr,
                String.init(data: request.httpBody!, encoding: .utf8)
            )
        }

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 503,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        setting.api.target = setting.target
        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(
                ThingIFError.errorResponse(
                    required: ErrorResponse(503, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorNoTarget() throws {
        let expectation = self.expectation(description: "testErrorNoTarget")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = HistoryStatesQuery(alias, clause: clause)

        setting.api.query(query) {
            (results: [HistoryState]?, paginationKey:String?, error) in
            XCTAssertNil(results)
            XCTAssertNil(paginationKey)
            XCTAssertEqual(ThingIFError.targetNotAvailable, error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
