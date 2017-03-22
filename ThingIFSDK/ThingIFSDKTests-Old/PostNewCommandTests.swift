//
//  PostNewCommandTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/20/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewCommandTests: SmallTestBase {
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    struct TestCase {
        let target: Target
        let schema: String
        let schemaVersion: Int
        let actions: [Dictionary<String, Any>]
        let issuerID: TypedID
    }

}
