//
//  Action.swift
//  ThingIFSDK
//
//  Created on 2017/03/15.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Action of a command. */
public struct Action {

    // MARK: - Properties

    /** Name of an action. */
    public let name: String
    /** Value of an action. */
    public let value: Any

    // MARK: - Initializing Action instance.
    /** Initializer of Action instance.

     - Parameter name: Name of an action
     - Parameter value: Value of an action. This must be number, bool,
       string or json compatible array or dictionary
     */
    public init(_ name: String, value: Any) {
        self.name = name
        self.value = value
    }
}
