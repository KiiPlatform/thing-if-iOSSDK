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
     - Parameter value: Value of an action. Type must be any of
       number, bool, string or json compatible array/dictionary
     */
    public init(_ name: String, value: Any) {
        self.name = name
        self.value = value
    }
}

extension Action: FromJsonObject, ToJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        if jsonObject.count != 1 {
            throw ThingIFError.jsonParseError
        }

        guard let name = jsonObject.keys.first,
              let value = jsonObject[name] else {
            throw ThingIFError.jsonParseError
        }

        self.init(name, value: value)
    }

    public func makeJsonObject() -> [String : Any] {
        return [self.name : self.value]
    }
}
