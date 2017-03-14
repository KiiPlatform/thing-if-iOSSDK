//
//  ThingIFAPIAggregateTests.swift
//  ThingIFSDK
//
//  Copyright (C) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIAggregateTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let clause : EqualsClauseInQuery = EqualsClauseInQuery("dummyField", intValue: 10)
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange, clause: clause)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "and",
                        "clauses": [
                            [
                                "type": "eq",
                                "field": clause.field,
                                "value": clause.value
                            ],
                            [
                                "type": "withinTimeRange",
                                "lowerLimit": timeRange.from.timeIntervalSince1970,
                                "upperLimit": timeRange.to.timeIntervalSince1970
                            ]
                        ]
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
            "groupedResults" : [
                [
                    "range" : [
                        "from" : timeRange.from.timeIntervalSince1970,
                        "to" : timeRange.to.timeIntervalSince1970
                    ],
                    "aggregations" : [
                        [
                            "value" : 25,
                            "name" : "max",
                            "object" : [
                                "_created": 50,
                                "power" : true,
                                "currentTemperature" : 25
                            ]
                        ]
                    ]
                ]
            ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssertEqual(1, results!.count)
            let result: AggregatedResult<Int> = results![0]
            XCTAssertNotNil(result)
            XCTAssertEqual(25, result.value)
            XCTAssertEqual(timeRange, result.timeRange)
            XCTAssertEqual(1, result.aggregatedObjects.count)
            let object : HistoryState = result.aggregatedObjects[0]
            XCTAssertNotNil(object)
            XCTAssertEqual(true, object.state["power"] as! Bool)
            XCTAssertEqual(25, object.state["currentTemperature"] as! Int)
            XCTAssertEqual(50, object.createdAt.timeIntervalSince1970)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testSuccessNoClause() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "withinTimeRange",
                        "lowerLimit": timeRange.from.timeIntervalSince1970,
                        "upperLimit": timeRange.to.timeIntervalSince1970
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
            "groupedResults" : [
                [
                    "range" : [
                        "from" : timeRange.from.timeIntervalSince1970,
                        "to" : timeRange.to.timeIntervalSince1970
                    ],
                    "aggregations" : [
                        [
                            "value" : 25,
                            "name" : "max",
                            "object" : [
                                "_created": 50,
                                "power" : true,
                                "currentTemperature" : 25
                            ]
                        ]
                    ]
                ]
            ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssertEqual(1, results!.count)
            let result: AggregatedResult<Int> = results![0]
            XCTAssertNotNil(result)
            XCTAssertEqual(25, result.value)
            XCTAssertEqual(timeRange, result.timeRange)
            XCTAssertEqual(1, result.aggregatedObjects.count)
            let object : HistoryState = result.aggregatedObjects[0]
            XCTAssertNotNil(object)
            XCTAssertEqual(true, object.state["power"] as! Bool)
            XCTAssertEqual(25, object.state["currentTemperature"] as! Int)
            XCTAssertEqual(50, object.createdAt.timeIntervalSince1970)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testSuccessNoStateInServer() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "withinTimeRange",
                        "lowerLimit": timeRange.from.timeIntervalSince1970,
                        "upperLimit": timeRange.to.timeIntervalSince1970
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
        let responseBody = [
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(results)
            XCTAssertEqual(0, results!.count)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse400() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "withinTimeRange",
                        "lowerLimit": timeRange.from.timeIntervalSince1970,
                        "upperLimit": timeRange.to.timeIntervalSince1970
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(results)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    httpStatusCode: 400, errorCode: "", errorMessage: "")),
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
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970,
                            "upperLimit": timeRange.to.timeIntervalSince1970
                        ],
                        "grouped": true,
                        "aggregations": [
                            [
                                "type": aggregation.function.rawValue.uppercased(),
                                "putAggregationInto": aggregation.function.rawValue.lowercased(),
                                "field": aggregation.field,
                                "fieldType": aggregation.fieldType.rawValue
                            ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
                XCTAssertNil(results)
                XCTAssertEqual(
                    ThingIFError.errorResponse(required: ErrorResponse(
                        httpStatusCode: 403, errorCode: "", errorMessage: "")),
                    error)
                expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse404() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "withinTimeRange",
                        "lowerLimit": timeRange.from.timeIntervalSince1970,
                        "upperLimit": timeRange.to.timeIntervalSince1970
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(results)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    httpStatusCode: 404, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse409() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "withinTimeRange",
                        "lowerLimit": timeRange.from.timeIntervalSince1970,
                        "upperLimit": timeRange.to.timeIntervalSince1970
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(results)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    httpStatusCode: 409, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorResponse503() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

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
                    "x-kii-appid": setting.app.appID,
                    "x-kii-appkey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            let expectedBody: [ String : Any] = [
                "query": [
                    "clause": [
                        "type": "withinTimeRange",
                        "lowerLimit": timeRange.from.timeIntervalSince1970,
                        "upperLimit": timeRange.to.timeIntervalSince1970
                    ],
                    "grouped": true,
                    "aggregations": [
                        [
                            "type": aggregation.function.rawValue.uppercased(),
                            "putAggregationInto": aggregation.function.rawValue.lowercased(),
                            "field": aggregation.field,
                            "fieldType": aggregation.fieldType.rawValue
                        ]
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
        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(results)
            XCTAssertEqual(
                ThingIFError.errorResponse(required: ErrorResponse(
                    httpStatusCode: 503, errorCode: "", errorMessage: "")),
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }

    func testErrorNoTarget() throws {
        let expectation = self.expectation(description: "testErrorResponse403")
        let setting = TestSetting()
        let alias = "dummyAlias"
        let timeRange = TimeRange(Date(timeIntervalSince1970: 1), to: Date(timeIntervalSince1970: 1))
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange)
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)

        setting.api.aggregate(query, aggregation: aggregation) {
            (results: [AggregatedResult<Int>]?, error) in
            XCTAssertNil(results)
            XCTAssertEqual(
                ThingIFError.targetNotAvailable,
                error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }
    }
}
