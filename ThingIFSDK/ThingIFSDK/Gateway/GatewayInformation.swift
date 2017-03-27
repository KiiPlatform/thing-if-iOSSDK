//
//  GatewayInformation.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Gateway inforamtion. */
public struct GatewayInformation {

    /* Vendor thing ID.*/
    public let vendorThingID: String

    /** Initialize `GatewayInformation`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters vendorThingID: Vendor thing ID.
     */
    public init(_ vendorThingID: String)
    {
        self.vendorThingID = vendorThingID
    }
}

extension GatewayInformation: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        self.init(jsonObject["vendorThingID"] as! String)
    }
}
