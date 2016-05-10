//
//  StandaloneThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class StandaloneThing: AbstractThing {
    private let _accessToken: String?

    public override var accessToken: String? {
        return self._accessToken
    }

    // MARK: - Implements NSCoding protocol
    public override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self._accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self._accessToken = aDecoder.decodeObjectForKey("accessToken") as! String?
        super.init(coder: aDecoder)
    }

    public init(thingID: String, vendorThingID: String, accessToken: String?) {
        self._accessToken = accessToken
        super.init(thingID: thingID, vendorThingID: vendorThingID)
    }
}
