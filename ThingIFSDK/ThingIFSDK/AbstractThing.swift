//
//  AbstructThing.swift
//  ThingIFSDK
//
import Foundation

/** Represents Target */
public class AbstractThing : NSObject, TargetThing {
    public let typedID: TypedID
    public let accessToken: String?
    public var thingID: String {
        return self.typedID.id
    }
    public let vendorThingID: String

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.typedID, forKey: "typedID")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
        aCoder.encodeObject(self.vendorThingID, forKey: "vendorThingID")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.typedID = aDecoder.decodeObjectForKey("typedID") as! TypedID
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String?
        self.vendorThingID = aDecoder.decodeObjectForKey("vendorThingID") as! String
    }

    /** Init

    - Parameter thingID: ID of thing
    - Parameter vendorThingID: ID of vendor thing
    - Parameter accessToken: Access token of the target, can nil.
    */
    public init(thingID: String, vendorThingID : String, accessToken: String? = nil) {
        self.typedID = TypedID(type: "THING", id: thingID)
        self.accessToken = accessToken
        self.vendorThingID = vendorThingID
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTarget = object as? AbstractThing else {
            return false
        }
        return self.typedID == aTarget.typedID && self.accessToken == aTarget.accessToken
    }
}
