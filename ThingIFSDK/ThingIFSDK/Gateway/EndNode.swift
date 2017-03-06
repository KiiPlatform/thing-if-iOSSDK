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

extension EndNode: JsonDeserializable {

    init(_ json: [String : Any]) throws {
        guard let thingID = json["thingID"] as? String,
              let accessToken = json["accessToken"] as? String else {
            throw ThingIFError.jsonParseError
        }

        self.init(
          thingID,
          vendorThingID: json["vendorThingID"] as! String,
          accessToken: accessToken)
    }
}
