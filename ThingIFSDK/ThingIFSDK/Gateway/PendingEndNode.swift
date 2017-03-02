//
//  PendingEndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public struct PendingEndNode {
    private static let KEY_VENDORTHINGID = "vendorThingID"
    private static let KEY_THINGPROPERTIES = "thingProperties"

    /** Vendor thing ID. */
    public let vendorThingID: String?
    /** Thing properties. */
    public let thingProperties: [String : Any]?
    /** Thing type. */
    public var thingType: String? {
        return self.thingProperties?["_thingType"] as? String
    }

    /** Initialize `ActionResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters vendorThingID: Vendor thing ID.
     - Parameters thingProperties: Thing properties.
     */
    public init(_ vendorThingID: String?, thingProperties: [String : Any]?) {
        self.vendorThingID = vendorThingID
        self.thingProperties = thingProperties
    }

    internal init(_ json: [String : Any])
    {
        self.init(
          json[PendingEndNode.KEY_VENDORTHINGID] as? String,
          thingProperties: json[PendingEndNode.KEY_THINGPROPERTIES]
            as? [String : Any])
    }
}
