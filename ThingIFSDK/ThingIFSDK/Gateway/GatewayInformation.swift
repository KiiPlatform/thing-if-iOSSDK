//
//  GatewayInformation.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

public class GatewayInformation: NSObject, NSCoding {

    public let vendorThingID: String

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.vendorThingID, forKey: "vendorThingID")
    }

    public required init(coder aDecoder: NSCoder)
    {
        self.vendorThingID = aDecoder.decodeObjectForKey("vendorThingID") as! String
    }

    public init(vendorThingID: String)
    {
        self.vendorThingID = vendorThingID
    }
}
