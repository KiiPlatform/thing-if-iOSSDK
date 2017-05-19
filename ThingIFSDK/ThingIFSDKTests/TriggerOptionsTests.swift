//
//  TriggerOptionsTests.swift
//  ThingIFSDK
//
//  Created on 2016/10/05.
//  Copyright (c) 2016 Kii. All rights reserved.
//

import XCTest

@testable import ThingIF

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
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggerOptions(metadata: metadata)

        XCTAssertNotNil(form)
        XCTAssertNil(form.title)
        XCTAssertNil(form.triggerDescription)
        XCTAssertEqual(form.metadata as! [String : String], metadata)
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
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggerOptions("title",
                                  metadata: metadata)

        XCTAssertNotNil(form)
        XCTAssertEqual(form.title, "title")
        XCTAssertNil(form.triggerDescription)
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

    func testInitWithDescriptionAndMetadata() {
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggerOptions(triggerDescription: "description",
                                  metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertNil(form.title)
        XCTAssertEqual(form.triggerDescription, "description")
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

    func testInitWithAllFields() {
        let metadata = ["key1" : "value1", "key2" : "value2"]
        let form = TriggerOptions("title",
                                  triggerDescription: "description",
                                  metadata: metadata)
        XCTAssertNotNil(form)
        XCTAssertEqual(form.title, "title")
        XCTAssertEqual(form.triggerDescription, "description")
        XCTAssertEqual(form.metadata as! [String : String], metadata)
    }

}
