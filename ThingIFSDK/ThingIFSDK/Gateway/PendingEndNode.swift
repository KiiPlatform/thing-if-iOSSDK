//
//  PendingEndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class PendingEndNode: NSObject, NSCoding {
    let KEY_VENDORTHINGID = "vendorThingID"
    let KEY_THINGPROPERTIES = "thingProperties"

    public let vendorThingID: String?
    public let thingProperties: Dictionary<String, AnyObject>?

    public var thingType: String? {
        return self.thingProperties?["_thingType"] as? String
    }

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.vendorThingID, forKey: KEY_VENDORTHINGID)
        aCoder.encodeObject(self.thingProperties, forKey: KEY_THINGPROPERTIES)
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.vendorThingID = aDecoder.decodeObjectForKey(KEY_VENDORTHINGID) as? String
        self.thingProperties = aDecoder.decodeObjectForKey(KEY_THINGPROPERTIES) as? Dictionary<String, AnyObject>
    }

    init(json: Dictionary<String, AnyObject>)
    {
        self.vendorThingID = json[KEY_VENDORTHINGID] as? String
        self.thingProperties = json[KEY_THINGPROPERTIES] as? Dictionary<String, AnyObject>
    }
}
