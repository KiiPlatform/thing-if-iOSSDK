//
//  ConcreteThing.swift
//  ThingIFSDK
//
//  Created on 2017/02/22.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

internal class ConcreteThing: NSObject, TargetThing {

    internal let typedID: TypedID
    internal let accessToken: String?
    internal let vendorThingID: String

    internal override var hashValue: Int {
        get {
            return self.typedID.hashValue
        }
    }

    internal override var hash: Int {
        get {
            return self.hashValue
        }
    }

    internal init(
      _ thingID: String,
      vendorThingID : String,
      accessToken: String? = nil)
    {
        self.typedID = TypedID(TypedID.Types.thing, id: thingID)
        self.accessToken = accessToken
        self.vendorThingID = vendorThingID
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.typedID, forKey: "typedID")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.vendorThingID, forKey: "vendorThingID")
    }

    public required init(coder aDecoder: NSCoder) {
        self.typedID = aDecoder.decodeObject(forKey: "typedID") as! TypedID
        self.accessToken =
          aDecoder.decodeObject(forKey: "accessToken") as! String?
        self.vendorThingID =
          aDecoder.decodeObject(forKey: "vendorThingID") as! String
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let aTarget = object as? ConcreteThing else {
            return false
        }
        return self.typedID == aTarget.typedID
    }

}
