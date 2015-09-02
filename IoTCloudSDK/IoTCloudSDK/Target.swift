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
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        self.targetType = aDecoder.decodeObjectForKey("targetType") as! TypedID

    }

    /** Init with TypedID

    - Parameter targetType: ID of target
    */
    public init(targetType: TypedID) {
        self.targetType = targetType
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        guard let aTarget = object as? Target else{
            return false
        }

        return self.targetType == aTarget.targetType
    }
}