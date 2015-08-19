//
//  TestHelpers.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/11/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation
import XCTest

func failIfNotRunningOnDevice(){
    let environment = NSProcessInfo.processInfo().environment
    
    if environment["SIMULATOR_RUNTIME_VERSION"] != nil {
        XCTFail("This test is prohibited to launch in simulator")
    }
    
}
typealias MockResponse = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)
typealias MockResponsePair = (response: MockResponse,requestVerifier: ((NSURLRequest) -> Void))

class MockSession: NSURLSession {
    var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
    static var requestVerifier: ((NSURLRequest) -> Void) = {(request) in }
    
    static var mockResponse: (data: NSData?, urlResponse: NSURLResponse?, error: NSError?) = (data: nil, urlResponse: nil, error: nil)
    
    override class func sharedSession() -> NSURLSession {
        return MockSession()
    }
    
    override func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        self.completionHandler = completionHandler
        
        return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
    }
    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        MockSession.requestVerifier(request)
        
        self.completionHandler = completionHandler
        
        return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
    }
    class MockTask: NSURLSessionDataTask {
        @objc override var state : NSURLSessionTaskState {
            return NSURLSessionTaskState.Suspended
        }
    

        var mockResponse: MockResponse
        let completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
        
        init(response: MockResponse, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
            self.mockResponse = response
            self.completionHandler = completionHandler
        }
        override func resume() {
            
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
        
    }
}

class MockMultipleSession: NSURLSession {
    var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
    static var responsePairs = [MockResponsePair?]()

    override class func sharedSession() -> NSURLSession {
        return MockMultipleSession()
    }

    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {

        guard let pair = MockMultipleSession.responsePairs.removeAtIndex(0) else{
            return MockTask(response: MockSession.mockResponse, completionHandler: completionHandler)
        }

        pair.requestVerifier(request)


        self.completionHandler = completionHandler

        return MockTask(response: pair.response, completionHandler: completionHandler)
    }
    class MockTask: NSURLSessionDataTask {
        @objc override var state : NSURLSessionTaskState {
            return NSURLSessionTaskState.Suspended
        }


        var mockResponse: MockResponse
        let completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?

        init(response: MockResponse, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
            self.mockResponse = response
            self.completionHandler = completionHandler
        }
        override func resume() {

            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }

    }
}

