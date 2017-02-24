//
//  Target.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Protocol representing a target to issue REST API. */
public protocol Target: class, NSCoding {

    /** ID of target to issue REST API. */
    var typedID: TypedID { get }

    /** Access token. */
    var accessToken: String? { get }
}

public extension Target {

    /** Check two `Target` subclass is same or not.

     Two object is same if and only if these two class are same type
     and their `Target.typedID` is same.

     - Parameter object: a object to be checked same or not.
     - Returns: If same true, otherwise false.
     */
    public func isSameTarget<T>(_ object: T)-> Bool
      where T: Target, T: Equatable
    {
        if !(type(of: self) === type(of: object)) {
            return false
        }
        return self.typedID == object.typedID
    }

}
