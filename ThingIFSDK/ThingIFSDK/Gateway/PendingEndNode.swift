//
//  PendingEndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public struct PendingEndNode {

    /** Vendor thing ID. */
    public let vendorThingID: String
    /** Thing type. */
    public let thingType: String?
    /** Thing properties. */
    public let thingProperties: [String : Any]?
    /** Firmware version. */
    public let firmwareVersion: String?

    /** Initialize `ActionResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters vendorThingID: Vendor thing ID.
     - Parameters thingProperties: Thing properties.
     */
    public init(
      _ vendorThingID: String,
      thingType: String? = nil,
      thingProperties: [String : Any]? = nil,
      firmwareVersion: String? = nil)
    {
        self.vendorThingID = vendorThingID
        self.thingType = thingType
        self.thingProperties = thingProperties
        self.firmwareVersion = firmwareVersion
    }

}

extension PendingEndNode: ToJsonObject {

    internal func makeJsonObject() -> [String : Any]{
        var retval: [String : Any] =
          ["endNodeVendorThingID" : self.vendorThingID ]
        retval["endNodeThingType"] = self.thingType
        retval["endNodeThingProperties"] = self.thingProperties
        retval["endNodeFirmwareVersion"] = self.firmwareVersion
        return retval
    }
}
