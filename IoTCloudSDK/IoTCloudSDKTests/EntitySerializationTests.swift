//
//  EntitySerializationTests.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/7/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
import IoTCloudSDK

class EntitySerializationTests: XCTestCase {
    
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
        let key = _stdlib_getDemangledTypeName(anEntity)
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
        let anOwner = Owner(ownerID: aTypedID, accessToken: "accessToken")
        self.doSerializationTest(anOwner)
    }
    //Command
    func testCommand_NSUserDefaultSerialization() {
        let aCommand = Command()
        self.doSerializationTest(aCommand)
    }
    //Trigger
    func testTrigger_NSUserDefaultSerialization() {
        let aTrigger = Trigger()
        self.doSerializationTest(aTrigger)
    }
    //Target
    func testTarget_NSUserDefaultSerialization() {
        let aTypedID = TypedID(type: "camera", id: "cameraID")
        let aTarget = Target(targetType: aTypedID)

        self.doSerializationTest(aTarget)
    }
    
    
}
