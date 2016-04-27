//
//  PendingEndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class PendingEndNode: NSObject, NSCoding {
    let KEY_VENDORTHINGID = "vendorThingID"
    let KEY_THINGTYPE = "thingType"
    let KEY_THINGPROPERTIES = "thingProperties"

    public let vendorThingID: String?
    public let thingType: String?
    public let thingProperties: Dictionary<String, AnyObject>?

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.vendorThingID, forKey: KEY_VENDORTHINGID)
        aCoder.encodeObject(self.thingType, forKey: KEY_THINGTYPE)
        aCoder.encodeObject(self.thingProperties, forKey: KEY_THINGPROPERTIES)
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.vendorThingID = aDecoder.decodeObjectForKey(KEY_VENDORTHINGID) as? String
        self.thingType = aDecoder.decodeObjectForKey(KEY_THINGTYPE) as? String
        self.thingProperties = aDecoder.decodeObjectForKey(KEY_THINGPROPERTIES) as? Dictionary<String, AnyObject>
    }

    init(json: Dictionary<String, AnyObject>)
    {
        self.vendorThingID = json[KEY_VENDORTHINGID] as? String
        self.thingType = json[KEY_THINGTYPE] as? String
        self.thingProperties = json[KEY_THINGPROPERTIES] as? Dictionary<String, AnyObject>
    }
}
