//
//  TimeRange.swift
//  ThingIFSDK
//
//  Created on 2017/01/30.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Time range. */
open class TimeRange: NSCoding {

    /** Start point of a time range. Inclusive. */
    open let from: Date
    /** End point of a time range. Inclusive. */
    open let to: Date

    /** Initialize with form date and to date.

     - Parameter form: Start point of time range. Inclusive
     - Parameter to: End point of time range. Inclusive
     */
    public init(_ from: Date, to: Date) {
        fatalError("TODO: implement me.")
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

    public func encode(with aCoder: NSCoder) {
        fatalError("TODO: implement me.")
    }

}