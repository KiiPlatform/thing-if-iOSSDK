//
//  PostNewTriggerTests.swift
//  ThingIFSDK
//
//  Created by Yongping on 8/14/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class PostNewTriggerTests: SmallTestBase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct TestCase {
        var clause: Clause?
        var expectedClauseDict: Dictionary<String, Any>?
        var triggersWhen: TriggersWhen?
        var expectedTriggersWhenString: String?
        var expectedScheduleAt : Date? = nil
        // State predicate
        init(clause: Clause , expectedClauseDict: Dictionary<String, Any>?, triggersWhen: TriggersWhen,
             expectedTriggersWhenString: String?){
            self.clause = clause
            self.expectedClauseDict = expectedClauseDict
            self.triggersWhen = triggersWhen
            self.expectedTriggersWhenString = expectedTriggersWhenString
        }
        init(expectedScheduleAt: Date?){
            self.expectedScheduleAt = expectedScheduleAt
        }
    }


}
