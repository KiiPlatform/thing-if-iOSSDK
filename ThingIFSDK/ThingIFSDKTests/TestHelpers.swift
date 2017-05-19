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
    let environment = ProcessInfo.processInfo.environment

    if environment["SIMULATOR_RUNTIME_VERSION"] != nil {
        XCTFail("This test is prohibited to launch in simulator")
    }

}
typealias MockResponse = (data: Data?, urlResponse: URLResponse?, error: NSError?)
typealias MockResponsePair = (response: MockResponse,requestVerifier: ((URLRequest) -> Void))
let sharedMockSession = MockSession()
private class MockTask: URLSessionDataTask {

    @objc override var state : URLSessionTask.State {
        return URLSessionTask.State.suspended
    }

    override func resume() {

    }

}
class MockSession: URLSession {
    var completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?
    var requestVerifier: ((URLRequest) -> Void) = {(request) in }

    var mockResponse: (data: Data?, urlResponse: URLResponse?, error: NSError?) = (data: nil, urlResponse: nil, error: nil)

    override class var shared: URLSession {
        get {
            return sharedMockSession
        }
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.requestVerifier(request)

        self.completionHandler = completionHandler
        completionHandler(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        return MockTask()
    }

}
let sharedMockMultipleSession = MockMultipleSession()
class MockMultipleSession: URLSession {

    var completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?
    var responsePairs = [MockResponsePair]()

    override class var shared: URLSession {
        get {
            return sharedMockMultipleSession
        }
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if (self.responsePairs.count > 0) {
            let pair = self.responsePairs.remove(at: 0);
            pair.requestVerifier(request)
            completionHandler(pair.response.data, pair.response.urlResponse, pair.response.error)
        } else {
            assertionFailure("Invalid Mocking Detected.")
        }
        return MockTask()
    }
}
let defaults = FakeUserDefaults()
class FakeUserDefaults : UserDefaults {

    typealias FakeDefaults = Dictionary<String, Any?>
    var data : FakeDefaults

    override init?(suiteName suitename: String?) {
        data = FakeDefaults()
        super.init(suiteName: "UnitTest")
    }

    override class var standard: UserDefaults { return defaults }

    override func synchronize() -> Bool {
        return true
    }

    override func object(forKey defaultName: String) -> Any? {
        return data[defaultName] ?? nil
    }

    override func value(forKeyPath keyPath: String) -> Any? {
        return data[keyPath] ?? nil
    }
    override func value(forKey key: String) -> Any? {
        return data[key] ?? nil
    }

    override func bool(forKey defaultName: String) -> Bool {
        return data[defaultName] as! Bool
    }

    override func integer(forKey defaultName: String) -> Int {
        return data[defaultName] as! Int
    }

    override func float(forKey defaultName: String) -> Float {
        return data[defaultName] as! Float
    }

    override func dictionary(forKey defaultName: String) -> [String : Any]? {
        return data[defaultName] as? Dictionary
    }

    override func setValue(_ value: Any?, forKey key: String) {
        data[key] = value
    }
    override func set(_ url: URL?, forKey defaultName: String) {
        data[defaultName] = url
    }
    override func set(_ value: Any?, forKey defaultName: String) {
        data[defaultName] = value
    }

    override func removeObject(forKey defaultName: String) {
        data.removeValue(forKey: defaultName)
    }

}

extension UserDefaults {

    @objc class func transientDefaults() -> FakeUserDefaults {
        return FakeUserDefaults(suiteName: "UnitTest")!
    }

}

