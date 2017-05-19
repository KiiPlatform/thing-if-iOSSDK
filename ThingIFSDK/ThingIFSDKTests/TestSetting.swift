//
//  AppFactory.swift
//  ThingIFSDK
//
//  Copyright 2015 Kii Corp. All rights reserved.
//

import UIKit
@testable import ThingIF

open class TestSetting {

    let app: KiiApp
    let owner: Owner
    let target: Target
    let api: ThingIFAPI
    let thingType: String

    public init() {
        let b:Bundle = Bundle(for:TestSetting.self)
        let path:String = b.path(forResource: "testapp", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path) as! [String : Any]

        self.app = KiiApp(
          dict["appID"] as! String,
          appKey: dict["appKey"] as! String,
          hostName: dict["hostName"] as! String)

        self.owner = Owner(
          TypedID(.user, id: dict["ownerID"] as! String),
          accessToken: dict["ownerToken"] as! String)

        self.target = StandaloneThing(
          dict["thingID"] as! String,
          vendorThingID: dict["ownerID"] as! String,
          accessToken: dict["ownerToken"] as? String)

        self.api = ThingIFAPI(app, owner: owner)

        self.thingType = dict["thingType"] as! String
    }

}
