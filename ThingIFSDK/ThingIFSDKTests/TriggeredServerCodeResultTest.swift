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
            [false, 1455531174923, nil, ["errorMessage":"Error found", "details":["errorCode":"RUNTIME_ERROR", "message":"faital error"]]],
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
                XCTAssertTrue(NSDictionary(dictionary: expectedData[3]! as! [String : AnyObject]).isEqualToDictionary(result.error!))
            }
        }
    }
}
