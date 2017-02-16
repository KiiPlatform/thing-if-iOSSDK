//
//  AliasActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Result of action for an alias. */
open class AliasActionResult: NSObject, NSCoding {

    /** Name of an alias. */
    open let alias: String
    /** Results of actions for an alias. */
    open let results: [ActionResult]

    internal init(_ alias: String, results: [ActionResult]) {
        self.alias = alias
        self.results = results
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          aDecoder.decodeObject(forKey: "alias") as! String,
          results: aDecoder.decodeObject(forKey: "results") as! [ActionResult])
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.alias, forKey: "alias")
        aCoder.encode(self.results, forKey: "results")
    }
}
