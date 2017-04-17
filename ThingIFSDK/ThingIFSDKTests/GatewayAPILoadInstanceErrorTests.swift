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

    func testLoadStoredInstanceError(){
        //removing all gateway stored instance
        GatewayAPI.removeAllStoredInstances()
        //load stored instance should throw error
        XCTAssertThrowsError(try GatewayAPI.loadWithStoredInstance()) { error in
            XCTAssertEqual(
                ThingIFError.apiNotStored(tag: nil),
                error as? ThingIFError)
        }
    }
}
