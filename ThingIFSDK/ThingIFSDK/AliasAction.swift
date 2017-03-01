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
    public let action: [String : Any]

    // MARK: - Initializing CommandForm instance.
    /** Initializer of AliasAction instance.

     - Parameter alias: Name of an alias.
     - Parameter action: Action of this alias. This should be able to convert to JSON.
     */
    public init(_ alias: String, action: [String : Any]) {
        self.alias = alias
        self.action = action
    }
}
