//
//  ThingIFAPIGetTargetStateTests.swift
//  ThingIFSDK
//
//  Copyright (c) 2017 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ThingIFAPIGetTargetStateTests: OnboardedTestsBase
{

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccessEmptyResults() {

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState() { results, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(0, results!.count)
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState(self.ALIAS1) { result, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(result)
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(
                            404,
                            errorCode: "STATE_NOT_FOUND",
                            errorMessage: "Thing state not found")),
                    error)
            }
        }
    }

    func testSuccess() {
        let airState : [String : Any] = [ "power" : true, "currentTemperature" : 23]
        let humState : [String : Any] = [ "currentHumidity" : 50 ]

        self.executeAsynchronous { expectation in
            self.onboardedApi.updateTargetStates(
                [
                    self.ALIAS1 : airState,
                    self.ALIAS2 : humState
                ]
            ) { error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState() { results, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(
                    [
                        self.ALIAS1 : airState,
                        self.ALIAS2 : humState
                    ] as NSDictionary,
                    results! as NSDictionary)
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState(self.ALIAS1) { result, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                XCTAssertEqual(
                    airState as NSDictionary,
                    result! as NSDictionary)
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState(self.ALIAS2) { result, error in
                defer {
                    expectation.fulfill()
                }
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                XCTAssertEqual(
                    humState as NSDictionary,
                    result! as NSDictionary)
            }
        }
    }
}
