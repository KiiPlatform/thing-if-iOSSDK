//
//  ListTriggersTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/19/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class ListTriggersTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct ExpectedTriggerStruct {
        let statement: Dictionary<String, Any>
        let triggerID: String
        let triggersWhenString: String
        let enabled: Bool

        func getPredicateDict() -> Dictionary<String, Any> {
            return ["eventSource":"STATES", "triggersWhen":triggersWhenString, "condition":statement]
        }

    }

}
