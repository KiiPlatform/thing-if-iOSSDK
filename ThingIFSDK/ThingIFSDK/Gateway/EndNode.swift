//
//  EndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class EndNode: NSObject, NSCoding {
    let key_thingID = "thingID"
    let key_vendorThingID = "vendorThingID"
    let key_thingType = "thingType"
    let key_thingProperties = "thingProperties"

    public let thingID: String?
    public let vendorThingID: String?
    public let thingType: String?
    public let thingProperties: Dictionary<String, AnyObject>?

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.thingID, forKey: key_thingID)
        aCoder.encodeObject(self.vendorThingID, forKey: key_vendorThingID)
        aCoder.encodeObject(self.thingType, forKey: key_thingType)
        aCoder.encodeObject(self.thingProperties, forKey: key_thingProperties)
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.thingID = aDecoder.decodeObjectForKey(key_thingID) as? String
        self.vendorThingID = aDecoder.decodeObjectForKey(key_vendorThingID) as? String
        self.thingType = aDecoder.decodeObjectForKey(key_thingType) as? String
        self.thingProperties = aDecoder.decodeObjectForKey(key_thingProperties) as? Dictionary<String, AnyObject>
    }

    init(json: Dictionary<String, AnyObject>)
    {
        self.thingID = json[key_thingID] as? String
        self.vendorThingID = json[key_vendorThingID] as? String
        self.thingType = json[key_thingType] as? String
        self.thingProperties = json[key_thingProperties] as? Dictionary<String, AnyObject>
    }
}