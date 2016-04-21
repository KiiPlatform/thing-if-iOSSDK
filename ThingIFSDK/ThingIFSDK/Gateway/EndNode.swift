//
//  EndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class EndNode: NSObject, NSCoding {
    let KEY_THINGID = "thingID"
    let KEY_VENDORTHINGID = "vendorThingID"
    let KEY_THINGTYPE = "thingType"
    let KEY_THINGPROPERTIES = "thingProperties"

    public let thingID: String?
    public let vendorThingID: String?
    public let thingType: String?
    public let thingProperties: Dictionary<String, AnyObject>?

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.thingID, forKey: KEY_THINGID)
        aCoder.encodeObject(self.vendorThingID, forKey: KEY_VENDORTHINGID)
        aCoder.encodeObject(self.thingType, forKey: KEY_THINGTYPE)
        aCoder.encodeObject(self.thingProperties, forKey: KEY_THINGPROPERTIES)
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.thingID = aDecoder.decodeObjectForKey(KEY_THINGID) as? String
        self.vendorThingID = aDecoder.decodeObjectForKey(KEY_VENDORTHINGID) as? String
        self.thingType = aDecoder.decodeObjectForKey(KEY_THINGTYPE) as? String
        self.thingProperties = aDecoder.decodeObjectForKey(KEY_THINGPROPERTIES) as? Dictionary<String, AnyObject>
    }

    init(json: Dictionary<String, AnyObject>)
    {
        self.thingID = json[KEY_THINGID] as? String
        self.vendorThingID = json[KEY_VENDORTHINGID] as? String
        self.thingType = json[KEY_THINGTYPE] as? String
        self.thingProperties = json[KEY_THINGPROPERTIES] as? Dictionary<String, AnyObject>
    }
}
