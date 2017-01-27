//
//  ActionResult.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

open class ActionResult: NSCoding {

    open let succeeded: Bool
    open let actionName: String
    open let data: Any?
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
