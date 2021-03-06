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

extension EndNode: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        let thingID: String
        let accessToken: String?
        if let id = jsonObject["endNodeThingID"] as? String {
            guard let token = jsonObject["accessToken"] as? String else {
                throw ThingIFError.jsonParseError
            }
            thingID = id
            accessToken = token
        } else if let id = jsonObject["thingID"] as? String {
            thingID = id
            accessToken = nil
        } else {
            throw ThingIFError.jsonParseError
        }

        self.init(
          thingID,
          vendorThingID: jsonObject["vendorThingID"] as! String,
          accessToken: accessToken)
    }
}

extension EndNode: Serializable {

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
