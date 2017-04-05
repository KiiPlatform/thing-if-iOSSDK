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
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(0, results!.count)

                expectation.fulfill()
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState(self.ALIAS1) { result, error in
                XCTAssertNil(result)
                XCTAssertEqual(
                    ThingIFError.errorResponse(
                        required: ErrorResponse(
                            404,
                            errorCode: "STATE_NOT_FOUND",
                            errorMessage: "Thing state not found")),
                    error)

                expectation.fulfill()
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
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState() { results, error in
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                XCTAssertEqual(2, results!.count)
                XCTAssertEqual(
                    airState as NSDictionary,
                    results![self.ALIAS1]! as NSDictionary)
                XCTAssertEqual(
                    humState as NSDictionary,
                    results![self.ALIAS2]! as NSDictionary)

                expectation.fulfill()
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState(self.ALIAS1) { result, error in
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                XCTAssertEqual(
                    airState as NSDictionary,
                    result! as NSDictionary)

                expectation.fulfill()
            }
        }

        self.executeAsynchronous { expectation in

            self.onboardedApi.getTargetState(self.ALIAS2) { result, error in
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                XCTAssertEqual(
                    humState as NSDictionary,
                    result! as NSDictionary)

                expectation.fulfill()
            }
        }
    }
}
