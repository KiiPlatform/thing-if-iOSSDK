//
//  AliasAction.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Action with an alias. */
public struct AliasAction {

    // MARK: - Properties

    /** Name of an alias. */
    public let alias: String
    /** Action of this alias. */
    public let actions: [(name: String, value: Any)]

    // MARK: - Initializing CommandForm instance.
    /** Initializer of AliasAction instance.

     - Parameter alias: Name of an alias.
     - Parameter actions: Actions of this alias.
       - name: name of an action
       - value: value of an action. This must be number, bool, string
         or json compatible array or dictionary
     */

    public init(_ alias: String, actions: [(name: String, value: Any)]) {
        self.alias = alias
        self.actions = actions
    }
}
