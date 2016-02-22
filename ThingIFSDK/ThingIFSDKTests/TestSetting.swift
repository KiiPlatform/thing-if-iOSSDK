//
//  AppFactory.swift
//  ThingIFSDK
//
//  Copyright 2015 Kii Corp. All rights reserved.
//

import UIKit
@testable import ThingIFSDK

public class TestSetting: NSObject {

    let app:App!

    let owner:Owner!
    let ownerID:String!
    let ownerToken:String!

    let target:Target!
    let thingID:String!

    let appID:String!
    let appKey:String!
    let hostName:String!

    let api:ThingIFAPI

    let schema:String
    let schemaVersion:Int
    let thingType:String

    public override init() {
        let b:NSBundle = NSBundle(forClass:TestSetting.self)
        let path:String = b.pathForResource("testapp", ofType: "plist")!
        let dict:NSDictionary = NSDictionary(contentsOfFile: path)!

        self.appID = dict["appID"] as! String
        self.appKey = dict["appKey"] as! String
        self.hostName = dict["hostName"] as! String
        self.app = AppBuilder(appID: appID, appKey: appKey, hostName: hostName).build()

        self.ownerID = dict["ownerID"] as! String
        self.ownerToken = dict["ownerToken"] as! String
        self.owner = Owner(typedID: TypedID(type:"user", id:ownerID),
            accessToken: ownerToken)

        self.thingID = dict["thingID"] as! String
        self.target = Target(typedID: TypedID(type: "thing", id: thingID))

        self.api = ThingIFAPIBuilder(app: app, owner: owner).build()

        self.schema = dict["schema"] as! String
        self.schemaVersion = dict["schemaVersion"] as! Int
        self.thingType = dict["thingType"] as! String
    }

}
