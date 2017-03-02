//
//  AliasActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Result of action for an alias. */
public struct AliasActionResult {

    /** Name of an alias. */
    public let alias: String
    /** Results of actions for an alias. */
    public let results: [ActionResult]

    /** Initialize `AliasActionResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters alias: Name of an alias.
     - Parameters results: Results of actions for an alias.
     */
    public init(_ alias: String, results: [ActionResult]) {
        self.alias = alias
        self.results = results
    }

}
