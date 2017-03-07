//
//  TargetThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol representing target thing.*/
public protocol TargetThing: Target {

    /** Thing id. */
    var thingID: String { get }

    /** Vendor thing id. */
    var vendorThingID: String { get }
}

public extension TargetThing {

    /** Thing ID.

     This equals to `TypedID.id` in `Target.typedID`.
     */
    public var thingID: String {
        get {
            return self.typedID.id
        }
    }

}

internal func makeTargetThing(
  _ json: [String : Any],
  layoutPosition: LayoutPosition,
  vendorThingID: String? = nil) throws -> TargetThing
{
    json["vendorThingID"] = vendorThingID ?? ""

    switch (layoutPosition) {
    case .standalone:
        return try StandaloneThing(jsonWithVendorThingID)
    case .gateway:
        return try Gateway(jsonWithVendorThingID)
    case .endnode:
        return try EndNode(jsonWithVendorThingID)
    }
}
