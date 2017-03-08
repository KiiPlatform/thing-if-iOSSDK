//
//  EndNode.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Represents end node. */
public struct EndNode: TargetThing, Equatable {

    /** ID of target to issue REST API. */
    public let typedID: TypedID

    /** Access token. */
    public let accessToken: String?

    /** Vendor thing id. */
    public let vendorThingID: String

    /** Init

    - Parameter thingID: ID of thing
    - Parameter vendorThingID: ID of vendor thing
    - Parameter accessToken: Access token of the target, can nil.
    */
    public init(
      _ thingID: String,
      vendorThingID : String,
      accessToken: String? = nil)
    {
        self.typedID = TypedID(TypedID.Types.thing, id: thingID)
        self.accessToken = accessToken
        self.vendorThingID = vendorThingID
    }
}

extension EndNode: JsonObjectCompatible {

    internal func makeJsonObject() -> [String : Any] {
        // This method may not use so this method is not tested.
        // If you want to use this method, please test this.

        var retval = ["thingID": self.thingID] as [String : Any]
        retval["accessToken"] = self.accessToken
        retval["vendorThingID"] = self.vendorThingID
        return retval
    }

    init(_ jsonObject: [String : Any]) throws {
        guard let thingID = jsonObject["thingID"] as? String,
              let accessToken = jsonObject["accessToken"] as? String else {
            throw ThingIFError.jsonParseError
        }

        self.init(
          thingID,
          vendorThingID: jsonObject["vendorThingID"] as! String,
          accessToken: accessToken)
    }
}
