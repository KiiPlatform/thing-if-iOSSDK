//
//  TriggerOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/05.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest

@testable import ThingIFSDK

class TriggerOptionsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitWithTitle() {
        let form = TriggerOptions("title")

        XCTAssertNotNil(form)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.triggerDescription)
        XCTAssertNil(form.metadata)
    }

    func testInitWithCommandDescription() {
        let form = TriggerOptions(triggerDescription: "description")

        XCTAssertNotNil(form)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.triggerDescription, "description")
        XCTAssertNil(form.metadata)
    }

    func testInitWithMetadata() {
        let metadata: Dictionary<String, Any> = [
            "key1" : "value1",
            "key2" : "value2"
        ]
        let form = TriggerOptions(metadata: metadata)

        XCTAssertNotNil(form)
        XCTAssertNil(form.title)
        XCTAssertNil(form.triggerDescription)
        verifyDict(form.metadata!, actualDict: metadata)
    }

    func testInitWithTitleAndDescription() {
        let form = TriggerOptions("title",
                                  triggerDescription: "description")

        XCTAssertNotNil(form)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.triggerDescription, "description")
        XCTAssertNil(form.metadata)
    }

    func testInitWithTitleAndMetadata() {
        let metadata: Dictionary<String, Any> = [
            "key1" : "value1",
            "key2" : "value2"
        ]
        let form = TriggerOptions("title",
                                  metadata: metadata)

        XCTAssertNotNil(form)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.triggerDescription)
        verifyDict(form.metadata!, actualDict: metadata)
    }

    func testInitWithDescriptionAndMetadata() {
        let metadata: Dictionary<String, Any> = [
            "key1" : "value1",
            "key2" : "value2"
        ]
        let form = TriggerOptions(triggerDescription: "description",
                                  metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.triggerDescription, "description")
        verifyDict(form.metadata!, actualDict: metadata)
    }

    func testInitWithAllFields() {
        let metadata: Dictionary<String, Any> = [
            "key1" : "value1",
            "key2" : "value2"
        ]
        let form = TriggerOptions("title",
                                  triggerDescription: "description",
                                  metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.triggerDescription, "description")
        verifyDict(form.metadata!, actualDict: metadata)
    }

}
