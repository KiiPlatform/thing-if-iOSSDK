//
//  EntitySerializationTests.swift
//  ThingIFSDK
//
//  Created by Syah Riza on 8/7/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
@testable import ThingIFSDK

class EntitySerializationTests: SmallTestBase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func doSerializationTest<T:NSObject> (anEntity :T ){
        let data = NSKeyedArchiver.archivedDataWithRootObject(anEntity)
        let key = String(anEntity)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: key)
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            let archivedEntity = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! T
            XCTAssertTrue(anEntity == archivedEntity, "\(key) Entity should be equal")
            XCTAssertEqual(anEntity, archivedEntity, "\(key) Entity should be equal")
        }else{
            XCTFail("Serialization is failed")
        }

    }
    //TypeID
    func testTypedID_NSUserDefaultSerialization() {
        let aTypedID = TypedID(type: "camera", id: "cameraID")
        self.doSerializationTest(aTypedID)
    }
    //Owner
    func testOwner_NSUserDefaultSerialization() {
        let aTypedID = TypedID(type: "camera", id: "cameraID")
        let anOwner = Owner(typedID: aTypedID, accessToken: "accessToken")
        self.doSerializationTest(anOwner)
    }
    //Command
    func testCommand_NSUserDefaultSerialization() {
        var actionsArray = [Dictionary<String, AnyObject>]()
        var action1 = Dictionary<String, AnyObject>()
        action1["turnPower"] = ["power":true]
        actionsArray.append(action1)
        var actionsResultArray = [Dictionary<String, AnyObject>]()
        var result1 = Dictionary<String, AnyObject>()
        result1["turnPower"] = ["succeeded":true, "errorMessage":"", "data":["voltage":"125"]]
        actionsResultArray.append(result1)
        let dict = NSMutableDictionary()
        dict["commandID"] = "command-1234-5678"
        dict["schema"] = "SmartLight"
        dict["actions"] = actionsArray
        dict["actionResults"] = actionsResultArray
        dict["schemaVersion"] = 10
        dict["target"] = "thing:thing-1234-5678"
        dict["issuer"] = "user:user-1234-5678"
        dict["commandState"] = "SENDING"
        dict["firedByTriggerID"] = "trigger-0001"
        dict["createdAt"] = 1454474985010
        dict["modifiedAt"] = 1454474985020
        dict["title"] = "Command Title"
        dict["description"] = "Command Description"
        dict["metadata"] = ["sound":"noisy.mp3"]
        let aCommand = Command.commandWithNSDictionary(dict)
        self.doSerializationTest(aCommand!)
    }
    //Command Trigger state predicate
    func testCommandTrigger_State_NSUserDefaultSerialization() {
        var actionsArray = [Dictionary<String, AnyObject>]()
        var action1 = Dictionary<String, AnyObject>()
        action1["turnPower"] = ["power":true]
        actionsArray.append(action1)
        var actionsResultArray = [Dictionary<String, AnyObject>]()
        var result1 = Dictionary<String, AnyObject>()
        result1["turnPower"] = ["succeeded":true, "errorMessage":"", "data":["voltage":"125"]]
        actionsResultArray.append(result1)
        let dict = NSMutableDictionary()
        dict["commandID"] = "command-1234-5678"
        dict["schema"] = "SmartLight"
        dict["actions"] = actionsArray
        dict["actionResults"] = actionsResultArray
        dict["schemaVersion"] = 10
        dict["target"] = "thing:thing-1234-5678"
        dict["issuer"] = "user:user-1234-5678"
        dict["commandState"] = "SENDING"
        dict["title"] = "Command Title"
        dict["description"] = "Command Description"
        dict["metadata"] = ["sound":"noisy.mp3"]
        let command = Command.commandWithNSDictionary(dict)
        let condition = Condition(clause: EqualsClause(field: "field", stringValue: "1234"))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_TRUE)
        
        let aTrigger = Trigger(triggerID: "trigger-1234-5678", targetID: TypedID(type: "thing", id: "thing-1234-5678"), enabled: true, predicate: predicate, command: command!, title: "Trigger Title", triggerDescription: "Trigger Description", metadata: ["sound":"noisy.mp4"])
        self.doSerializationTest(aTrigger)
    }

    //Command Trigger Scheduled once test
    func testCommandTrigger_ScheduledOnce_NSUserDefaultSerialization() {
        var actionsArray = [Dictionary<String, AnyObject>]()
        var action1 = Dictionary<String, AnyObject>()
        action1["turnPower"] = ["power":true]
        actionsArray.append(action1)
        var actionsResultArray = [Dictionary<String, AnyObject>]()
        var result1 = Dictionary<String, AnyObject>()
        result1["turnPower"] = ["succeeded":true, "errorMessage":"", "data":["voltage":"125"]]
        actionsResultArray.append(result1)
        let dict = NSMutableDictionary()
        dict["commandID"] = "command-1234-5678"
        dict["schema"] = "SmartLight"
        dict["actions"] = actionsArray
        dict["actionResults"] = actionsResultArray
        dict["schemaVersion"] = 10
        dict["target"] = "thing:thing-1234-5678"
        dict["issuer"] = "user:user-1234-5678"
        dict["commandState"] = "SENDING"
        dict["title"] = "Command Title"
        dict["description"] = "Command Description"
        dict["metadata"] = ["sound":"noisy.mp3"]
        let command = Command.commandWithNSDictionary(dict)

        let predicate = ScheduleOncePredicate(scheduleAt: NSDate(timeIntervalSinceNow: 60*60))

        let aTrigger = Trigger(triggerID: "trigger-1234-5678", targetID: TypedID(type: "thing", id: "thing-1234-5678"), enabled: true, predicate: predicate, command: command!, title: "Trigger Title", triggerDescription: "Trigger Description", metadata: ["sound":"noisy.mp4"])
        self.doSerializationTest(aTrigger)
    }

    //ServerCode Trigger
    func testServerCodeTrigger_NSUserDefaultSerialization() {
        let parameters : Dictionary = ["arg1":"abc", "arg2":1234, "arg3":true]
        let serverCode = ServerCode(endpoint: "function_name", executorAccessToken: "123456789abcde", targetAppID: "abcdefghi", parameters: parameters)
        let condition = Condition(clause: EqualsClause(field: "field", stringValue: "1234"))
        let predicate = StatePredicate(condition: condition, triggersWhen: TriggersWhen.CONDITION_TRUE)

        let aTrigger = Trigger(triggerID: "trigger-1234-5678", targetID: TypedID(type: "thing", id: "thing-1234-5678"), enabled: true, predicate: predicate, serverCode: serverCode)
        self.doSerializationTest(aTrigger)
    }
    // ServerCode
    func testServerCode_NSUserDefaultSerialization() {
        let parameters : Dictionary = ["arg1":"abc", "arg2":1234, "arg3":true]
        let aServerCode = ServerCode(endpoint: "function_name", executorAccessToken: "123456789abcde", targetAppID: "abcdefghi", parameters: parameters)
        self.doSerializationTest(aServerCode)
    }
    // TriggeredServerCodeResult
    func testTriggeredServerCodeResult_NSUserDefaultSerialization() {
        let array : [AnyObject] = [123, 123.456, "abc", true, [123], ["f1":123]]
        let object : Dictionary<String, AnyObject> = ["f1":123, "f2":"abc", "f3":true]
        let testDataList = [
            TriggeredServerCodeResult(succeeded: true, returnedValue: nil, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func1", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: "abcd", executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func2", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: "", executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func3", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: 1234, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func4", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: 14544749850000, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func5", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: 1234.5678, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func6", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: true, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func7", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: array, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func8", error: nil),
            TriggeredServerCodeResult(succeeded: true, returnedValue: object, executedAt: NSDate(timeIntervalSince1970: 1454474985), endpoint:"func9", error: nil),
        ]
        for testData in testDataList {
            self.doSerializationTest(testData)
        }
    }
    //Target
    func testTarget_NSUserDefaultSerialization() {
        let aTarget = StandaloneThing(thingID: "cameraID", vendorThingID: "dummyVendorThingID", accessToken: nil)

        XCTAssertNil(aTarget.accessToken)

        self.doSerializationTest(aTarget)

        let aTargetWithAccessToken = StandaloneThing(thingID: "cameraID", vendorThingID: "dummyVendorThingID", accessToken: "dummyAccessToken")

        XCTAssertNotNil(aTargetWithAccessToken.accessToken)

        self.doSerializationTest(aTarget)

        XCTAssertNotEqual(aTarget, aTargetWithAccessToken)

    }
    
    
}
