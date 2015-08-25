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

    public init(targetType: TypedID) {
        self.targetType = targetType
    }

}