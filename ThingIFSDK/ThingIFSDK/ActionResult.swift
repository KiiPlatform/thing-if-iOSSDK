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
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}
