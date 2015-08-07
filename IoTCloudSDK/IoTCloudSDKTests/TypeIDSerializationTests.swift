//
//  TypeIDSerializationTests.swift
//  IoTCloudSDK
//
//  Created by Syah Riza on 8/7/15.
//  Copyright © 2015 Kii. All rights reserved.
//

import XCTest
import IoTCloudSDK

class TypeIDSerializationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNSUserDefaultSerialization() {
        let aTypeID = TypedID(type: "camera", id: "cameraID")
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(aTypeID)
        
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "aTypeID")
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("aTypeID") as? NSData {
            let archivedTypeID = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! TypedID
            
            XCTAssertEqual(aTypeID.type, archivedTypeID.type, "Type should be equal")
            XCTAssertEqual(aTypeID.id, archivedTypeID.id, "Id should be equal")
        }else{
            XCTFail("Serialization is failed")
        }
    }

    
}
