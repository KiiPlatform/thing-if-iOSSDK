//
//  TestHelpers.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/11/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
import XCTest

public let TEST_TIMEOUT = 5.0

func failIfNotRunningOnDevice(){
    let environment = NSProcessInfo.processInfo().environment

    if environment["SIMULATOR_RUNTIME_VERSION"] != nil {
        XCTFail("This test is prohibited to launch in simulator")
    }

}
typealias MockResponse = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)
typealias MockResponsePair = (response: MockResponse,requestVerifier: ((NSURLRequest) -> Void))
let sharedMockSession = MockSession()
private class MockTask: NSURLSessionDataTask {

    @objc override var state : NSURLSessionTaskState {
        return NSURLSessionTaskState.Suspended
    }

    override func resume() {

    }

}
class MockSession: NSURLSession {
    var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
    var requestVerifier: ((NSURLRequest) -> Void) = {(request) in }

    var mockResponse: (data: NSData?, urlResponse: NSURLResponse?, error: NSError?) = (data: nil, urlResponse: nil, error: nil)

    override class func sharedSession() -> NSURLSession {
        return sharedMockSession
    }

    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        self.requestVerifier(request)

        self.completionHandler = completionHandler
        completionHandler(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        return MockTask()
    }

}
let sharedMockMultipleSession = MockMultipleSession()
class MockMultipleSession: NSURLSession {

    var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
    var responsePairs = [MockResponsePair]()

    override class func sharedSession() -> NSURLSession {
        return sharedMockMultipleSession
    }

    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        if (self.responsePairs.count > 0) {
            let pair = self.responsePairs.removeAtIndex(0);
            pair.requestVerifier(request)
            completionHandler(pair.response.data, pair.response.urlResponse, pair.response.error)
        } else {
            assertionFailure("Invalid Mocking Detected.")
        }
        return MockTask()
    }
}

