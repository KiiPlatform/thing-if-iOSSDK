//
//  TypedID.swift
//  ThingIFSDK
//
import Foundation

/** Represents entity type and its ID. */
public struct TypedID: Equatable {

    public enum Types: String {
        /** User type. */
        case user = "user"
        /** Group type. */
        case group = "group"
        /** Thing type. */
        case thing = "thing"

    }

    /** Type of the ID*/
    public let type: Types
    /** ID of the entity. */
    public let id: String

    /** Hash value for `TypedID` instance. */
    public var hashValue: Int {
        get {
            return self.toString().hashValue
        }
    }

    /** Ininitialize TypedID with type and id.

    - Parameter type: Type of the entity.
    - Parameter id: ID of the entity.
     */
    public init(_ type:Types, id:String) {
        self.type = type
        self.id = id
    }

    internal func toString() -> String {
        return "\(type):\(id)"
    }

    /** Returns a Boolean value indicating whether two values are equal.

     Equality is the inverse of inequality. For any values `a` and `b`,
     `a == b` implies that `a != b` is `false`.

     - Parameters left: A value to compare
     - Parameters right:  Another value to compare.
     - Returns: True if left and right is same, otherwise false.
     */
    public static func ==(left: TypedID, right: TypedID) -> Bool {
        return left.id == right.id && left.type == right.type
    }

}

extension TypedID: Serializable {

    internal func serialize(_ coder: inout Coder) -> Void {
        coder.encode(self.type.rawValue, forKey: "type")
        coder.encode(self.id, forKey: "id")
    }

    internal static func deserialize(_ decoder: Decoder) -> Serializable? {
        return self.init(
          Types(rawValue: decoder.decodeString(forKey: "type")!)!,
          id: decoder.decodeString(forKey: "id")!)
    }
}
