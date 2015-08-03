//
//  TypedID.swift
//  IoTCloudSDK
//
import Foundation

/** Represents entity type and its ID. */
public class TypedID : NSObject, NSCoding {

    // MARK: - Implements NSCoding protocol
    public func encodeWithCoder(aCoder: NSCoder) {
        // TODO: implement it.
    }

    // MARK: - Implements NSCoding protocol
    public required init(coder aDecoder: NSCoder) {
        // TODO: implement it.
        type = ""
        id = ""
    }

    /** Type of the ID */
    public let type:String
    /** ID of the entity. */
    public let id:String

    /** Ininitialize TypedID with type and id.
    - Parameter type: Type of the entity.
    - Parameter id: ID of the entity.
     */
    public init(type:String, id:String) {
        self.type = type
        self.id = id
    }
}