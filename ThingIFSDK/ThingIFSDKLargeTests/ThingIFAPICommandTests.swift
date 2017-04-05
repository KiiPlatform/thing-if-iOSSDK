//
//  ThingIFAPICommandTests.swift
//  ThingIFSDK
//
//  Created on 2017/04/05.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPICommandTests: OnboardedTestsBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccess() {

        self.executeAsynchronous { expectation in
            self.onboardedApi.listCommands() { commands, paginationKey, error in

                XCTAssertNil(paginationKey)
                XCTAssertNil(error)
                XCTAssertNotNil(commands)
                XCTAssertEqual([], commands!)
                expectation.fulfill()
            }
        }

    }
}
