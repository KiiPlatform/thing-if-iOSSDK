//
//  GatewayAPILoadInstanceError.swift
//  ThingIFSDK
//
//  Created by syahRiza on 2017/04/14.
//  Copyright © 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class GatewayAPILoadInstanceErrorTests: SmallTestBase {
    override func setUp() {
        super.setUp()
        //removing all gateway stored instance
        GatewayAPI.removeAllStoredInstances()

    }

    func testLoadStoredInstanceError(){

        //load stored instance should throw error
        XCTAssertThrowsError(try GatewayAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
                ThingIFError.apiNotStored(tag: nil),
                error as? ThingIFError)
        }
    }

    func testLogin400Error() throws {

        let expectation = self.expectation(description: "testLogin400Error")
        let setting = TestSetting()

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

        let gatewayAPI = GatewayAPI(
            setting.app,
            gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login("dummyUser", password: "dummyPass") {_ in expectation.fulfill() }

        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }

        //load stored instance should throw error
        XCTAssertThrowsError(try GatewayAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
                ThingIFError.apiNotStored(tag: nil),
                error as? ThingIFError)
        }

    }

    func testLogin401Error() throws {
        let expectation = self.expectation(description: "testLogin401Error")
        let setting = TestSetting()

        // mock response
        sharedMockSession.mockResponse = (
            nil,
            HTTPURLResponse(
                url: URL(string:setting.app.baseURL)!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil),
            nil)
        iotSession = MockSession.self

        let gatewayAPI = GatewayAPI(
            setting.app,
            gatewayAddress: URL(string: setting.app.baseURL)!)
        gatewayAPI.login("dummyUser", password: "dummyPass") {_ in expectation.fulfill() }
        
        self.waitForExpectations(timeout: 20.0) { (error) -> Void in
            XCTAssertNil(error)
        }

        //load stored instance should throw error
        XCTAssertThrowsError(try GatewayAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
                ThingIFError.apiNotStored(tag: nil),
                error as? ThingIFError)
        }
        
    }

}
