//
//  Target.swift
//  IoTCloudSDK
//
import Foundation

/** Represents Target */
public class Target : NSObject, NSCoding {
    public var targetType: TypedID
    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.targetType, forKey: "targetType")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.targetType = aDecoder.decodeObjectForKey("targetType") as! TypedID
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String?
    }

    /** Access token of the target. */
    public let accessToken: String?

    /** Init with TypedID

    - Parameter targetType: ID of target
    - Parameter accessToken: Access token of the target, can nil.
    */
    public init(targetType: TypedID, accessToken : String? = nil) {
        self.targetType = targetType
        self.accessToken = accessToken
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTarget = object as? Target else{
            return false
        }

        return self.targetType == aTarget.targetType && self.accessToken == aTarget.accessToken
    }
}