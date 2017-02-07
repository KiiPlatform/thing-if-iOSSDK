//
//  ActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Result of an action. */
open class ActionResult: NSCoding {

    /** Action is succeeded or not. */
    open let succeeded: Bool
    /** Name of an action. */
    open let actionName: String
    /** Data returned from thing. */
    open let data: Any?
    /** Error message. */
    open let errorMessage: String?

    internal init(
      _ succeeded: Bool,
      actionName: String,
      data: Any?,
      errorMessage: String?)
    {
        self.succeeded = succeeded
        self.actionName = actionName
        self.data = data
        self.errorMessage = errorMessage
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder.decodeBool(forKey: "succeeded"),
            actionName: aDecoder.decodeObject(forKey: "actionName") as! String,
            data: aDecoder.decodeObject(forKey: "data"),
            errorMessage: aDecoder.decodeObject(forKey: "errorMessage") as? String)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.succeeded, forKey: "succeeded")
        aCoder.encode(self.actionName, forKey: "actionName")
        aCoder.encode(self.data, forKey: "data")
        aCoder.encode(self.errorMessage, forKey: "errorMessage")
    }

}
