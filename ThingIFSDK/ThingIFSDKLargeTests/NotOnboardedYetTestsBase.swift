//
//  NotOnboardedYetTestsBase.swift
//  ThingIFSDK
//
//  Created on 2017/03/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PathGetter: NSObject {

    fileprivate var path: String? {
        get {
            return Bundle(for: PathGetter.self).path(
              forResource: "TestSetting",
              ofType:"plist")
        }
    }
}

struct TestSetting {
    let appID: String
    let appKey: String
    let hostName: String
    let tag: String?

    init() {
        let path = PathGetter().path

        let dict = NSDictionary(
          contentsOfFile: path!) as! [String : String]

        self.appID = dict["appID"]!
        self.appKey = dict["appKey"]!
        self.hostName = dict["hostName"]!
        self.tag = nil
    }
}

class NotOnboardedYetTestsBase: XCTestCase {

    internal let TEST_TIMEOUT = 5.0
    internal let DEMO_THING_TYPE = "LED"
    internal let DEMO_SCHEMA_NAME = "SmartLightDemo"
    internal let DEMO_SCHEMA_VERSION = 1

    internal var app: KiiApp!
    internal var api: ThingIFAPI!
    internal var userInfo: [String : Any]!
    internal let setting = TestSetting()

    override func setUp() {
        super.setUp()

        let setting = self.setting
        self.userInfo = createPseudoUser(
                setting.appID,
                appKey: setting.appKey,
                hostName: setting.hostName)
        let owner = Owner(
          TypedID(
            TypedID.Types(rawValue: "user")!,
            id: self.userInfo["userID"]! as! String),
          accessToken: self.userInfo["_accessToken"]! as! String)
        self.app = KiiApp(
          setting.appID,
          appKey: setting.appKey,
          hostName: setting.hostName)
        self.api = ThingIFAPI(app, owner: owner, tag: setting.tag)
    }

    override func tearDown() {

        deletePseudoUser(
          self.setting.appID,
          appKey: self.setting.appKey,
          userID: self.userInfo["userID"] as! String,
          accessToken: self.userInfo["_accessToken"] as! String,
          hostName: self.setting.hostName)

        super.tearDown()
    }

    func createPseudoUser(
            _ appID: String,
            appKey: String,
            hostName: String) -> Dictionary<String, AnyObject>
    {
        var request = URLRequest(
          url: URL(string: "https://\(hostName)/api/apps/\(appID)/users")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
          "X-Kii-AppID" : appID,
          "X-Kii-AppKey" : appKey,
          "Content-Type" :
            "application/vnd.kii.RegistrationAndAuthorizationRequest+json",
        ]
        request.httpBody =
            ("{}" as NSString).data(using: String.Encoding.utf8.rawValue)

        let expectation = self.expectation(description: "Create user")

        let session =
            URLSession(configuration: URLSessionConfiguration.default)
        var data: Data?
        let dataTask = session.dataTask(with: request) {
            receivedData, response, error in

            data = receivedData
            expectation.fulfill()
        }
        dataTask.resume()
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }

        return try! JSONSerialization.jsonObject(
                   with: data!,
                   options:.allowFragments) as! Dictionary<String, AnyObject>
    }

    func deletePseudoUser(
            _ appID: String,
            appKey: String,
            userID: String,
            accessToken: String,
            hostName: String) -> Void
    {
        var request = URLRequest(
          url: URL(string: "https://\(hostName)/api/apps/\(appID)/users/\(userID)")!)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
          "X-Kii-AppID" : appID,
          "X-Kii-AppKey" : appKey,
          "Authorization" : "Bearer \(accessToken)"
        ]
        let expectation = self.expectation(description: "Delete user")

        let session =
            URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: request) {
            receivedData, response, error in
            XCTAssertEqual(204, (response as! HTTPURLResponse).statusCode)
            expectation.fulfill()
        }
        dataTask.resume()
        self.waitForExpectations(timeout: TEST_TIMEOUT) { error in
            XCTAssertNil(error)
        }
    }

}
