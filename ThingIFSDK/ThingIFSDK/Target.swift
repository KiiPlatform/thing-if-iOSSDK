//
//  Target.swift
//  ThingIFSDK
//
import Foundation

/** Represents Target */
public class Target : NSObject, NSCoding {
    public var typedID: TypedID
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.typedID, forKey: "typedID")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.typedID = aDecoder.decodeObjectForKey("typedID") as! TypedID
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String?
    }

    /** Access token of the target. */
    public let accessToken: String?

    /** Init with TypedID

    - Parameter typedID: ID of target
    - Parameter accessToken: Access token of the target, can nil.
    */
    public init(typedID: TypedID, accessToken : String? = nil) {
        self.typedID = typedID
        self.accessToken = accessToken
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTarget = object as? Target else{
            return false
        }

        return self.typedID == aTarget.typedID && self.accessToken == aTarget.accessToken
    }
}