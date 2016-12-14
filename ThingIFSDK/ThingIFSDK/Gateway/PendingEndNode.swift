//
//  PendingEndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class PendingEndNode: NSObject, NSCoding {
    let KEY_VENDORTHINGID = "vendorThingID"
    let KEY_THINGPROPERTIES = "thingProperties"

    open let vendorThingID: String?
    open let thingProperties: Dictionary<String, Any>?

    open var thingType: String? {
        return self.thingProperties?["_thingType"] as? String
    }

    // MARK: - Implements NSCoding protocol
    open func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.vendorThingID, forKey: KEY_VENDORTHINGID)
        aCoder.encode(self.thingProperties, forKey: KEY_THINGPROPERTIES)
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.vendorThingID = aDecoder.decodeObject(forKey: KEY_VENDORTHINGID) as? String
        self.thingProperties = aDecoder.decodeObject(forKey: KEY_THINGPROPERTIES) as? Dictionary<String, Any>
    }

    init(json: Dictionary<String, Any>)
    {
        self.vendorThingID = json[KEY_VENDORTHINGID] as? String
        self.thingProperties = json[KEY_THINGPROPERTIES] as? Dictionary<String, Any>
    }
}
