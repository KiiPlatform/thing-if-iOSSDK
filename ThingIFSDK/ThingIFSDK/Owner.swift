//
//  Owner.swift
//  ThingIFSDK
//

import Foundation

/** Represents Owner */
public struct Owner: Hashable {

    // MARK: Properties
    /** ID of the owner. */
    public let typedID: TypedID
    /** Access token of the owner. */
    public let accessToken: String

    /** The hash value. */
    public var hashValue: Int {
        get {
            return self.typedID.hashValue
        }
    }

    // MARK: Initilization
    /** instantiate Owner.

    - Parameter typedID: ID of the Owner.
    - Parameter accessToken: Access Token of the Owner.
     */
    public init(_ typedID: TypedID, accessToken: String) {
        self.typedID = typedID
        self.accessToken = accessToken
    }

    /** Returns a Boolean value indicating whether two values are equal.

     Equality is the inverse of inequality. For any values `a` and `b`,
     `a == b` implies that `a != b` is `false`.

     - Parameters left: A value to compare
     - Parameters right:  Another value to compare.
     - Returns: True if left and right is same, otherwise false.
     */
    public static func == (left: Owner, right: Owner) -> Bool {
        return left.typedID == right.typedID
    }

}

extension Owner: Serializable {

    internal func serialize(_ coder: inout Coder) -> Void {
        coder.encode(self.typedID, forKey: "typedID")
        coder.encode(self.accessToken, forKey: "accessToken")
    }

    internal static func deserialize(_ decoder: Decoder) -> Serializable? {
        return self.init(
          decoder.decodeSerializable(forKey: "typedID") as! TypedID,
          accessToken: decoder.decodeString(forKey: "accessToken")!)
    }
}
