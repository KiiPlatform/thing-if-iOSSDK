//
//  StandaloneThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class StandaloneThing: AbstractThing {

    private let accessToken: String?

    // MARK: - Implements NSCoding protocol
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String?
        super.init(coder: aDecoder)
    }

    public init(thingID: String, vendorThingID: String, accessToken: String?) {
        self.accessToken = accessToken
        super.init(thingID: thingID, vendorThingID: vendorThingID)
    }

    public override func getAccessToken() -> String? {
        return self.accessToken
    }
}
