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
    public let actions: [Action]

    // MARK: - Initializing CommandForm instance.
    /** Initializer of AliasAction instance.

     - Parameter alias: Name of an alias.
     - Parameter actions: Actions of this alias. must not be empty.
     */

    public init(_ alias: String, actions: [Action]) {
        self.alias = alias
        self.actions = actions
    }

    /** Initializer of AliasAction instance.

     - Parameter alias: Name of an alias.
     - Parameter actions: Actions of this alias.
     */
    public init(_ alias: String, actions: Action...) {
        self.alias = alias
        self.actions = actions
    }

}
