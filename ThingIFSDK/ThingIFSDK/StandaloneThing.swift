//
//  StandaloneThing.swift
//  ThingIFSDK
//
//  Copyright (c) 2016 Kii. All rights reserved.
//

import Foundation

/** Represents stand alone thing. */
open class StandaloneThing: NSObject, TargetThing {

    private let thing: ConcreteThing

    /** ID of target to issue REST API. */
    open var typedID: TypedID {
        get {
            return self.thing.typedID
        }
    }

    /** Access token. */
    open var accessToken: String? {
        get {
            return self.thing.accessToken
        }
    }

    /** Vendor thing id. */
    open var vendorThingID: String {
        get {
            return self.thing.vendorThingID
        }
    }

    /** hash value override `NSObject.hashValue`. */
    open override var hashValue: Int {
        get {
            return self.thing.hashValue
        }
    }

    /** hash value override `NSObject.hash`. */
    open override var hash: Int {
        get {
            return self.hashValue
        }
    }

    private init(_ thing: ConcreteThing) {
        self.thing = thing
    }

    /** Init

    - Parameter thingID: ID of thing
    - Parameter vendorThingID: ID of vendor thing
    - Parameter accessToken: Access token of the target, can nil.
    */
    public convenience init(
      _ thingID: String,
      vendorThingID : String,
      accessToken: String? = nil)
    {
        self.init(
          ConcreteThing(
            thingID,
            vendorThingID: vendorThingID,
            accessToken: accessToken))
    }

    // MARK: - Implements NSCoding protocol
    /** Encode `StandaloneThing`.

     - Parameter aCoder: encoder
     */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.thing)
    }

    /** Decode `StandaloneThing`.

     - Parameter aDecoder: decoder
     */
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject() as! ConcreteThing)
    }


    /** Check two `StandaloneThing` instance same or not.

     This method overrides `NSObject.isEqual(object:)`.

     - Parameter object: a object to be checked same or not.
     - Returns: If same true, otherwise false.
     */
    open override func isEqual(_ object: Any?) -> Bool {
        guard let aTarget = object as? StandaloneThing else {
            return false
        }
        return self.thing == aTarget.thing
    }

}
