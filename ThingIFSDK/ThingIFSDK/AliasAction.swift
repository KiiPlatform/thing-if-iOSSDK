//
//  AliasAction.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Action with an alias. */
open class AliasAction: NSCoding {

    /** Name of an alias. */
    open let alias: String
    /** Action of this alias. */
    open let action: [String : Any]

    public init(_ alias: String, action: [String : Any]) {
        self.alias = alias
        self.action = action
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeObject(forKey: "alias") as! String,
            action: aDecoder.decodeObject(forKey: "action") as! [String : Any])
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alias, forKey: "alias")
        aCoder.encode(self.action, forKey: "action")
    }
}
