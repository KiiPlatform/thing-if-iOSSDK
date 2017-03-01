//
//  Target.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol representing a target to issue REST API. */
public protocol Target {

    /** ID of target to issue REST API. */
    var typedID: TypedID { get }

    /** Access token. */
    var accessToken: String? { get }

}

public extension Target where Self: Equatable {

    /** Returns a Boolean value indicating whether two values are equal.

     Equality is the inverse of inequality. For any values `a` and `b`,
     `a == b` implies that `a != b` is `false`.

     - Parameters left: A value to compare
     - Parameters right:  Another value to compare.
     - Returns: True if left and right is same, otherwise false.
     */
    public static func == (left: Self, right: Self) -> Bool {
        return left.typedID == right.typedID
    }

    /** The hash value. */
    public var hashValue: Int {
        get {
            return self.typedID.hashValue
        }
    }
}
