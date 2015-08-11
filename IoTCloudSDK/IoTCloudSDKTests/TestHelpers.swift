//
//  TestHelpers.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/11/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import Foundation

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
    
        typealias Response = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)
        var mockResponse: Response
        let completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?
        
        init(response: Response, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
            self.mockResponse = response
            self.completionHandler = completionHandler
        }
        override func resume() {
            
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
        
    }
}
