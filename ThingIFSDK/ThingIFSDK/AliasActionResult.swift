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

    internal init(_ alias: String, results: [ActionResult]) {
        self.alias = alias
        self.results = results
    }

}
