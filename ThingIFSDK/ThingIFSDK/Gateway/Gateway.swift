//
//  Gateway.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Represents gateway. */
public struct Gateway: TargetThing, Equatable {

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

extension Gateway: FromJsonObject {

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
