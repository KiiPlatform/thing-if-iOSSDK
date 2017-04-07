import XCTest
@testable import ThingIFSDK

class TriggeredServerCodeResultTest: SmallTestBase {
    override class func defaultTestSuite() -> XCTestSuite { //TODO: This is temporary to mark crashed test, remove this later

        let testSuite = XCTestSuite(name: NSStringFromClass(self))

        return testSuite
    }
    func testResultWithNSDict() throws {
        let testDataList = [
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func1\",\"returnedValue\":null}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func2\",\"returnedValue\":\"\"}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func3\",\"returnedValue\":\"abc\"}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func4\",\"returnedValue\":1234}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func5\",\"returnedValue\":1455531174923}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func6\",\"returnedValue\":1234.05}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func7\",\"returnedValue\":true}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func8\",\"returnedValue\":[123, \"abc\", true, 123.05]}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func9\",\"returnedValue\":{\"f1\":\"aaa\",\"f2\":false,\"f3\":1000,\"f4\":100.05,\"f5\":[123]}}",
            "{\"succeeded\":false,\"executedAt\":1455531174923,\"endpoint\":\"func0\",\"error\":{\"errorMessage\":\"Error found\",\"details\":{\"errorCode\":\"RUNTIME_ERROR\",\"message\":\"faital error\"}}}",
        ]
        let expectedDataList: [[Any?]] = [
            [true, 1455531174923, NSNull(), nil, "func1"],
            [true, 1455531174923, "", nil, "func2"],
            [true, 1455531174923, "abc", nil, "func3"],
            [true, 1455531174923, 1234, nil, "func4"],
            [true, 1455531174923, 1455531174923, nil, "func5"],
            [true, 1455531174923, 1234.05, nil, "func6"],
            [true, 1455531174923, true, nil, "func7"],
            [true, 1455531174923, [123, "abc", true, 123.05], nil, "func8"],
            [true, 1455531174923, ["f1":"aaa", "f2":false, "f3":1000, "f4":100.05, "f5":[123]], nil, "func9"],
            [false, 1455531174923, nil, ServerError("Error found", errorCode: "RUNTIME_ERROR", detailMessage: "faital error"), "func0"],
        ]

        for i in 0 ..< testDataList.count {
            let testData = testDataList[i]
            let expectedData = expectedDataList[i]
            let resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
            let result = try TriggeredServerCodeResult(resultDict)
            XCTAssertEqual(expectedData[0] as? Bool, result.succeeded)
            XCTAssertEqual(Date(timeIntervalSince1970: ((expectedData[1] as? NSNumber)?.doubleValue)!/1000), result.executedAt)
            if result.returnedValue == nil {
                XCTAssertNil(expectedData[2])
            } else {
                XCTAssertTrue((result.returnedValue as AnyObject).isEqual(expectedData[2]!))
            }
            XCTAssertEqual(result.error, expectedData[3] as? ServerError)
            XCTAssertEqual(expectedData[4] as? String, result.endpoint)
        }
    }
    func testGetReturnedValue() throws {
        var testData : String
        var resultDict : [String : Any]
        var result : TriggeredServerCodeResult?

        // nil
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\"}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertNil(result!.returnedValue)

        // null
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":null}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertTrue(NSNull().isEqual(result!.returnedValue))

        // String
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":\"1234\"}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertEqual("1234", result?.returnedValueAsString)
        XCTAssertNil(result?.returnedValueAsInt)
        XCTAssertNil(result?.returnedValueAsDouble)
        XCTAssertNil(result?.returnedValueAsBool)
        XCTAssertNil(result?.returnedValueAsArray)
        XCTAssertNil(result?.returnedValueAsDictionary)

        // Bool
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":true}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertTrue(result!.returnedValueAsBool!)
        XCTAssertEqual("1", result?.returnedValueAsString)
        XCTAssertNil(result!.returnedValueAsInt)
        XCTAssertNil(result!.returnedValueAsDouble)
        XCTAssertNil(result?.returnedValueAsArray)
        XCTAssertNil(result?.returnedValueAsDictionary)

        // Number int
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":1234}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertEqual(1234, result!.returnedValueAsInt!)
        XCTAssertEqualWithAccuracy(1234.0, result!.returnedValueAsDouble!, accuracy: 0.01)
        XCTAssertEqual("1234", result?.returnedValueAsString)
        XCTAssertTrue(result!.returnedValueAsBool!)
        XCTAssertNil(result?.returnedValueAsArray)
        XCTAssertNil(result?.returnedValueAsDictionary)

        // Number long
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":145553117492300}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertEqual(145553117492300, result!.returnedValueAsInt!)
        XCTAssertEqualWithAccuracy(145553117492300.0 , result!.returnedValueAsDouble!, accuracy: 0.01)
        XCTAssertEqual("145553117492300", result?.returnedValueAsString)
        XCTAssertTrue(result!.returnedValueAsBool!)
        XCTAssertNil(result?.returnedValueAsArray)
        XCTAssertNil(result?.returnedValueAsDictionary)

        // Number double
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":1234.567}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        XCTAssertEqual(1234, result!.returnedValueAsInt!)
        XCTAssertEqualWithAccuracy(1234.567, result!.returnedValueAsDouble!, accuracy: 0.01)
        XCTAssertEqual("1234.567", result?.returnedValueAsString)
        XCTAssertTrue(result!.returnedValueAsBool!)
        XCTAssertNil(result?.returnedValueAsArray)
        XCTAssertNil(result?.returnedValueAsDictionary)

        // Array
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":[123, true, \"456\"]}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        let array = result!.returnedValueAsArray!
        XCTAssertEqual(123, array[0] as? NSNumber)
        XCTAssertTrue(array[0] as! Bool)
        XCTAssertEqual("456", array[2] as? String)
        XCTAssertNil(result?.returnedValueAsString)
        XCTAssertNil(result?.returnedValueAsInt)
        XCTAssertNil(result?.returnedValueAsDouble)
        XCTAssertNil(result?.returnedValueAsBool)
        XCTAssertNil(result?.returnedValueAsDictionary)

        // Dictionary
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":{\"f1\":\"aaa\",\"f2\":false,\"f3\":1000,\"f4\":100.05}}"
        resultDict = try JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        result = try TriggeredServerCodeResult(resultDict)
        let dict = result!.returnedValueAsDictionary!
        XCTAssertEqual("aaa", dict["f1"] as? String)
        XCTAssertFalse(dict["f2"] as! Bool)
        XCTAssertEqual(1000, dict["f3"] as? NSNumber)
        XCTAssertEqual(100.05, dict["f4"] as? NSNumber)
        XCTAssertNil(result?.returnedValueAsString)
        XCTAssertNil(result?.returnedValueAsInt)
        XCTAssertNil(result?.returnedValueAsDouble)
        XCTAssertNil(result?.returnedValueAsBool)
        XCTAssertNil(result?.returnedValueAsArray)
    }
    func testIsEqual() throws {
        let testCases: [[Any]] = [
            // succeeded
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                TriggeredServerCodeResult(false, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                false
            ],
            // executedAt
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311748), endpoint: "func", returnedValue: "abcd", error: nil),
                false
            ],
            // endpoint
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func1", returnedValue: "abcd", error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func2", returnedValue: "abcd", error: nil),
                false
            ],
            // returnedValue:String
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcde", error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: "abcd", error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: nil),
                false
            ],
            // returnedValue:nil
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: nil),
                true
            ],
            // returnedValue:Int
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123, error: nil),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 1234, error: nil),
                false
            ],
            // returnedValue:Double
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123.45, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123.45, error: nil),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123.45, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: 123.46, error: nil),
                false
            ],
            // returnedValue:Bool
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: false, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: false, error: nil),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: false, error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: true, error: nil),
                false
            ],
            // returnedValue:Array
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.45], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.45], error: nil),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.45], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [1234, "abc", true, 123.45], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.45], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abcd", true, 123.45], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.45], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", false, 123.45], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.45], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: [123, "abc", true, 123.46], error: nil),
                false
            ],
            // returnedValue:Dictionary
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abcd", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":1234, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.5, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":false, "f5":[1,2,3], "f6":["child":123]], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,4], "f6":["child":123]], error: nil),
                false
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], error: nil),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: ["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":124]], error: nil),
                false
            ],
            // ServerError
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: ServerError("msg", errorCode: "code", detailMessage: "detail")),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: ServerError("msg", errorCode: "code", detailMessage: "detail")),
                true
            ],
            [
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: ServerError("msg", errorCode: "code", detailMessage: "detail")),
                TriggeredServerCodeResult(true, executedAt: Date(timeIntervalSince1970:14555311749), endpoint: "func", returnedValue: nil, error: ServerError("msg", errorCode: "code2", detailMessage: "detail")),
                false
            ],
        ]
        for var testCase in testCases {
            if let testCase0 = testCase[0] as? TriggeredServerCodeResult,
               let testCase1 = testCase[1] as? TriggeredServerCodeResult,
               let isSame = testCase[2] as? Bool
            {
                if isSame {
                    XCTAssertEqual(testCase0, testCase1)
                } else {
                    XCTAssertFalse(testCase0 == testCase1)
                }
            } else {
                XCTFail("unexpected test case.")
            }
        }
    }
}
