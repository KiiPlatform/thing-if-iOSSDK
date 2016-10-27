import XCTest
@testable import ThingIFSDK

class TriggeredServerCodeResultTest: SmallTestBase {
    func testResultWithNSDict() {
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
        let expectedDataList: [[AnyObject?]] = [
            [true, 1455531174923, NSNull(), nil, "func1"],
            [true, 1455531174923, "", nil, "func2"],
            [true, 1455531174923, "abc", nil, "func3"],
            [true, 1455531174923, 1234, nil, "func4"],
            [true, 1455531174923, 1455531174923, nil, "func5"],
            [true, 1455531174923, 1234.05, nil, "func6"],
            [true, 1455531174923, true, nil, "func7"],
            [true, 1455531174923, [123, "abc", true, 123.05], nil, "func8"],
            [true, 1455531174923, ["f1":"aaa", "f2":false, "f3":1000, "f4":100.05, "f5":[123]], nil, "func9"],
            [false, 1455531174923, nil, ServerError(errorMessage: "Error found", errorCode: "RUNTIME_ERROR", detailMessage: "faital error"), "func0"],
        ]
        
        for i in 0 ..< testDataList.count {
            let testData = testDataList[i]
            let expectedData = expectedDataList[i]
            let resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            let result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
            XCTAssertEqual(expectedData[0] as? Bool, result.succeeded)
            XCTAssertEqual(Date(timeIntervalSince1970: ((expectedData[1] as? NSNumber)?.doubleValue)!/1000), result.executedAt)
            if result.returnedValue == nil {
                XCTAssertNil(expectedData[2])
            } else {
                XCTAssertTrue(result.returnedValue!.isEqual(expectedData[2]!))
            }
            if expectedData[3] == nil {
                XCTAssertNil(result.error)
            } else {
                XCTAssertTrue(result.error!.isEqual(expectedData[3]!))
            }
            XCTAssertEqual(expectedData[4] as? String, result.endpoint)
        }
    }
    func testGetReturnedValue() {
        var testData : String
        var resultDict : NSDictionary?
        var result : TriggeredServerCodeResult?
        
        // nil
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\"}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertNil(result!.getReturnedValue())
        
        // null
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":null}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertTrue(NSNull().isEqual(result!.getReturnedValue()))
        
        // String
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":\"1234\"}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual("1234", result?.getReturnedValueAsString())
        XCTAssertNil(result?.getReturnedValueAsNSNumber())
        XCTAssertNil(result?.getReturnedValueAsBool())
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Bool
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":true}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertEqual("1", result?.getReturnedValueAsString())
        XCTAssertEqual(1, result?.getReturnedValueAsNSNumber())
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Number int
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":1234}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual(1234, result!.getReturnedValueAsNSNumber()!)
        XCTAssertEqual("1234", result?.getReturnedValueAsString())
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Number long
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":145553117492300}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual(145553117492300, result!.getReturnedValueAsNSNumber()!)
        XCTAssertEqual("145553117492300", result?.getReturnedValueAsString())
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())

        // Number double
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":1234.567}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual(1234.567, result!.getReturnedValueAsNSNumber()!)
        XCTAssertEqual("1234.567", result?.getReturnedValueAsString())
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Array
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":[123, true, \"456\"]}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        let array = result!.getReturnedValueAsArray()!
        XCTAssertEqual(123, array[0] as? NSNumber)
        XCTAssertTrue(array[0] as! Bool)
        XCTAssertEqual("456", array[2] as? String)
        XCTAssertNil(result?.getReturnedValueAsString())
        XCTAssertNil(result?.getReturnedValueAsNSNumber())
        XCTAssertNil(result?.getReturnedValueAsBool())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Dictionary
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"endpoint\":\"func\",\"returnedValue\":{\"f1\":\"aaa\",\"f2\":false,\"f3\":1000,\"f4\":100.05}}"
        resultDict = try! JSONSerialization.jsonObject(with: testData.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        let dict = result!.getReturnedValueAsDictionary()!
        XCTAssertEqual("aaa", dict["f1"] as? String)
        XCTAssertFalse(dict["f2"] as! Bool)
        XCTAssertEqual(1000, dict["f3"] as? NSNumber)
        XCTAssertEqual(100.05, dict["f4"] as? NSNumber)
        XCTAssertNil(result?.getReturnedValueAsString())
        XCTAssertNil(result?.getReturnedValueAsNSNumber())
        XCTAssertNil(result?.getReturnedValueAsBool())
        XCTAssertNil(result?.getReturnedValueAsArray())
    }
    func testIsEqual() {
        let testCases: [[AnyObject]] = [
            // succeeded
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:false, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // executedAt
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311748), endpoint:"func", error:nil),
                false
            ],
            // endpoint
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func1", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func2", error:nil),
                false
            ],
            // returnedValue:String
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcde", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:"abcd", executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // returnedValue:nil
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            // returnedValue:Int
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:123, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:123, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:123, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:1234, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // returnedValue:Double
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:123.45, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:123.45, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:123.45, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:123.46, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // returnedValue:Bool
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:false, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:false, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:false, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:true, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // returnedValue:Array
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:[1234, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abcd", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", false, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.45], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:[123, "abc", true, 123.46], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // returnedValue:Dictionary
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abcd", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":1234, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.5, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":false, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,4], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":123]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                TriggeredServerCodeResult(succeeded:true, returnedValue:["f1":"abc", "f2":123, "f3":123.4, "f4":true, "f5":[1,2,3], "f6":["child":124]], executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:nil),
                false
            ],
            // ServerError
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:ServerError(errorMessage: "msg", errorCode: "code", detailMessage: "detail")),
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:ServerError(errorMessage: "msg", errorCode: "code", detailMessage: "detail")),
                true
            ],
            [
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:ServerError(errorMessage: "msg", errorCode: "code", detailMessage: "detail")),
                TriggeredServerCodeResult(succeeded:true, returnedValue:nil, executedAt:Date(timeIntervalSince1970:14555311749), endpoint:"func", error:ServerError(errorMessage: "msg", errorCode: "code2", detailMessage: "detail")),
                false
            ],
        ]
        for var testCase in testCases {
            XCTAssertEqual(testCase[0].isEqual(testCase[1]), (testCase[2] as! Bool))
        }
    }
}
