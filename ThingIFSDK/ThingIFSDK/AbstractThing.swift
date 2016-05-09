//
//  AbstructThing.swift
//  ThingIFSDK
//
import Foundation

/** Represents Target */
public class AbstractThing : NSObject, TargetThing {
    private var typedID: TypedID
    private var vendorThingID: String

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.typedID, forKey: "typedID")
        aCoder.encodeObject(self.vendorThingID, forKey: "vendorThingID")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.typedID = aDecoder.decodeObjectForKey("typedID") as! TypedID
        self.vendorThingID = aDecoder.decodeObjectForKey("vendorThingID") as! String
    }

    public func getTypedID() -> TypedID {
        return self.typedID
    }

    public func getThingID() -> String {
        return self.typedID.id
    }

    public func getVendorThingID() -> String {
        return self.vendorThingID
    }

    public func getAccessToken() -> String? {
        return nil
    }

    /** Init with TypedID

    - Parameter typedID: ID of target
    - Parameter accessToken: Access token of the target, can nil.
    */
    public init(thingID: String, vendorThingID : String) {
        self.typedID = TypedID(type: "THING", id: thingID)
        self.vendorThingID = vendorThingID
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTarget = object as? AbstractThing else {
            return false
        }
        return self.typedID == aTarget.typedID && self.getAccessToken() == aTarget.getAccessToken()
    }
}
