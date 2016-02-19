import XCTest
@testable import ThingIFSDK

class TriggeredServerCodeResultTest: XCTestCase {
    func testResultWithNSDict() {
        let testDataList = [
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":null}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":\"\"}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":\"abc\"}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":1234}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":1455531174923}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":1234.05}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":true}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":[123, \"abc\", true, 123.05]}",
            "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":{\"f1\":\"aaa\",\"f2\":false,\"f3\":1000,\"f4\":100.05,\"f5\":[123]}}",
            "{\"succeeded\":false,\"executedAt\":1455531174923,\"error\":{\"errorMessage\":\"Error found\",\"details\":{\"errorCode\":\"RUNTIME_ERROR\",\"message\":\"faital error\"}}}",
        ]
        let expectedDataList: [[AnyObject?]] = [
            [true, 1455531174923, NSNull(), nil],
            [true, 1455531174923, "", nil],
            [true, 1455531174923, "abc", nil],
            [true, 1455531174923, 1234, nil],
            [true, 1455531174923, 1455531174923, nil],
            [true, 1455531174923, 1234.05, nil],
            [true, 1455531174923, true, nil],
            [true, 1455531174923, [123, "abc", true, 123.05], nil],
            [true, 1455531174923, ["f1":"aaa", "f2":false, "f3":1000, "f4":100.05, "f5":[123]], nil],
            [false, 1455531174923, nil, ServerError(errorMessage: "Error found", errorCode: "RUNTIME_ERROR", detailMessage: "faital error")],
        ]
        
        for var i = 0; i < testDataList.count; ++i {
            let testData = testDataList[i]
            let expectedData = expectedDataList[i]
            let resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            let result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
            XCTAssertEqual(expectedData[0] as? Bool, result.succeeded)
            XCTAssertEqual(NSDate(timeIntervalSince1970: ((expectedData[1] as? NSNumber)?.doubleValue)!/1000), result.executedAt)
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
        }
    }
    func testGetReturnedValue() {
        var testData : String
        var resultDict : NSDictionary?
        var result : TriggeredServerCodeResult?
        
        // nil
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertNil(result!.getReturnedValue())
        
        // null
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":null}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertTrue(NSNull().isEqual(result!.getReturnedValue()))
        
        // String
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":\"1234\"}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual("1234", result?.getReturnedValueAsString())
        XCTAssertNil(result?.getReturnedValueAsNSNumber())
        XCTAssertNil(result?.getReturnedValueAsBool())
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Bool
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":true}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertEqual("1", result?.getReturnedValueAsString())
        XCTAssertEqual(1, result?.getReturnedValueAsNSNumber())
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Number int
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":1234}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual(1234, result!.getReturnedValueAsNSNumber()!)
        XCTAssertEqual("1234", result?.getReturnedValueAsString())
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Number long
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":145553117492300}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual(145553117492300, result!.getReturnedValueAsNSNumber()!)
        XCTAssertEqual("145553117492300", result?.getReturnedValueAsString())
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())

        // Number double
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":1234.567}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        result = TriggeredServerCodeResult.resultWithNSDict(resultDict!)!
        XCTAssertEqual(1234.567, result!.getReturnedValueAsNSNumber()!)
        XCTAssertEqual("1234.567", result?.getReturnedValueAsString())
        XCTAssertTrue(result!.getReturnedValueAsBool()!)
        XCTAssertNil(result?.getReturnedValueAsArray())
        XCTAssertNil(result?.getReturnedValueAsDictionary())
        
        // Array
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":[123, true, \"456\"]}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
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
        testData = "{\"succeeded\":true,\"executedAt\":1455531174923,\"returnedValue\":{\"f1\":\"aaa\",\"f2\":false,\"f3\":1000,\"f4\":100.05}}"
        resultDict = try! NSJSONSerialization.JSONObjectWithData(testData.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
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
}
