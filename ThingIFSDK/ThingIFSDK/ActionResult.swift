//
//  ActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Result of an action. */
public struct ActionResult {

    /** Action is succeeded or not. */
    public let succeeded: Bool
    /** Name of an action. */
    public let actionName: String
    /** Data returned from thing. */
    public let data: Any?
    /** Error message. */
    public let errorMessage: String?

    /** Initialize `ActionResult`.

     Developers rarely use this initializer. If you want to recreate
     same instance from stored data or transmitted data, you can use
     this method.

     - Parameters succeeded: Action is succeeded or not
     - Parameters actionName: Name of action.
     - Parameters data: Data returned from thing.
     - Parameters errorMessage: Error message.
     */
    internal init(
      _ succeeded: Bool,
      actionName: String,
      data: Any? = nil,
      errorMessage: String? = nil)
    {
        self.succeeded = succeeded
        self.actionName = actionName
        self.data = data
        self.errorMessage = errorMessage
    }

}

extension ActionResult: FromJsonObject {

    internal init(_ jsonObject: [String : Any]) throws {
        if jsonObject.count != 1 {
            throw ThingIFError.jsonParseError
        }

        guard let actionName = jsonObject.keys.first,
              let dict = jsonObject[actionName] as? [String : Any],
              let succeeded = dict["succeeded"] as? Bool else {
            throw ThingIFError.jsonParseError
        }

        self.init(
          succeeded,
          actionName: actionName,
          data: dict["data"],
          errorMessage: dict["errorMessage"] as? String)
    }
}
