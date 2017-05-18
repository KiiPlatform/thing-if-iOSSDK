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
        let query = GroupedHistoryStatesQuery(alias, timeRange: timeRange, clause: clause, firmwareVersion: "V1")
        let aggregation = try Aggregation.makeMaxAggregation(
            "dummyField",
            fieldType: Aggregation.FieldType.integer)
        let historyState = HistoryState(
            ["power" : true, "currentTemperature" : 25],
            createdAt: Date(timeIntervalSince1970: 50))

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
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
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
                                    "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                                    "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                    ],
                    "firmwareVersion" : "V1"
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
            )
        }

        // mock response
        let responseBody : [String: Any] = [
            "groupedResults" : [
                [
                    "range" : [
                        "from" : timeRange.from.timeIntervalSince1970InMillis,
                        "to" : timeRange.to.timeIntervalSince1970InMillis
                    ],
                    "aggregations" : [
                        [
                            "value" : 25,
                            "name" : "max",
                            "object" : historyState.makeJsonObject()
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
            XCTAssertEqual(historyState, result.aggregatedObjects[0])
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
        let historyState = HistoryState(
            ["power" : true, "currentTemperature" : 25],
            createdAt: Date(timeIntervalSince1970: 50))

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
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
            )
        }

        // mock response
        let responseBody : [String: Any] = [
            "groupedResults" : [
                [
                    "range" : [
                        "from" : timeRange.from.timeIntervalSince1970InMillis,
                        "to" : timeRange.to.timeIntervalSince1970InMillis
                    ],
                    "aggregations" : [
                        [
                            "value" : 25,
                            "name" : "max",
                            "object" : historyState.makeJsonObject()
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
            XCTAssertEqual(historyState, result.aggregatedObjects[0])
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
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
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
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
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
                    400, errorCode: "", errorMessage: "")),
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
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
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
                        403, errorCode: "", errorMessage: "")),
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
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
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
                    404, errorCode: "", errorMessage: "")),
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
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
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
                    409, errorCode: "", errorMessage: "")),
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
                    "X-Kii-AppID": setting.app.appID,
                    "X-Kii-AppKey": setting.app.appKey,
                    "X-Kii-SDK" : SDKVersion.sharedInstance.kiiSDKHeader,
                    "Authorization": "Bearer \(setting.owner.accessToken)",
                    "Content-Type": "application/vnd.kii.TraitStateQueryRequest+json"
                ],
                request.allHTTPHeaderFields!)

            //verify body
            XCTAssertEqual(
                [
                    "query": [
                        "clause": [
                            "type": "withinTimeRange",
                            "lowerLimit": timeRange.from.timeIntervalSince1970InMillis,
                            "upperLimit": timeRange.to.timeIntervalSince1970InMillis
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
                ],
                try JSONSerialization.jsonObject(
                    with: request.httpBody!,
                    options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary
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
                    503, errorCode: "", errorMessage: "")),
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
