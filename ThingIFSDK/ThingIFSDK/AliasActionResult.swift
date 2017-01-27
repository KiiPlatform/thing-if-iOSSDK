//
//  AliasActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Result of action for an alias. */
open class AliasActionResult: NSCoding {

    /** Name of an alias. */
    open let alias: String
    /** Results of actions for an alias. */
    open let results: [ActionResult]

    internal init(_ alias: String, results: [ActionResult]) {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }
}
