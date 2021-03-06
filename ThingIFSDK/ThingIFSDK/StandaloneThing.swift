//
//  StandaloneThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Represents stand alone thing. */
public struct StandaloneThing: TargetThing, Equatable {

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

extension StandaloneThing: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
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

extension StandaloneThing: Serializable {

    internal func serialize(_ coder: inout Coder) -> Void {
        coder.encode(self.thingID, forKey: "thingID")
        coder.encode(self.accessToken, forKey: "accessToken")
        coder.encode(self.vendorThingID, forKey: "vendorThingID")
    }

    internal static func deserialize(_ decoder: Decoder) -> Serializable? {
        return self.init(
          decoder.decodeString(forKey: "thingID")!,
          vendorThingID: decoder.decodeString(forKey: "vendorThingID")!,
          accessToken: decoder.decodeString(forKey: "accessToken"))

    }
}
