//
//  GatewayInformation.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

open class GatewayInformation {

    open let vendorThingID: String

    internal init(vendorThingID: String)
    {
        self.vendorThingID = vendorThingID
    }
}
