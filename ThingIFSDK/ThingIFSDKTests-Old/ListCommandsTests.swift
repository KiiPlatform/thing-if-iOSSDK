//
//  ListCommandsTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/20/15.
//  Copyright © 2015 Kii. All rights reserved.
//
import XCTest
@testable import ThingIFSDK

class ListCommandsTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    struct CommandStruct {
        let target: Target
        let commandID: String
        let schema: String
        let schemaVersion: Int
        let actions: [Dictionary<String, Any>]
        let actionResults: [Dictionary<String, Any>]?
        let commandState: CommandState
        let commandStateString: String
        let issuerID: TypedID

        func getCommandDict() -> [String: Any] {
            var dict: [String: Any] = ["commandID": commandID, "schema": schema, "schemaVersion": schemaVersion, "target": "\(target.typedID.type):\(target.typedID.id)", "commandState": commandStateString, "issuer": "\(issuerID.type):\(issuerID.id)", "actions": actions]
            if actionResults != nil {
                dict["actionResults"] = actionResults!
            }
            return dict
        }
    }
    struct TestCase {
        let paginationKey: String? // for request as parameter
        let commands: [CommandStruct]
        let target: Target
        let bestEffortLimit: Int?
        let nextPaginationKey: String? // for response

        init(commands: [CommandStruct], target: Target, nextPaginationKey: String?,  paginationKey: String?, bestEffortLimit: Int?) {
            self.commands = commands
            self.target = target
            self.paginationKey = paginationKey
            self.bestEffortLimit = bestEffortLimit
            self.nextPaginationKey = nextPaginationKey
        }
    }

    
}
